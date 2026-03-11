{ inputs, ... }:
{
  flake.wrappers.alacritty = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.alacritty ];
    settings.terminal.shell.program = "${pkgs.zsh}/bin/zsh";
    settings.terminal.shell.args = [ "-l" ];
  };
}