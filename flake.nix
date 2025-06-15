{
  description = "Nix environments for thou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-edge.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    helix.url = "github:helix-editor/helix";
  };

  nixConfig = {
    extra-substituters = [
      "https://helix.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];

    overlays = [
      (final: prev: import ./packages/packages.nix {pkgs = final;})
    ];
  in {
    packages = nixpkgs.lib.genAttrs systems (system: import ./packages/packages.nix {pkgs = nixpkgs.legacyPackages.${system};});

    formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      "u" = let
        flakePath = "/home/thou/nix-in-a-vat";
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit flakePath inputs;
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/u/nixos-configuration.nix
            (nixosParameters: {
              config = nixosParameters.lib.mkIf (nixosParameters.config.specialisation != {}) {
                nixpkgs = {
                  pkgs = import nixpkgs {
                    config.allowUnfree = true;
                    inherit overlays system;
                  };
                };
                home-manager = {
                  extraSpecialArgs = {inherit flakePath inputs;};
                  users."thou" = homeParameters: {
                    _module.args.pkgs = homeParameters.lib.mkForce (import nixpkgs {
                      config.allowUnfree = true;
                      overlays = overlays ++ nixosParameters.config.nixpkgs.overlays ++ homeParameters.config.nixpkgs.overlays;
                      inherit system;
                    });

                    imports = [./hosts/u/thou/home-configuration.nix];
                  };
                };
              };
            })
            (nixosParameters: {
              specialisation.attuned.configuration = {
                nixpkgs = {
                  pkgs = import nixpkgs {
                    config.allowUnfree = true;
                    localSystem = {
                      # gcc.arch = "skylake";
                      # gcc.tune = "skylake";
                      inherit system;
                    };
                    inherit overlays;
                  };
                };
                home-manager = {
                  extraSpecialArgs = {inherit flakePath inputs;};
                  users."thou" = homeParameters: {
                    _module.args.pkgs = homeParameters.lib.mkForce (import nixpkgs {
                      config.allowUnfree = true;
                      localSystem = {
                        # gcc.arch = "skylake";
                        # gcc.tune = "skylake";
                        inherit system;
                      };
                      overlays = overlays ++ nixosParameters.config.nixpkgs.overlays ++ homeParameters.config.nixpkgs.overlays;
                    });

                    imports = [./hosts/u/thou/home-configuration.nix];
                  };
                };
              };
            })
          ];
        };
    };
  };
}
