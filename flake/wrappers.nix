{ lib, flake-parts-lib, ... }:
{
  # Required to define the `wrappers` flake output.
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      wrappers = lib.mkOption {
        type = with lib.types; lazyAttrsOf raw;
        default = { };
      };
    };
  };
}