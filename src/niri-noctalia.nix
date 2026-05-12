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
    # config.argv0type = command_string: ''
    #     #!${pkgs.bash}/bin/bash
    #     ZED_CONFIG_DIR="$HOME/.config/zed"
    #     TARGET_FILE="$ZED_CONFIG_DIR/settings.json"
    #     CUSTOM_SETTINGS="$(realpath ${./niri-noctalia.nix})"
    #     export TESTVAR2="HI :D"
    #     export PATH="${niriPkg}/bin:$PATH"
    #     exec ${pkgs.bubblewrap}/bin/bwrap \
    #       --dev-bind / / \
    #       --bind "$CUSTOM_SETTINGS" "$TARGET_FILE" \
    #       -- ${command_string}
    #   '';
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
    config.filesToExclude = lib.mkForce [ "share/wayland-sessions/niri.desktop" "bin/niri-session" ];
    config.filesToPatch = lib.mkForce [ ];
    config.passthru.providedSessions = lib.mkForce ["niri-noctalia"];
    config.disableConfigHotReload = true;
    
    config.buildCommand.patchNiriSession = {
      after = [ "symlinkScript" "patchSelfReferences" ];
      data = ''
        # Remove the symlink to the original
        rm -f "$out/bin/niri-session"
        # Copy the original script
        cp ${niriPkg}/bin/niri-session "$out/bin/niri-session"
        chmod +w "$out/bin/niri-session"
        # Replace all bare 'niri' with absolute path to wrapped binary
        substituteInPlace "$out/bin/niri-session" \
          --replace-fail ' niri ' ' ${placeholder "out"}/bin/niri '
        substituteInPlace "$out/bin/niri-session" \
          --replace-fail 'niri.service' 'niri-noctalia.service'
        substituteInPlace "$out/bin/niri-session" \
          --replace-fail 'niri-shutdown.target' 'niri-noctalia-shutdown.target'
        chmod +x "$out/bin/niri-session"
      '';
    };

    config.buildCommand.patchNiriService = {
      after = [ "symlinkScript" "patchSelfReferences" ];
      data = ''
        # Remove the symlink to the original
        rm -f "$out/share/systemd/user/niri.service"
        # Copy the original script
        cp ${niriPkg}/share/systemd/user/niri.service "$out/share/systemd/user/niri-noctalia.service"
        chmod +w "$out/share/systemd/user/niri-noctalia.service"
        # Replace all bare 'niri' with absolute path to wrapped binary
        sed -i 's|^ExecStart=.*|ExecStart=${placeholder "out"}/bin/niri --session|' "$out/share/systemd/user/niri-noctalia.service"
      '';
    };

    config.buildCommand.patchNiriShutdownTarget = {
      after = [ "symlinkScript" "patchSelfReferences" ];
      data = ''
        # Remove the symlink to the original
        rm -f "$out/share/systemd/user/niri-shutdown.target"
        # Copy the original script
        cp ${niriPkg}/share/systemd/user/niri-shutdown.target "$out/share/systemd/user/niri-noctalia-shutdown.target"
      '';
    };
    
    # config.constructFiles.niri-service = let
    #   original = builtins.readFile "${niriPkg}/lib/systemd/user/niri.service";
    #   patched = builtins.replaceStrings
    #     [ "${niriPkg}/bin/niri" " niri" ]
    #     [ "${placeholder "out"}/bin/niri" " ${placeholder "out"}/bin/niri" ]
    #     original;
    # in {
    #   relPath = "lib/systemd/user/niri.service";
    #   content = patched;
    # };
  };
}