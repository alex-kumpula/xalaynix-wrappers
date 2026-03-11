{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    config.settings.binds = {
      "Mod+T".spawn-sh = "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty -e sh -c 'echo ${inputs.dms.packages.${pkgs.system}.default}; read'";
      # "Mod+D".spawn-sh = "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms run --session";
      "Mod+D".spawn-sh = let
        dmsPkg = inputs.dms.packages.${pkgs.system}.dms-shell;
      in 
        "${dmsPkg}/bin/dms run";
    };
    config.settings.spawn-at-startup = [
      "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty"
      "${inputs.dms.packages.${pkgs.system}.dms-shell}/bin/dms"
    ];
    config.env = {
      GDK_BACKEND = "wayland";
    };
  };
}