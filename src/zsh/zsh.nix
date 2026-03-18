{ inputs, ... }:
{
  flake.wrappers.zsh = 
  { pkgs, wlib, ... }: {
    imports = [ wlib.modules.default ];

    config.package = pkgs.zsh;

    config.env = {
      ZDOTDIR = "${inputs.self.packages.${pkgs.system}.zsh-config}";
      WRAPPED_STARSHIP_BIN_DIR = "${inputs.self.packages.${pkgs.system}.starship}/bin";
      AUTOSUGGEST_STRATEGY = "history,completion";
      AUTOSUGGEST_SRC = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    };
  };
}