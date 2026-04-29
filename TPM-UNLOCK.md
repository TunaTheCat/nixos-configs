# TPM2 LUKS Auto-Unlock

The root LUKS volume unlocks itself at boot via the TPM, so the machine
recovers from reboots (planned or watchdog-triggered) without anyone typing
the passphrase at the console.

The original passphrase keyslot is **kept** as a recovery fallback. If the
TPM ever refuses to unseal (BIOS update, Secure Boot keys changed, mainboard
RMA, etc.), `systemd-cryptsetup` falls back to prompting for the passphrase
automatically.

Relevant config:

- `modules/core/tpm.nix` — enables systemd in stage-1 initrd, sets the
  `tpm2-device=auto` crypttab option on the LUKS device, enables
  `security.tpm2`.
- `modules/core/watchdog.nix` — hardware watchdog, so the box reboots itself
  on a kernel hang (the reason TPM unlock matters in the first place).

## How it works

The disk key is sealed by the TPM against **PCR 7** (Secure Boot policy).
Lanzaboote signs the UKI, so kernel/initrd updates do **not** change PCR 7.
What does change PCR 7:

- Secure Boot toggled off/on in firmware
- Secure Boot keys re-enrolled (`sbctl enroll-keys ...`)
- BIOS reset / CMOS clear
- Mainboard replacement

Any of those → TPM refuses to unseal → fallback to passphrase prompt at the
console → after that boot, re-enroll (see "Re-enroll after PCR change" below).

## Initial enrollment (already done on `nix-home`)

For a new host, after Secure Boot is set up and lanzaboote is in use:

```bash
# 1. Confirm Secure Boot is actually enabled — PCR 7 binding is meaningless otherwise.
sudo sbctl status     # want: Secure Boot ✓ Enabled, Setup Mode ✓ Disabled

# 2. Build the config that adds tpm.nix + watchdog.nix.
git -C ~/.dotfiles add modules/core/tpm.nix modules/core/watchdog.nix modules/core/default.nix
sudo nixos-rebuild switch --flake ~/.dotfiles#<host>

# 3. Enroll the TPM2 keyslot (will prompt for the existing LUKS passphrase once).
#    Replace UUID with the LUKS device UUID from hardware-configuration.nix.
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-uuid/<luks-uuid>

# 4. Verify two keyslots and a systemd-tpm2 token.
sudo cryptsetup luksDump /dev/disk/by-uuid/<luks-uuid> | grep -E '^\s+[0-9]+:|systemd-tpm2'
```

Reboot. The boot should go straight from the lanzaboote/UKI screen to greetd
with no LUKS prompt.

## Re-enroll after PCR change

When PCR 7 changes (BIOS update, sbctl key re-enrollment, etc.), you'll get
the passphrase prompt at the console on next boot. After logging in:

```bash
sudo systemd-cryptenroll \
  --wipe-slot=tpm2 \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/disk/by-uuid/<luks-uuid>
```

`--wipe-slot=tpm2` removes the stale TPM2 keyslot before enrolling the new
one, so you don't accumulate dead slots.

## Rollback / disable

To temporarily disable TPM unlock without losing the keyslot:

```nix
# in modules/core/tpm.nix, comment out or remove the crypttabExtraOpts line:
# boot.initrd.luks.devices."luks-...".crypttabExtraOpts = [ "tpm2-device=auto" ];
```

To remove the TPM2 keyslot entirely:

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-uuid/<luks-uuid>
```

The passphrase keyslot is untouched by either operation.

## Threat model — what this changes

- **Disk pulled out, read elsewhere** → still encrypted. Key is in the TPM,
  not on disk.
- **Whole machine stolen, attacker boots from USB** → PCR 7 differs (or
  Secure Boot is off), TPM refuses to unseal. Disk stays encrypted.
- **Bootloader/kernel tampered with** → Secure Boot rejects unsigned UKI;
  if SB is bypassed, PCR 7 differs and TPM refuses anyway.
- **Whole machine stolen powered-on, or attacker reboots and lets it boot
  normally** → disk unlocks. Only the user login (greetd) stands between
  attacker and data. This is the trade-off vs. passphrase-at-boot.

For a desktop at home accessed remotely via Tailscale, that trade is usually
worth it. For a laptop you carry around, prefer `--tpm2-with-pin=yes` (TPM
rate-limits brute force on a short PIN).
