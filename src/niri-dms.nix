{ inputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    # settings.terminal.shell.program = "${pkgs.zsh}/bin/zsh";
    # settings.terminal.shell.args = [ "-l" ];
  };
}