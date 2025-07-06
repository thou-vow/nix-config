{
  description = "Nix environments for thou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];
  in {
    overlays = import ./overlays/overlays.nix;

    packages = nixpkgs.lib.genAttrs systems (
      system:
        builtins.foldl' (acc: elem:
          nixpkgs.lib.recursiveUpdate acc elem)
        {}
        (builtins.map (
          f: let pkgs = nixpkgs.legacyPackages.${system}; in f pkgs pkgs
        ) (import ./overlays/overlays.nix))
    );

    formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./hosts/u/nixos-configuration.nix];
      };
    };
    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; # Just a placeholder
        extraSpecialArgs = {inherit inputs;};
        modules = [./hosts/u/thou/home-configuration.nix];
      };
    };
  };
}
