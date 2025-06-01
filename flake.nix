{
  description = "NixOS configuration with Budgie desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nushell = {
      url = "github:nushell/nushell";
    };
  };

  outputs = { self, nixpkgs, nushell }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            environment.systemPackages = with pkgs; [
              nushell
              starship
            ];

            programs.starship = {
              enable = true;
              promptOrder = [ "username", "hostname", "directory", "git_branch" ];
            };

            users.defaultUserShell = pkgs.nushell;
          }
        ];
      };
    };
  };
}