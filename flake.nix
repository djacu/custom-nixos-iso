{
  description = "Custom NixOS ISOs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: {
    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    nixosConfigurations = let
      # Shared base configuration.
      exampleBase = {
        system = "x86_64-linux";
        modules = [
          # Common system modules...
        ];
      };
    in {
      exampleIso = nixpkgs.lib.nixosSystem {
        inherit (exampleBase) system;
        modules =
          exampleBase.modules
          ++ [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

            ({ pkgs, ...}: {
              environment.systemPackages = with pkgs; [
                git
              ];
            })

#            ({nixpkgs, ...}: {
#              imports = [
#                "${nixpkgs}/nixos/modules/programs/git.nix"
#              ];
#              # programs.git.enable = true;
#            })
          ];
      };

      example = nixpkgs.lib.nixosSystem {
        inherit (exampleBase) system;
        modules =
          exampleBase.modules
          ++ [
            # Modules for installed systems only.
          ];
      };
    };
  };
}
