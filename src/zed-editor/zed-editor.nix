{ pkgs, ... }:
{
  flake.wrappers.zed-editor =
    { pkgs, wlib, ... }: {
      imports = [ wlib.modules.default ];
      config.package = pkgs.zed-editor;
      config.run = command_string: ''
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --ro-bind ${./settings.json} "$XDG_DATA_HOME/zed/settings.json" \
          -- ${command_string} "$@"
      '';
    };
}