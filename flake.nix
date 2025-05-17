{
  description = "Nix environments for thou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-edge.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    overlays = [
      (final: prev: import ./packages/packages.nix {pkgs = final;})
    ];

    eachPkgs = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
        }
    );
  in {
    packages = nixpkgs.lib.genAttrs systems (system: import ./packages/packages.nix {pkgs = eachPkgs.${system};});

    formatter = nixpkgs.lib.genAttrs systems (system: eachPkgs.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/u/nixos-configuration.nix
          {
            nixpkgs.pkgs = eachPkgs."x86_64-linux";
          }
        ];
      };
    };
    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = eachPkgs."x86_64-linux";
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/u/thou/home-configuration.nix];
      };
    };
  };
}
