{
  perSystem = { pkgs, ... }: {
    packages.starship-config = pkgs.writeText "starship.toml" (builtins.readFile ./starship.toml);
  };
}