{ inputs, ... }:
{
  flake.wrappers.niri-noctalia = 
  { pkgs, wlib, lib, ... }: 
  let
    noctaliaPkg = inputs.self.packages.${pkgs.system}.noctalia-wrapped;
    alacrittyPkg = inputs.self.packages.${pkgs.system}.alacritty-example;
    niriPkg = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.niri;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    config.package = lib.mkForce niriPkg;
    config.argv0type = command_string: ''
        #!${pkgs.bash}/bin/bash
        ZED_CONFIG_DIR="$HOME/.config/zed"
        TARGET_FILE="$ZED_CONFIG_DIR/settings.json"
        CUSTOM_SETTINGS="$(realpath ${./niri-noctalia.nix})"
        export TESTVAR2="HI :D"
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --bind "$CUSTOM_SETTINGS" "$TARGET_FILE" \
          -- ${command_string} "$@"
      '';
    config.settings.binds = {
      "Mod+T".spawn-sh = "${alacrittyPkg}/bin/alacritty";
      "Mod+D".spawn-sh = "${noctaliaPkg}/bin/noctalia-shell";
    };
    config.settings.spawn-at-startup = [
      ["${noctaliaPkg}/bin/noctalia-shell"]
    ];
    config.env = {
      GDK_BACKEND = "wayland";
      TESTVAR = "Hello from Niri-Noctalia wrapper! :D";
    };
    config.extraPackages = [ noctaliaPkg niriPkg ];
  };
}