{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    settings.binds = {
      "Mod+T".spawn-sh = "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty";
    };
    settings.spawn-at-startup = [
      "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty"
    ];
  };
}