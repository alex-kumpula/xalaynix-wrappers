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
    config.flags."--config-file" = "${./.wezterm.lua}";
    config.env = {
      TESTVAR = "Hello from wrapped Noctalia! :D";
    };
  };
}