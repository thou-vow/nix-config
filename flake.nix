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

    suckless = {
      url = "github:thou-vow/suckless";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  in {
    packages = nixpkgs.lib.genAttrs systems (system: import ./pkgs/pkgs.nix {pkgs = nixpkgs.legacyPackages.${system};});

    overlays = [
      (final: prev: let
        recursivelyUpdatePkgsWithMyOwn = name: value:
          if nixpkgs.lib.attrsets.isDerivation value
          then value
          else prev.${name} // builtins.mapAttrs recursivelyUpdatePkgsWithMyOwn value;
      in
        builtins.mapAttrs recursivelyUpdatePkgsWithMyOwn (import ./pkgs/pkgs.nix {pkgs = final;}))
    ];

    formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/u/nixos-configuration.nix
          ({config, ...}: {
            config = nixpkgs.lib.mkIf (config.specialisation != {}) {
              nixpkgs.pkgs = import nixpkgs {
                config.allowUnfree = true;
                localSystem.system = "x86_64-linux";
                inherit (self) overlays;
              };
            };
          })
          {
            specialisation.attuned.configuration = {
              nixpkgs.pkgs = import nixpkgs {
                config.allowUnfree = true;
                localSystem.system = "x86_64-linux";
                inherit (self) overlays;
              };
            };
          }
        ];
      };
    };

    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          localSystem.system = "x86_64-linux";
          inherit (self) overlays;
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/u/thou/home-configuration.nix];
      };
    };
  };
}
