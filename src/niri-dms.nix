{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, lib, ... }: 
  let
    dmsPkg = inputs.dms.packages.${pkgs.system}.dms-shell;
    alacrittyPkg = inputs.self.packages.${pkgs.system}.alacritty-example;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    config.settings.binds = {
      "Mod+T".spawn-sh = "${alacrittyPkg}/bin/alacritty";
      "Mod+D".spawn-sh = "${dmsPkg}/bin/dms run --session";
    };
    config.settings.spawn-at-startup = [
      "${alacrittyPkg}/bin/alacritty"
      # [
      #   "${dmsPkg}/bin/dms"
      #   "run"
      #   "--session"
      # ]
      # This makes GDK_BACKEND and other env vars available to systemd services
    [ "dbus-update-activation-environment" "--systemd" "GDK_BACKEND" "PATH" ]
    
    # Then start your service
    [ "systemctl" "--user" "start" "my-dms-service.service" ]
    ];
    config.env = {
      GDK_BACKEND = "wayland";
    };
    config.extraPackages = [ dmsPkg ];
  };
}