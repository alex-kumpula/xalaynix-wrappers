{ ... }:
{
  flake.wrappers.zed =
    { pkgs, wlib, ... }: {
      imports = [ wlib.modules.default ];
      config.package = pkgs.zed-editor;
      config.argv0type = command_string: ''
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --ro-bind ${./settings.json} "''${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json" \
          -- ${command_string} "$@"
      '';
    };
}

# { ... }:
# {
#   flake.wrappers.zed =
#     { pkgs, wlib, ... }: {
#       imports = [ wlib.modules.default ];
      
#       # We define the package as a shell script that calls bwrap directly
#       config.package = pkgs.writeShellScriptBin "zed" ''
#         #!${pkgs.bash}/bin/bash
        
#         # Ensure the destination path exists (bwrap needs a mount point)
#         TARGET="''${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json"
#         mkdir -p "$(dirname "$TARGET")"

#         exec ${pkgs.bubblewrap}/bin/bwrap \
#           --dev-bind / / \
#           --ro-bind ${./settings.json} "$TARGET" \
#           -- ${pkgs.zed-editor}/bin/zeditor "$@"
#       '';
#     };
# }