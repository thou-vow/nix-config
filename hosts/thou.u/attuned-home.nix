{pkgs, ...}: {
  specialisation.attuned.configuration = {
    home.replaceDependencies.replacements = [
      {
        oldDependency = pkgs.mesa.out;
        newDependency = pkgs.mesa_git.out;
      }
      {
        oldDependency = pkgs.pkgsi686Linux.mesa.out;
        newDependency = pkgs.mesa32_git.out;
      }
    ];

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
