# Flakes config, kinda messed up bc i'm still new in nix xd

{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-master.url = "github:nixos/nixpkgs/master";

        home-manager = {
            url = "github:nix-community/home-manager/";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }:
        let 
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
        in {
            nixosConfigurations = {
                kotudemo = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs system; };
                    modules = [
                        ./configuration.nix
                    ];
                };
            };
        };
}
