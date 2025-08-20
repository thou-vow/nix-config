{
  description = "Nix environments for thou";

  inputs = {
    # Unstable (bleeding edge) and master branch (even more on the edge) packages.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    # For declarative home management.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For secrets management.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helpful modules for bind mounts and symlinks on tmpfs root.
    impermanence.url = "github:nix-community/impermanence";

    # Some packages.
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    helix-steel.url = "github:mattwparas/helix/steel-event-system";
    niri.url = "github:sodiboo/niri-flake";
  };

  nixConfig = {
    extra-substituters = [
      "https://chaotic-nyx.cachix.org"
      "https://niri.cachix.org"
      "https://nix-community.cachix.org"
      "https://thou-vow.cachix.org"
    ];
    extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
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

    # Overlays from the inputs are the first ones to be applied.
    externalOverlays = [inputs.chaotic.overlays.default inputs.niri.overlays.niri];

    # And then the base overlays from this flake are applied.
    baseOverlays = externalOverlays ++ [self.overlays.base];
  in {
    # Packages defined on this flake. Use with `nix build`, `nix run`, `nix shell`.
    legacyPackages = nixpkgs.lib.genAttrs systems (
      system: let
        pkgsExtOverlays = nixpkgs.legacyPackages.${system}.appendOverlays externalOverlays;
        pkgsBaseOverlays = nixpkgs.legacyPackages.${system}.appendOverlays baseOverlays;
      in
        # I use an overlay interface for convenience (I like it).
        import ./packages/base/base.nix inputs pkgsBaseOverlays pkgsExtOverlays
        // {
          # The package sets are made upon the base packages.
          attunedPackages =
            import ./packages/attuned/attuned.nix inputs (
              pkgsBaseOverlays.appendOverlays [self.overlays.attuned]
            )
            pkgsBaseOverlays;
        }
    );

    # Overlays based on the packages defined on this flake.
    overlays = let
      # Package sets of this flake aren't updated versions of previously defined sets
      # Which means they aren't like `linuxPackages = prev.linuxPackages // { ... };`.
      # So, we update the previously defined sets here.
      recursivelyUpdatePkgsWithMyOwn = prev: name: value:
        if nixpkgs.lib.isDerivation value
        then value
        else prev.${name} // nixpkgs.lib.mapAttrs recursivelyUpdatePkgsWithMyOwn value;
    in {
      base = final: prev: import ./packages/base/base.nix inputs final prev;
      attuned = final: prev: import ./packages/attuned/attuned.nix inputs final prev;
    };

    # This flake's formatter. Use with `nix fmt`.
    formatter =
      nixpkgs.lib.genAttrs systems (system:
        nixpkgs.legacyPackages.${system}.alejandra);

    # Configurations hosted on an external HDD (mainly used on my Dell Inspiron 5566)
    # The 'attuned' specialisation uses some packages and settings optimizing for it.
    # On the contrary, the no specialisation mode's goal is wider compatibility.
    nixosConfigurations."u" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/u/nixos-configuration.nix
        ./mods/nixos/nixos.nix
        inputs.impermanence.nixosModules.impermanence
        ({config, ...}: {
          # I could use `nixpkgs.pkgs` here, but I prefer to keep it similar to Home Manager.
          _module.args.pkgs = nixpkgs.lib.mkForce (import nixpkgs {
            config.allowUnfree = true;
            localSystem.system = "x86_64-linux";
            overlays = baseOverlays ++ config.nixpkgs.overlays;
          });

          # NixOS' specialisations don't support overlays yet...
          # specialisation.attuned.configuration.nixpkgs.overlays =
          #  lib.mkOrder 1 [self.overlays.attuned];
        })
      ];
    };
    homeConfigurations."thou@u" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Unused
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./hosts/thou.u/home-configuration.nix
        ./mods/home/home.nix
        inputs.impermanence.homeManagerModules.impermanence
        ({config, ...}: {
          # I use this because it's possible to define a separate pkgs instance
          #   for specialisations, which might be useful for me.
          _module.args.pkgs = nixpkgs.lib.mkForce (import nixpkgs {
            config.allowUnfree = true;
            localSystem.system = "x86_64-linux";
            overlays = baseOverlays ++ config.nixpkgs.overlays;
          });

          # Overlays applied to attuned specialisation.
          # They are the soonest to be applied, just after baseOverlays.
          specialisation.attuned.configuration.nixpkgs.overlays =
            nixpkgs.lib.mkOrder 1 [self.overlays.attuned];
        })
      ];
    };
  };
}
