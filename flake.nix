{
  description = "Custom NixOS ISOs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixos-generators.url = "github:nix-community/nixos-generators";
  inputs.nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nixos-generators,
  }: let
    SYSTEMS = [
      flake-utils.lib.system.x86_64-linux
      # TODO - Work on Darwin and get the installer working properly
      # flake-utils.lib.system.x86_64-darwin
    ];
  in (flake-utils.lib.eachSystem SYSTEMS (
    system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        iso = nixos-generators.nixosGenerate {
          inherit system;
          format = "iso";

          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

            (
              {pkgs, ...}: {
                environment.systemPackages = with pkgs; [
                  git
                ];
              }
            )
          ];

        };
      };
    }
  ));
}
