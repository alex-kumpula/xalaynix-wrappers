{ ... }:
{
  flake-file = {
    inputs = {
      niri = {
        url = "github:YaLTeR/niri?ref=wip";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}