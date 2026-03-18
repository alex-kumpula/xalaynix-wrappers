{
  perSystem = { pkgs, ... }: {
    packages.starship-config = pkgs.stdenv.mkDerivation {
      name = "starship-config";
      
      # Point this to the folder containing your starship.toml 
      # and any other related files (e.g., ./starship-src)
      src = ./src;

      # We don't need a compiler for a bunch of .toml files
      dontBuild = true;
      dontUnpack = false;

      installPhase = ''
        mkdir -p $out
        # Copy everything from the unpacked src to the output
        cp -r ./* $out/
      '';
    };
  };
}