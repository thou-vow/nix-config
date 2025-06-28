{pkgs, ...}: {
  fhs = let
    base = pkgs.appimageTools.defaultFhsEnvArgs;
  in
    pkgs.buildFHSEnv (base
      // {
        name = "fhs";
        targetPkgs = pkgs:
          (base.targetPkgs pkgs)
          ++ (
            with pkgs; [
              pkg-config
              ncurses
            ]
          );
        profile = "export FHS=1";
        runScript = pkgs.lib.getExe pkgs.bash;
        extraOutputsToInstall = ["dev"];
      });

  graalvm-oracle_21 = let
    src = {
      "x86_64-linux" = pkgs.fetchurl {
        # To get the hash, run the following (in bash):
        # nix hash convert --hash-algo sha256 --to sri $(curl -s <replace with url>.sha256)
        hash = "sha256-Z6yFh2tEAs4lO7zoXevRrFFcZQUw7w7Stkx9dUB46CE=";
        url = "https://download.oracle.com/graalvm/21/archive/graalvm-jdk-21.0.7_linux-x64_bin.tar.gz";
      };
    };
  in
    pkgs.graalvmPackages.graalvm-oracle.overrideAttrs (prevAttrs: {
      version = "21";
      src = src.${pkgs.system};
    });
}
