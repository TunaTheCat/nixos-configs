{pkgs, inputs, ...}:
{
  home.packages = with pkgs; [
    gemini-cli
  ] ++ [
    inputs.claude-code-nix.packages.${pkgs.system}.claude-code
  ];
}
