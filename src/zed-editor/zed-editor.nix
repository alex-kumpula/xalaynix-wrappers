# { ... }:
# {
#   flake.wrappers.zed =
#     { pkgs, wlib, ... }: {
#       imports = [ wlib.modules.default ];
#       config.package = pkgs.zed-editor;
#       config.argv0type = command_string: ''
#         exec ${pkgs.bubblewrap}/bin/bwrap \
#           --dev-bind / / \
#           --ro-bind ${./settings.json} "''${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json" \
#           -- ${command_string} "$@"
#       '';
#     };
# }

{ ... }:
{
  flake.wrappers.zed =
    { pkgs, wlib, ... }: {
      imports = [ wlib.modules.default ];
      config.package = pkgs.writeShellScriptBin "zed-editor" ''
        #!${pkgs.bash}/bin/bash

        # 1. Determine the path inside the sandbox
        # We use a variable to keep the bwrap command readable
        ZED_CONF_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zed"
        ZED_SETTINGS="$ZED_CONF_DIR/settings.json"

        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --tmpfs "$ZED_CONF_DIR" \
          --ro-bind ${./settings.json} "$ZED_SETTINGS" \
          -- ${pkgs.zed-editor}/bin/zeditor "$@"
      ''
    };
}