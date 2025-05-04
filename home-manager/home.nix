{ pkgs, ... }: {
  home.username = "tatsuuya";
  home.homeDirectory = "/home/tatsuuya";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Disable fontconfig to avoid XML formatter issues
  fonts.fontconfig.enable = false;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "TaTsuuYa";
    userEmail = "taoufik02yahyaoui@gmail.com"; # Replace with your email
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Shell aliases (migrated from your bash config)
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      nx-conf = "code /etc/nixos/configuration.nix";
      nx-rb-switch = "sudo nixos-rebuild switch";
      nx-rb-switch-up = "sudo nixos-rebuild switch --upgrade";
      nx-rb-boot = "sudo nixos-rebuild boot";
      nx-rb-boot-up = "sudo nixos-rebuild boot --upgrade";
      ginit = "git init";
      gadd = "git add";
      gcomm = "git commit";
      gpll = "git pull";
      gpsh = "git push";
      gs = "git status";
    };
  };

  # Packages to install for your user
  home.packages = with pkgs; [
    firefox
    neofetch
    vlc
    discord
    google-chrome
    python3
    git
    wget
    vscode
    gnome-tweaks  # Updated to use top-level package
    toybox
    ripgrep
    xclip
    qbittorrent
    blender
    megasync
    bottles
    heroic
    obs-studio
    nixd
    bat
    tree
  ];

  # State version
  home.stateVersion = "23.05";
}
