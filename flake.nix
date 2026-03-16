{
  description = "jb's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";

    nur.url = "github:nix-community/NUR";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.11";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    { self, nixpkgs, stylix, ... }@inputs: 
    let
      username = "jb";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nix-home = nixpkgs.lib.nixosSystem {
          modules = [
          ./hosts/tower
          stylix.nixosModules.stylix
          inputs.lanzaboote.nixosModules.lanzaboote
          {nixpkgs.hostPlatform = system;}
          ];
          specialArgs = {
            host = "nix-home";
            inherit self inputs username;
          };
        };
      };
  };
}
