{ inputs, ... }:
{
  # Import the nix-wrapper-modules flake
  flake-file = {
    inputs = {
      wrapper-modules = {
        url = "github:BirdeeHub/nix-wrapper-modules";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };

  # Import the flake parts module for nix-wrapper-modules
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];
}