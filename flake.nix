#  :::    :::     :::     :::            :::   :::   ::: ::::    ::: ::::::::::: :::    :::  #
#  :+:    :+:   :+: :+:   :+:          :+: :+: :+:   :+: :+:+:   :+:     :+:     :+:    :+:  #
#   +:+  +:+   +:+   +:+  +:+         +:+   +:+ +:+ +:+  :+:+:+  +:+     +:+      +:+  +:+   #
#    +#++:+   +#++:++#++: +#+        +#++:++#++: +#++:   +#+ +:+ +#+     +#+       +#++:+    #
#   +#+  +#+  +#+     +#+ +#+        +#+     +#+  +#+    +#+  +#+#+#     +#+      +#+  +#+   #
#  #+#    #+# #+#     #+# #+#        #+#     #+#  #+#    #+#   #+#+#     #+#     #+#    #+#  #
#  ###    ### ###     ### ########## ###     ###  ###    ###    #### ########### ###    ###  #

# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "A collection of various modules you can use in your own Nix configurations.";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./src
        ./flake
      ]
    );

  inputs = {
    dgop = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/dgop";
    };
    dms = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/DankMaterialShell/stable";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    import-tree.url = "github:vic/import-tree";
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:YaLTeR/niri?ref=wip";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    wrapper-modules = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:BirdeeHub/nix-wrapper-modules";
    };
  };

}
