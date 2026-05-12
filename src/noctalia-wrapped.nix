{ inputs, ... }:
{
  flake.wrappers.noctalia-wrapped = 
  { pkgs, wlib, ... }: 
  let
    noctaliaPkg = inputs.noctalia.packages.${pkgs.system}.default;
  in
  {
    imports = [ wlib.modules.default ];
    config.package = pkgs.writeShellScriptBin "noctalia-shell" ''
        #!${pkgs.bash}/bin/bash
        ZED_CONFIG_DIR="$HOME/.config/zed"
        TARGET_FILE="$ZED_CONFIG_DIR/settings.json"
        CUSTOM_SETTINGS="$(realpath ${./niri-noctalia.nix})"
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --bind "$CUSTOM_SETTINGS" "$TARGET_FILE" \
          -- ${noctaliaPkg}/bin/noctalia-shell "$@"
      '';
    config.env = {
      TESTVAR = "Hello from wrapped Noctalia! :D";
    };
  };
}