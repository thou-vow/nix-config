{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # No specialisation configuration
  config =
    inputs.nixpkgs.lib.mkIf (config.specialisation != {}) {
    };
}
