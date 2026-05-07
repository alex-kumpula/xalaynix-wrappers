{ inputs, ... }:
{
  flake.wrappers.cc = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];
    config.package = pkgs.claude-code;
    config.env = {
      TESTVAR = "Hello :D";
    };
  };
}