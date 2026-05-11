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
        
        # Ensure the config directory exists on the host so bwrap can use it as a mount point
        CONF_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zed"
        mkdir -p "$CONF_DIR"

        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --ro-bind ${./settings.json} "$CONF_DIR/settings.json" \
          -- ${pkgs.zed-editor}/bin/zeditor "$@"
      '';
    };
}