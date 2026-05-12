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
    config.filesToExclude = [ "share/wayland-sessions/niri.desktop" ];
    config.passthru.providedSessions = lib.mkForce ["niri-noctalia"];
    # config.constructFiles.niri-session = let
    #   original = builtins.readFile "${niriPkg}/bin/niri-session";
    #   # Replace all occurrences of the bare command 'niri' with the absolute path to the wrapped binary
    #   patched = builtins.replaceStrings
    #     [ " niri "   " niri\n"   " niri\t"   " niri;"   "exec niri"   "'niri'"   "\"niri\"" ]
    #     [ " ${placeholder "out"}/bin/niri "   " ${placeholder "out"}/bin/niri\n"   " ${placeholder "out"}/bin/niri\t"   " ${placeholder "out"}/bin/niri;"   "exec ${placeholder "out"}/bin/niri"   "'${placeholder "out"}/bin/niri'"   "\"${placeholder "out"}/bin/niri\"" ]
    #     original;
    #   in {
    #     relPath = "bin/niri-session";
    #     content = patched;
    # };
    # config.buildCommand.patchNiriSession = {
    #   after = [ "symlinkScript" ];   # run after the initial symlink phase
    #   data = ''
    #     # Remove the original symlink that points to the system niri-session
    #     rm -f "$out/bin/niri-session"
    #     # Write the new wrapper script
    #     cat > "$out/bin/niri-session" << 'EOF'
    #     #!${pkgs.bash}/bin/bash
    #     exec ${placeholder "out"}/bin/niri "$@"
    #     EOF
    #     chmod +x "$out/bin/niri-session"
    #   '';
    # };
    config.constructFiles.niri-service = let
      original = builtins.readFile "${niriPkg}/lib/systemd/user/niri.service";
      patched = builtins.replaceStrings
        [ "${niriPkg}/bin/niri"   " niri" ]
        [ "${placeholder "out"}/bin/niri"   " ${placeholder "out"}/bin/niri" ]
        original;
      in {
        relPath = "lib/systemd/user/niri.service";
        content = patched;
    };
  };
}