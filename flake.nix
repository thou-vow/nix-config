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
    niri.url = "github:sodiboo/niri-flake";
  };

  nixConfig = {
    extra-substituters = [
      "https://chaotic-nyx.cachix.org"
      "https://helix.cachix.org"
      "https://niri.cachix.org"
      "https://nix-community.cachix.org"
      "https://thou-vow.cachix.org"
    ];
    extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
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

    externalOverlays = [inputs.chaotic.overlays.default inputs.niri.overlays.niri];
    baseOverlays = externalOverlays ++ [self.overlays.base];
  in {
    legacyPackages = nixpkgs.lib.genAttrs systems (
      system: let
        preBasePkgs = nixpkgs.legacyPackages.${system}.appendOverlays externalOverlays;
        basePkgs = nixpkgs.legacyPackages.${system}.appendOverlays baseOverlays;
      in
        import ./pkgs/base/base.nix inputs basePkgs preBasePkgs
        // {
          attunedPackages =
            import ./pkgs/attuned/attuned.nix inputs (
              basePkgs.appendOverlays [self.overlays.attuned]
            )
            basePkgs;
        }
    );

    overlays = let
      recursivelyUpdatePkgsWithMyOwn = prev: name: value:
        if nixpkgs.lib.attrsets.isDerivation value
        then value
        else prev.${name} // builtins.mapAttrs recursivelyUpdatePkgsWithMyOwn value;
    in {
      base = final: prev: import ./pkgs/base/base.nix inputs final prev;
      attuned = final: prev: import ./pkgs/attuned/attuned.nix inputs final prev;
    };

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
          ({config, ...}: {
            _module.args.pkgs = nixpkgs.lib.mkForce (import nixpkgs {
              config.allowUnfree = true;
              localSystem.system = "x86_64-linux";
              overlays = baseOverlays ++ config.nixpkgs.overlays;
            });

            # NixOS' Specialisations don't support overlays yet...
            # specialisation.attuned.configuration.nixpkgs.overlays =
            #   nixpkgs.lib.mkOrder 1 [self.overlays.attuned];
          })
        ];
      };
    };
    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Dummy field
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./hosts/thou.u/home-configuration.nix
          ./mods/home/home.nix
          inputs.impermanence.homeManagerModules.impermanence
          ({config, ...}: {
            _module.args.pkgs = nixpkgs.lib.mkForce (import nixpkgs {
              config.allowUnfree = true;
              localSystem.system = "x86_64-linux";
              overlays = baseOverlays ++ config.nixpkgs.overlays;
            });

            specialisation.attuned.configuration.nixpkgs.overlays =
              nixpkgs.lib.mkOrder 1 [self.overlays.attuned];
          })
        ];
      };
    };
  };
}
