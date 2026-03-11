{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    settings.binds = {
      "Mod+T".spawn-sh = "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty";
      "Mod+D".spawn-sh = "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms run --session > /tmp/dms-debug.log 2>&1";
    };
    settings.spawn-at-startup = [
      "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty"
      "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms"
    ];
  };
}