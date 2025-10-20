{
  config,
  inputs,
  pkgs,
  ...
}: {
  # No specialisation configuration
  config = inputs.nixpkgs.lib.mkIf (config.specialisation != {}) {
    programs.direnv.nix-direnv.package = pkgs.lixPackageSets.latest.nix-direnv;
  };
}
