{
  description = "Your Nix configuration";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://helix.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  inputs = {
    # Nix packages and environment
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-edge.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # IDE
    helix.url = "github:helix-editor/helix";

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      overlays = [
        (final: prev: {
          stable = import inputs.nixpkgs-stable {
            system = final.system;
            config.allowUnfree = true;
          };
          edge = import inputs.nixpkgs-edge {
            system = final.system;
            config.allowUnfree = true;
          };

          inputs = {
            helix = inputs.helix.packages.${final.system}.default;
          };

          custom = import ./custom/custom.nix { inherit final inputs prev; };
        })
      ];

      eachPkgs = nixpkgs.lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
      );
    in
    {
      # NixOS
      nixosConfigurations = {
        "u" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/u/nixos-configuration.nix
            {
              nixpkgs.pkgs = eachPkgs."x86_64-linux";
            }
          ];
        };
      };
      homeConfigurations = {
        "u@thou" = home-manager.lib.homeManagerConfiguration {
          pkgs = eachPkgs."x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/u/thou/home-configuration.nix ];
        };
      };
    };
}
