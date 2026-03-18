{ inputs, ... }:
{
  flake.wrappers.zsh = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];

    config.package = pkgs.zsh;

    config.extraPackages = [ inputs.self.packages.${pkgs.system}.starship ];

    config.env = {
      ZDOTDIR = "${./config}";
    };
  };
}