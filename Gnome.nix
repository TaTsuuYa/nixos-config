{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Wayland + NVIDIA specific settings
  environment.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    # Add XDG for proper portal support
    "XDG_SESSION_TYPE" = "wayland";
    "XDG_CURRENT_DESKTOP" = "GNOME";
  };

  # Additional GNOME settings for better GPU compatibility
  services.xserver = {
    videoDrivers = ["nvidia"];
    displayManager = {
      setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --auto
    '';
    };
  };
  
  services.displayManager = {
    # Enable the GNOME Desktop Environment.
    gdm.enable = true;
  };
}
