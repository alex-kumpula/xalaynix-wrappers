{ inputs, ... }:
{
  flake.wrappers.niri-noctalia = 
  { pkgs, wlib, lib, ... }: 
  let
    noctaliaPkg = inputs.self.packages.${pkgs.system}.noctalia-wrapped;
    weztermPkg = inputs.self.packages.${pkgs.system}.wezterm;
    niriPkg = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.niri;
  in
  {
    imports = [ wlib.wrapperModules.niri ];
    
    config = {
      package = lib.mkForce niriPkg;

      settings.binds = {
        "Mod+T".spawn-sh = "${weztermPkg}/bin/wezterm";
        "Mod+D".spawn-sh = "${noctaliaPkg}/bin/noctalia-shell";
      };

      settings.spawn-at-startup = [
        ["${noctaliaPkg}/bin/noctalia-shell"]
      ];

      extraSettings = [
        { include = [ { optional = true; } "~/.config/niri/noctalia.kdl" ]; }
      ];

      env = {
        GDK_BACKEND = "wayland";
        TESTVAR = "Hello from Niri-Noctalia wrapper! :D";
      };

      extraPackages = [ noctaliaPkg niriPkg ];
      
      constructFiles.niri-desktop = {
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

      filesToExclude = lib.mkForce [ "share/wayland-sessions/niri.desktop" "bin/niri-session" ];
      filesToPatch = lib.mkForce [ ];
      passthru.providedSessions = lib.mkForce ["niri-noctalia"];
      
      buildCommand.patchNiriSession = {
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

      buildCommand.patchNiriService = {
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

      buildCommand.patchNiriShutdownTarget = {
        after = [ "symlinkScript" "patchSelfReferences" ];
        data = ''
          # Remove the symlink to the original
          rm -f "$out/share/systemd/user/niri-shutdown.target"
          # Copy the original script
          cp ${niriPkg}/share/systemd/user/niri-shutdown.target "$out/share/systemd/user/niri-noctalia-shutdown.target"
        '';
      };
    };

  };
}