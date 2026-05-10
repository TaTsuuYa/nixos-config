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
    settings.user = {
      name = "TaTsuuYa";
      email = "taoufik02yahyaoui@gmail.com";

      init.defaultBranch = "main";
    };
  };

  # Shell aliases (migrated from your bash config)
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
      # windows
      winboot = "sudo systemctl reboot --boot-loader-entry=windows_windows.conf";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "bira";
    };
  };

  # Gnome extensions
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = gsconnect; }
      { package = blur-my-shell; }
      { package = appindicator; }
      { package = vitals; }
      { package = clipboard-history; }
    ];
  }; 

  # Packages to install for your user
  home.packages = with pkgs; [
    firefox
    fastfetch
    vlc
    discord
    google-chrome
    python3
    git
    wget
    vscode
    gnome-tweaks
    toybox
    ripgrep
    xclip
    qbittorrent
    blender
    megasync
    heroic
    nixd
    bat
    tree
    sambaFull
    spotify
    yt-dlp
    ffmpeg
    nvtopPackages.nvidia
    piper
    obsidian
    xdg-desktop-portal-gtk
    collector
    nix-init
  ];

  # Brave configuration
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--use-angle=vulkan"
    ];
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;
  };

  # GNOME dconf settings - Map KEY_PROG1 to ROG Control Center
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "XF86Launch1";
      command = "rog-control-center";
      name = "ROG Control Center";
    };
  };

  # Autostart ROG Control Center
  systemd.user.services.rog-control-center = {
    Unit = {
      Description = "ROG Control Center";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.asusctl}/bin/rog-control-center";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
  };

  # State version
  home.stateVersion = "23.05";
}
