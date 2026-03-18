{ ... }:
{
  flake.wrappers.starship = 
  { pkgs, wlib, ... }: {
    # Using the default wrapper module
    imports = [ wlib.modules.default ];

    # The underlying package to wrap
    config.package = pkgs.starship;

    # Point to your starship.toml file in the Nix store
    config.env = {
      STARSHIP_CONFIG = "${./starship.toml}";
    };
  };
}