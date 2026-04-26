{ inputs, ... }:
let
  zshPkg = system: inputs.self.packages.${system}.zsh;
in
{
  flake.wrappers.wezterm = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];
    config.package = pkgs.wezterm;
    config.flags."--config-file" = "${./.wezterm.lua}";
    config.env = {
      TESTVAR = "Hello :D";
      WRAPPED_ZSH = "${zshPkg pkgs.system}/bin/zsh";
    };
  };
}