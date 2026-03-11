{ inputs, outputs, ... }:
{
  flake.wrappers.niri-dms = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.wrapperModules.niri ];
    # settings.terminal.shell.program = "${pkgs.zsh}/bin/zsh";
    # settings.terminal.shell.args = [ "-l" ];
    settings.binds = {
      "Mod+T".spawn-sh = "${inputs.self.packages.${pkgs.system}.alacritty-example}/bin/alacritty";
    };
  };
}