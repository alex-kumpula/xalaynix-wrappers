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

  imports = [ inputs.wrappers.flakeModules.wrappers ];
}