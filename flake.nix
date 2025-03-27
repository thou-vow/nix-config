{
  description = "Your Nix configuration";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://helix.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  inputs = {
    # Nix system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    # Theming
    stylix.url = "github:danth/stylix";

    # Wayland compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      eachPkgs = nixpkgs.lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.helix.overlays.default
          ];
        }
      );
    in
    {

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake "path:$HOME/nix#hostname"'
      nixosConfigurations = {
        "nezha" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./profiles/nezha/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake "path:$HOME/nix#username@hostname"'
      homeConfigurations = {
        "thou@nezha" = home-manager.lib.homeManagerConfiguration {
          pkgs = eachPkgs."x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./profiles/nezha/thou/home.nix ];
        };
      };
    };
}
