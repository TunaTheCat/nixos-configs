{ inputs, ... }:
{
  flake.modules.homeManager.agents =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gemini-cli
      ] ++ [
        inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.docker-sbx
      ];
    };
}
