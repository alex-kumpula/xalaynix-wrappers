{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    settings.binds = {
      "Mod+T".spawn-sh = "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty -e sh -c 'echo ${inputs.dms.packages.${pkgs.system}.default}; read'";
      "Mod+D".spawn-sh = "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms run --session";
    };
    settings.spawn-at-startup = [
      "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty"
      "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms"
    ];
  };
}