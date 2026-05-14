{ inputs, ... }:
{
  flake.wrappers.niri-noctalia-wezterm = 
  { pkgs, wlib, lib, ... }: 
  {
    imports = [ inputs.self.wrapperModules.wezterm ];
    
    config.colorScheme = "Noctalia";
  };
}