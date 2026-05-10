{ inputs, ... }:
{
  flake.wrappers.niri-noctalia = 
  { pkgs, wlib, lib, ... }: 
  let
    noctaliaPkg = inputs.noctalia.packages.${pkgs.system}.default;
    alacrittyPkg = inputs.self.packages.${pkgs.system}.alacritty-example;
    niriPkg = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.niri;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    config.package = lib.mkForce niriPkg;
    config.settings.binds = {
      "Mod+T".spawn-sh = "${alacrittyPkg}/bin/alacritty";
      "Mod+D".spawn-sh = "${noctaliaPkg}/bin/noctalia-shell";
    };
    config.settings.spawn-at-startup = [
      ["${noctaliaPkg}/bin/noctalia-shell"]
    ];
    config.env = {
      GDK_BACKEND = "wayland";
    };
    config.extraPackages = [ noctaliaPkg ];
  };
}