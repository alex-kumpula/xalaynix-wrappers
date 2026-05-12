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
    config.buildCommand.patchNiriSession = {
      # Ensure this runs after the initial 'symlinkScript' phase
      after = [ "symlinkScript" ];
      data = ''
        # Override the main session script
        session_script="$out/bin/niri-session"
        if [ -f "$session_script" ]; then
          substituteInPlace "$session_script" \
            --replace-fail "${niriPkg}/bin/niri-session" "${placeholder "out"}/bin/niri-session"
        fi

        # Override the systemd service file
        user_service_dir="$out/share/systemd/user"
        if [ -d "$user_service_dir" ]; then
          for service in "$user_service_dir"/*.service; do
            if [ -f "$service" ]; then
              substituteInPlace "$service" \
                --replace-fail "${niriPkg}/" "${placeholder "out"}/" \
                --replace-fail "${niriPkg}/bin/niri" "${placeholder "out"}/bin/niri"
            fi
          done
        fi

        # Override the desktop file (already defined)
        # config.constructFiles.niri-desktop ... (as before)
      '';
    };
  };
}