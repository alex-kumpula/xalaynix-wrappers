{ inputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, lib, ... }: 
  let
    dmsPkg = inputs.dms.packages.${pkgs.system}.dms-shell;
    alacrittyPkg = inputs.self.packages.${pkgs.system}.alacritty-example;
    niriWipPkg = inputs.niri.packages.${pkgs.system}.default;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    config.package = lib.mkForce niriWipPkg;
    config.settings.binds = {
      "Mod+T".spawn-sh = "${alacrittyPkg}/bin/alacritty";
      "Mod+D".spawn-sh = "${dmsPkg}/bin/dms run --session";
    };
    config.settings.spawn-at-startup = [
      ["${dmsPkg}/bin/dms" "run" "--session"]
    ];
    config.env = {
      GDK_BACKEND = "wayland";
    };
    config.extraPackages = [ dmsPkg ];
  };
}