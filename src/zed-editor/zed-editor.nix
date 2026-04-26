{ ... }:
{
  flake.wrappers.zed =
    { pkgs, wlib, ... }: {
      imports = [ wlib.modules.default ];
      config.package = pkgs.zed-editor;
      config.argv0type = command_string: ''
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --ro-bind ${./settings.json} "''${XDG_DATA_HOME:-$HOME/.local/share}/zed/settings.json" \
          -- ${command_string} "$@"
      '';
    };
}