{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, devenv, ... } @ inputs:
    let
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) systems);
    in
    {
      devShells = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    kyverno
                    kustomize
                    fluxcd
                    gnumake
                  ];

                  languages.nix.enable = true;

                  pre-commit.hooks = {
                    deadnix.enable = true;
                    nixpkgs-fmt.enable = true;
                    statix.enable = true;
                    actionlint.enable = true;
                    yamllint.enable = true;
                  };
                }
              ];
            };
          });
    };
}
