{ inputs, ... }:
{
  flake.wrappers.noctalia-wrapped = 
  { pkgs, wlib, ... }: 
  let
    noctaliaPkg = inputs.noctalia.packages.${pkgs.system}.default;
  in
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];
    config.package = noctaliaPkg;
    config.env = {
      TESTVAR = "Hello from wrapped Noctalia! :D";
    };
    config.argv0type = command_string: ''
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --bind ${./settings.json} "''${XDG_CONFIG_HOME:-$HOME/.config}/niri/noctalia.kdl" \
          -- ${command_string} "$@"
      '';
  };
}