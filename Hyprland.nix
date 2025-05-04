{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # bar
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))

    # widgets
    eww-wayland

    # wallpaper deamon
    swww

    # color manager
    pywal

    # terminal
    kitty

    # app launcher
    rofi-wayland

    # notifications
    dunst
    libnotify

    # networkmanager
    networkmanagerapplet

    #scrennshot
    grimblast

    # lock screen
    swaylock

    #file explorer
    libsForQt5.dolphin
  ];

  #fix swaylock
  security.pam.services.swaylock = {
    text = ''
      		auth include login
      	'';
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
  ];

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # if your cursor becomes invisible
    #WLR_NO_HARDWARE_CURSORS = "1";
    # hint electron apps to use wayland
    #NIXOS_OZONE_WL = mkForce "1";
  };

  #XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
