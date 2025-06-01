{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable the Budgie desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  # Set system packages
  environment.systemPackages = with pkgs; [
    nano # Replacing vim with nano as the text editor
    git
  ];

  # Configure basic settings
  time.timeZone = "UTC";
  networking.hostName = "hostname";

  # Set the default locale
  i18n.defaultLocale = "en_GB.UTF-8";

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

  # User configuration
  users.users.ts = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Grants sudo privileges
  };

  users.users.qz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Grants sudo privileges
  };

  # Use systemd-boot instead of GRUB
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}