{
  description = "NixOS configuration with Budgie desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    nixosConfigurations = {
      "Teclast-X4" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            imports = [
              ./hardware-configuration.nix
            ];

            # Enable the Budgie desktop environment
            services.xserver.enable = true;
            services.xserver.displayManager.lightdm.enable = true;
            services.xserver.desktopManager.budgie.enable = true;

            # Set system packages
            environment.systemPackages = with pkgs; [
              nano git starship htop curl wget unzip file
            ];

            # Configure basic settings
            time.timeZone = "UTC";
            networking.hostName = "Teclast-X4";

            # Set the default locale
            i18n.defaultLocale = "en_GB.UTF-8";
            i18n.supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

            # Set the keyboard layout for the console
            console.keyMap = "us";

            # Set the keyboard layout for the X server
            services.xserver.xkb = {
              layout = "us";
              variant = "intl";
            };

            # Configure PipeWire as the sole sound server
            services.pulseaudio.enable = false;
            hardware.alsa.enable = false;
            services.pipewire = {
              enable = true;
              alsa.enable = false;
              pulse.enable = true;
            };

            # Enable power management
            powerManagement.enable = true;

            # Enable the firewall
            networking.firewall.enable = true;
            networking.firewall.logRefusedConnections = true;

            # User configuration
            users.users.ts = {
              isNormalUser = true;
              extraGroups = [ "wheel" "kvm" "libvirtd" ]; # Added KVM groups
            };

            users.users.qz = {
              isNormalUser = true;
              extraGroups = [ "wheel" "kvm" "libvirtd" ]; # Added KVM groups
            };

            # Use systemd-boot instead of GRUB
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # Enable hardware acceleration for video playback (Intel)
            hardware.graphics.enable = true;
            hardware.graphics.enable32Bit = true;
            hardware.graphics.extraPackages = with pkgs; [
              vaapiIntel
              vaapiVdpau
              libvdpau-va-gl
              intel-media-driver
            ];

            # Enable automatic garbage collection
            nix.gc.automatic = true;
            nix.gc.dates = "weekly";
            nix.gc.options = "--delete-older-than 7d";

            # Set environment variables
            environment.variables.EDITOR = "nano";
            environment.variables.PAGER = "less";

            # Enable systemd-timesyncd for time synchronization
            services.timesyncd.enable = true;

            # Enable zram swap
            zramSwap.enable = true;

            # Journal configuration
            services.journald.extraConfig = ''
              SystemMaxUse=500M
              RuntimeMaxUse=200M
            '';

            fonts.packages = with pkgs; [
              dejavu_fonts
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-emoji
              liberation_ttf
              source-han-sans
            ];

            programs.starship = {
              enable = true;
            };

            # Set the default shell for users
            users.defaultUserShell = pkgs.nushell;

            system.stateVersion = "24.05";

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            security.apparmor.enable = true;

            services.tlp.enable = true;

            services.flatpak.enable = true;

            services.printing.enable = true;

            services.avahi.enable = true;

            services.fstrim.enable = true;

            nix.settings.auto-optimise-store = true;

            hardware.bluetooth.enable = true;

            services.udev.packages = [ pkgs.libu2f-host pkgs.libu2f-server ];

            services.smartd.enable = true;

            # Enable KVM support
            virtualisation.libvirtd.enable = true;
            virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
            virtualisation.libvirtd.qemu.runAsRoot = true;

            # Add KVM-related kernel modules
            boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
          })
        ];
      };
    };
  };
}