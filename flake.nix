{
  description = "Nix environments for thou";

  inputs = {
    nix-packages.url = "github:thou-vow/nix-packages";

    nixpkgs.follows = "nix-packages/nixpkgs";
    nixpkgs-stable.follows = "nix-packages/nixpkgs-stable";

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
    chaotic.follows = "nix-packages/chaotic";
    niri.follows = "nix-packages/niri";
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
    inherit (nixpkgs) lib;

    systems = ["x86_64-linux"];

    eachPkgs = lib.genAttrs systems (
      system:
        import nixpkgs {
          config.allowUnfree = true;
          inherit system;
        }
    );
  in {
    # This flake's formatter. Use with `nix fmt`.
    formatter =
      lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Configurations hosted on an external HDD (mainly used on my Dell Inspiron 5566)
    # The 'attuned' specialisation uses some packages and settings optimizing for it.
    # On the contrary, the no specialisation mode's goal is wider compatibility.
    nixosConfigurations."u" = lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/u/nixos-configuration.nix
        ./mods/nixos/nixos.nix
        {
          nixpkgs.pkgs = eachPkgs."x86_64-linux";
        }
      ];
    };
    homeConfigurations."thou@u" = home-manager.lib.homeManagerConfiguration {
      pkgs = eachPkgs."x86_64-linux";
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./hosts/thou.u/home-configuration.nix
        ./mods/home/home.nix
      ];
    };
  };
}
