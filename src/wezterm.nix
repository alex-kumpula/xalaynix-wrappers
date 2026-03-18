{ ... }:
{
  flake.wrappers.wezterm = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];

    config.package = pkgs.wezterm;

    config.env = {
      TESTVAR = "Hello :D";
    };
  };
}