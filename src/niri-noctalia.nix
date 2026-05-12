{ inputs, ... }:
{
  flake.wrappers.niri-noctalia = 
  { pkgs, wlib, lib, ... }: 
  let
    noctaliaPkg = inputs.self.packages.${pkgs.system}.noctalia-wrapped;
    alacrittyPkg = inputs.self.packages.${pkgs.system}.alacritty-example;
    niriPkg = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.niri;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    config.package = lib.mkForce niriPkg;
    config.argv0type = command_string: ''
        #!${pkgs.bash}/bin/bash
        ZED_CONFIG_DIR="$HOME/.config/zed"
        TARGET_FILE="$ZED_CONFIG_DIR/settings.json"
        CUSTOM_SETTINGS="$(realpath ${./niri-noctalia.nix})"
        export TESTVAR2="HI :D"
        export PATH="${niriPkg}/bin:$PATH"
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --bind "$CUSTOM_SETTINGS" "$TARGET_FILE" \
          -- ${command_string} "$@"
      '';
    config.settings.binds = {
      "Mod+T".spawn-sh = "${alacrittyPkg}/bin/alacritty";
      "Mod+D".spawn-sh = "${noctaliaPkg}/bin/noctalia-shell";
    };
    config.settings.spawn-at-startup = [
      ["${noctaliaPkg}/bin/noctalia-shell"]
    ];
    config.extraSettings = [
      { include = [ { optional = true; } "~/.config/niri/noctalia.kdl" ]; }
    ];
    config.env = {
      GDK_BACKEND = "wayland";
      TESTVAR = "Hello from Niri-Noctalia wrapper! :D";
    };
    config.extraPackages = [ noctaliaPkg niriPkg ];
    config.constructFiles.niri-desktop = {
      relPath = "share/wayland-sessions/niri-noctalia.desktop";
      content = ''
        [Desktop Entry]
        Name=Niri Noctalia
        Comment=A scrollable-tiling Wayland compositor
        Exec=${placeholder "out"}/bin/niri-session
        Type=Application
        DesktopNames=niri-noctalia
      '';
    };
    config.filesToExclude = [ "share/wayland-sessions/niri.desktop" "bin/niri-session" ];
    config.filesToPatch = lib.mkForce [ ];
    config.passthru.providedSessions = lib.mkForce ["niri-noctalia"];
    
    # config.buildCommand.patchNiriSession = {
    #   after = [ "symlinkScript" "patchSelfReferences" ];
    #   data = ''
    #     # Remove the symlink to the original
    #     rm -f "$out/bin/niri-session"
    #     # Copy the original script
    #     cp ${niriPkg}/bin/niri-session "$out/bin/niri-session"
    #     # chmod +w "$out/bin/niri-session"
    #     # Replace all bare 'niri' with absolute path to wrapped binary
    #     substituteInPlace "$out/bin/niri-session" \
    #       --replace-fail 'exec niri' 'exec ${placeholder "out"}/bin/niri' \
    #       --replace-fail ' niri ' ' ${placeholder "out"}/bin/niri ' \
    #       --replace-fail ' niri\n' ' ${placeholder "out"}/bin/niri\n' \
    #       --replace-fail ' niri\t' ' ${placeholder "out"}/bin/niri\t' \
    #       --replace-fail ' niri;' ' ${placeholder "out"}/bin/niri;' \
    #       --replace-fail '"niri"' '"${placeholder "out"}/bin/niri"' \
    #       --replace-fail "'niri'" "'${placeholder "out"}/bin/niri'"
    #     # chmod +x "$out/bin/niri-session"
    #   '';
    # };
    
    config.constructFiles.niri-service = let
      original = builtins.readFile "${niriPkg}/lib/systemd/user/niri.service";
      patched = builtins.replaceStrings
        [ "${niriPkg}/bin/niri" " niri" ]
        [ "${placeholder "out"}/bin/niri" " ${placeholder "out"}/bin/niri" ]
        original;
    in {
      relPath = "lib/systemd/user/niri.service";
      content = patched;
    };
  };
}