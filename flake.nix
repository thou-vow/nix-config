{
  description = "Nix environments for thou";

  inputs = {
    nix-packages.url = "github:thou-vow/nix-packages";

    nixpkgs.follows = "nix-packages/nixpkgs";
    nixpkgs-stable.follows = "nix-packages/nixpkgs-stable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.follows = "nix-packages/systems";
    treefmt-nix.follows = "nix-packages/treefmt-nix";

    # Some packages.
    chaotic.follows = "nix-packages/chaotic";
    niri-flake.follows = "nix-packages/niri-flake";
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
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    eachSystem = f: nixpkgs.lib.genAttrs (import inputs.systems) (system: f nixpkgs.legacyPackages.${system});
  in {
    # This flake's formatter. Use with `nix fmt`.
    formatter = eachSystem (pkgs:
      inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";

        programs = {
          alejandra.enable = true; # Nix
          kdlfmt.enable = true;
          taplo.enable = true; # TOML
        };
      });

    # Configurations hosted on an external HDD (mainly used on my Dell Inspiron 5566)
    # The 'attuned' specialisation uses some packages and settings optimizing for it.
    # On the contrary, the no specialisation mode's goal is wider compatibility.
    nixosConfigurations."u" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/u/nixos-configuration.nix
        ./mods/nixos/nixos.nix
      ];
    };
    homeConfigurations."thou@u" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./hosts/thou.u/home-configuration.nix
        ./mods/home/home.nix
      ];
    };

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          kdlfmt
          taplo
        ];
      };
      bootstrap = pkgs.mkShell {
        buildInputs = with pkgs; [
          lixPackageSets.lix.latest
        ];
      };
    });
  };
}
