{inputs, ...}: {
  specialisation.attuned.configuration = {
    mods.pkgs.overlays = [inputs.self.overlays.attuned];

    xdg.dataFile."home-manager/specialisation".text = "attuned";
  };
}
