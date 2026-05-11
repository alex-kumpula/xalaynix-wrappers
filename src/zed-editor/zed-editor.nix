{ ... }:
{
  flake.wrappers.zed =
    { pkgs, wlib, lib, ... }: {
      imports = [ wlib.modules.default ];
      config.package = pkgs.zed-editor;
      config.exec = pkgs.writeShellScript "zed-wrapped" ''
          exec ${pkgs.bubblewrap}/bin/bwrap \
            --dev-bind / / \
            --ro-bind ${./settings.json} \
              "''${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json" \
            -- ${lib.getExe pkgs.zed-editor} "$@"
        '';
    };
}


# { ... }:
# {
#   flake.wrappers.zed =
#   { pkgs, wlib, ... }: {
#     flake.wrappers.zed = wlib.wrapModule ({ config, lib, wlib, ... }: {
#       imports = [ wlib.modules.default ];
#       config = {
#         package = pkgs.zed-editor;
#         command = pkgs.writeShellScript "zed-wrapped" ''
#           exec ${pkgs.bubblewrap}/bin/bwrap \
#             --dev-bind / / \
#             --ro-bind ${./settings.json} \
#               "''${XDG_CONFIG_HOME:-$HOME/.config}/zed/settings.json" \
#             -- ${lib.getExe config.package} "$@"
#         '';
#       };
#     });
#   };
# }