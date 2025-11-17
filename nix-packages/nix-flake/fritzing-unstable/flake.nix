{
  description = "Fritzing 1.0.6";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    devShell.x86_64-linux = pkgs.mkShell {
      packages = [ pkgs.fritzing ];
    };
  };
}
