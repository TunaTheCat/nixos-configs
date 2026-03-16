{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_24
    dotenvx
    python3
  ];
}
