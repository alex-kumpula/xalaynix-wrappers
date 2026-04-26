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

