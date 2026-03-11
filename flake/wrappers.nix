{ lib, flake-parts-lib, inputs, ... }:
{
  # Required to define the `wrappers` flake output.
  # options = {
  #   flake = flake-parts-lib.mkSubmoduleOptions {
  #     wrappers = lib.mkOption {
  #       type = with lib.types; lazyAttrsOf raw;
  #       default = { };
  #     };
  #   };
  # };

  flake-file = {
    inputs = {
      wrapper-modules = {
        url = "github:BirdeeHub/nix-wrapper-modules";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };

  # imports = [ inputs.wrapper-modules.flakeModules.wrappers ];
}