{
  description = "NixOS configuration with Budgie desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    nixosConfigurations = {
      Teclast-X4 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            environment.systemPackages = with pkgs; [
              starship
            ];

            programs.starship = {
              enable = true;
              promptOrder = [ "username" "hostname" "directory" "git_branch" ];
            };

            users.defaultUserShell = pkgs.nushell;
          }
        ];
      };
    };
  };
}