{ inputs, ... }:
{
  flake.wrappers.wezterm = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];

    config.package = pkgs.wezterm;

    config.flags."--config-file" = "${./.wezterm.lua}";

    config.env = {
      TESTVAR = "Hello :D";
      WRAPPED_ZSH = "${inputs.self.packages.${pkgs.system}.zsh}/bin/zsh";
    };
  };
}