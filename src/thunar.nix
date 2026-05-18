{ inputs, ... }:
let
  zshPkg = system: inputs.self.packages.${system}.zsh;
in
{
  flake.wrappers.wezterm = 
  { pkgs, lib, wlib, config, ... }: {
    imports = [ wlib.modules.default ];


    config = {

      package = pkgs.thunar;

      constructFiles.wezterm-desktop = {
        relPath = "share/applications/org.wezfurlong.wezterm.desktop";
        content = ''
          [Desktop Entry]
          Name=WezTerm
          Comment=Wez's Terminal Emulator
          Keywords=shell;prompt;command;commandline;cmd;
          Icon=${placeholder "out"}/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
          StartupWMClass=org.wezfurlong.wezterm
          TryExec=${placeholder "out"}/bin/wezterm
          Exec=${placeholder "out"}/bin/wezterm start --cwd .
          Type=Application
          Categories=System;TerminalEmulator;Utility;
          Terminal=false
        '';
      };

    };
    
  };
}