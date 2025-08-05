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
  };

  nixConfig = {
    extra-substituters = [
      "https://thou-vow.cachix.org"
      "https://chaotic-nyx.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "thou-vow.cachix.org-1:n6zUvWYOI7kh0jgd+ghWhxeMd9tVdYF2KdOvufJ/Qy4="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];

    eachPkgs = nixpkgs.lib.genAttrs systems (
      system:
        import nixpkgs {
          config.allowUnfree = true;
          localSystem.system = system;
          overlays =
            builtins.attrValues self.overlays
            ++ [
              inputs.chaotic.overlays.default
            ];
        }
    );
  in {
    overlays = import ./overlays/overlays.nix;

    packages = nixpkgs.lib.genAttrs systems (
      system:
        builtins.foldl' (acc: elem:
          nixpkgs.lib.recursiveUpdate acc elem)
        {}
        (builtins.map (
          f: let pkgs = eachPkgs.${system}; in f pkgs pkgs
        ) (builtins.attrValues (import ./overlays/overlays.nix)))
    );

    formatter = nixpkgs.lib.genAttrs systems (system: eachPkgs.${system}.alejandra);

    nixosConfigurations = {
      "u" = nixpkgs.lib.nixosSystem {
        pkgs = eachPkgs."x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/u/nixos-configuration.nix
          ./mods/nixos/nixos.nix
          inputs.impermanence.nixosModules.impermanence
        ];
      };
    };
    homeConfigurations = {
      "thou@u" = home-manager.lib.homeManagerConfiguration {
        pkgs = eachPkgs."x86_64-linux";
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./hosts/thou.u/home-configuration.nix
          ./mods/home/home.nix
          inputs.impermanence.homeManagerModules.impermanence
        ];
      };
    };
  };
}
