{
  description = "Manage tools used for this project";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              postgresql_17 # for `psql` command
              sqlfluff # sql linter and formatter
              pgcli # an alternative to psql
              just # just a command runner
            ];

            shellHook = ''
              # list containers backed by docker compose
              docker compose ps --all
            '';
          };
        }
      );
    };
}
