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
    userEmail = "taoufik02yahyaoui@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Shell aliases (migrated from your bash config)
  programs.bash = {
    enable = true;
    shellAliases = {
      c = "clear";
      # Nix
      nx-conf = "code ~/nixos-config";
      nx-rb-switch = "sudo nixos-rebuild switch --flake ~/nixos-config";
      nx-rb-switch-up = "nix flake update && nx-rb-switch";
      nx-rb-boot = "sudo nixos-rebuild boot --flake ~/nixos-config";
      nx-rb-boot-up = "nix flake update && nx-rb-boot";
      # Git
      gi = "git init";
      ga = "git add";
      gc = "git commit";
      gpll = "git pull";
      gpsh = "git push";
      gs = "git status";
      gl = "git log";
      gd = "git diff";
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
    heroic
    obs-studio
    nixd
    bat
    tree
    bottles
    sambaFull
  ];

  # State version
  home.stateVersion = "23.05";
}
