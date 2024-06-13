{
  description = "A flake to manage NixOS systems on digital ocean";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: {
    nixosConfigurations.site = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./nix/configuration.nix
        ]
        ++ (nixpkgs.lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix
          ++ [
            (nixpkgs + "/nixos/modules/virtualisation/digital-ocean-config.nix")
          ]);
    };
  };
}
