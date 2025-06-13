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
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];

    eachPkgs = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: import ./packages/packages.nix {pkgs = final;})
            (final: prev: {
              helix = inputs.helix.packages.${final.system}.helix;
            })
          ];
        }
    );
  in {
    packages = nixpkgs.lib.genAttrs systems (system: import ./packages/packages.nix {pkgs = eachPkgs.${system};});

    formatter = nixpkgs.lib.genAttrs systems (system: eachPkgs.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          flakePath = "/home/thou/nix-in-a-vat";
          inherit inputs;
        };
        modules = [
          ./hosts/u/nixos-configuration.nix
          {
            nixpkgs.pkgs = eachPkgs."x86_64-linux";
          }
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
