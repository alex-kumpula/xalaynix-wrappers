{ inputs, ... }:
{
  flake.wrappers.alacritty = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.alacritty ];
    settings.terminal.shell.program = "${pkgs.bash}/bin/bash";
    settings.terminal.shell.args = [ "-l" ];
  };
}