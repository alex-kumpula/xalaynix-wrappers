{ inputs, ... }:
{
  flake.wrappers.zsh = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];

    config.package = pkgs.zsh;

    config.env = {
      ZDOTDIR = "${./config}";
      PATH = pkgs.lib.makeBinPath [ inputs.self.packages.${pkgs.system}.alacritty-example ];
    };
  };
}