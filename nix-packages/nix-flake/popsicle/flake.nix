{
  description = "Flake: Popsicle USB Flasher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, ... }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
  in {
    packages = builtins.listToAttrs (map (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      name = system;
      value = pkgs.popsicle;
    }) systems);

    defaultPackage.x86_64-linux = packages.x86_64-linux;

    apps.x86_64-linux.popsicle = {
      type = "app";
      program = "${packages.x86_64-linux}/bin/popsicle";
    };
  };
}
