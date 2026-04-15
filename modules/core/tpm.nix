{...}:
{
  # TPM2 auto-unlock for the LUKS root.
  #
  # The disk key is sealed by the TPM against PCR 7 (Secure Boot policy).
  # Lanzaboote signs the UKI, so kernel updates do NOT change PCR 7 — only
  # disabling Secure Boot or changing its keys would, and that's exactly the
  # tampering we want the TPM to refuse to unseal against.
  #
  # The original passphrase keyslot is preserved as a recovery fallback —
  # systemd-cryptsetup tries TPM2 first, falls back to passphrase on failure.
  #
  # One-time enrollment after the next rebuild (run as root):
  #   systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
  #     /dev/disk/by-uuid/21e78e14-ab2b-4857-aa46-553eeec6f345
  # Then verify with:
  #   cryptsetup luksDump /dev/disk/by-uuid/21e78e14-ab2b-4857-aa46-553eeec6f345
  # (you should see two keyslots, one tagged systemd-tpm2)

  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices."luks-21e78e14-ab2b-4857-aa46-553eeec6f345".crypttabExtraOpts = [
    "tpm2-device=auto"
  ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
