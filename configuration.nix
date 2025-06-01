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
    vim
    git
  ];

  # Configure basic settings
  time.timeZone = "UTC";
  networking.hostName = "hostname";

  # Set the default locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
}