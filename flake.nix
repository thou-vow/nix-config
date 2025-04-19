{
  description = "Nix environments for thou";

  nixConfig = {
    extra-substituters = [
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
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

    # Terminal
    suckless.url = "github:thou-vow/suckless";
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

    overlays = import ./overlays/overlays.nix {inherit inputs;};

    # Future plans: make overlays and nixpkgs config host specific
    eachPkgs = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
        }
    );
  in {
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
      "u@thou" = home-manager.lib.homeManagerConfiguration {
        pkgs = eachPkgs."x86_64-linux";
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/u/thou/home-configuration.nix];
      };
    };

    nixosConfigurations = {
      "lc" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/lc/nixos-configuration.nix
          {
            nixpkgs.pkgs = eachPkgs."x86_64-linux";
          }
        ];
      };
    };
  };
}
