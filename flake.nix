{
  description = "NixOS configuration with Budgie desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    nixosConfigurations = {
      "hostname" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            environment.systemPackages = with pkgs; [
              starship
            ];

            programs.starship = {
              enable = true;
            };

            users.defaultUserShell = pkgs.nushell;
          }
        ];
      };
    };
  };
}