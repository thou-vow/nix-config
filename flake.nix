{
  description = "Nix environments for thou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    helix.url = "github:helix-editor/helix";
  };

  nixConfig = {
    extra-substituters = [
      "https://chaotic-nyx.cachix.org"
      "https://helix.cachix.org"
      "https://nix-community.cachix.org"
      "https://thou-vow.cachix.org"
    ];
    extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "thou-vow.cachix.org-1:n6zUvWYOI7kh0jgd+ghWhxeMd9tVdYF2KdOvufJ/Qy4="
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
    overlays = {
      default = import ./overlays/default/default.nix inputs;
      attuned = import ./overlays/attuned/attuned.nix inputs;
    };

    packages = nixpkgs.lib.genAttrs systems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        self.overlays.default pkgs pkgs
    );

    formatter =
      nixpkgs.lib.genAttrs systems (system:
        nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/u/nixos-configuration.nix
          ./mods/nixos/nixos.nix
          inputs.impermanence.nixosModules.impermanence
          {
            mods.pkgs = {
              system = "x86_64-linux";
              overlays = [inputs.chaotic.overlays.default self.overlays.default];
            };

            specialisation.attuned.configuration.mods.pkgs.overlays = [self.overlays.attuned];
          }
        ];
      };
    };
    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Placeholder
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./hosts/thou.u/home-configuration.nix
          ./mods/home/home.nix
          inputs.impermanence.homeManagerModules.impermanence
          {
            mods.pkgs = {
              system = "x86_64-linux";
              overlays = [inputs.chaotic.overlays.default self.overlays.default];
            };

            specialisation.attuned.configuration.mods.pkgs.overlays = [self.overlays.attuned];
          }
        ];
      };
    };
  };
}
