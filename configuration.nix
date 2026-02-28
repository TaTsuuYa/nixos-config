# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # Enable Flakes and other experimental features
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    keep-outputs = true;
    keep-derivations = true;

    # Caching settings
    substituters = [ 
      "https://ezkea.cachix.org" # AAGL
      "https://cache.nixos.org/"
      # "nix-community.cachix.org"
    ];
    trusted-public-keys = [ 
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # store optimization
    auto-optimise-store = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ]; # added by me

  # Ensure common sound kernel modules are loaded early so USB/HDMI audio devices appear
  boot.kernelModules = [ "snd_usb_audio" "snd_hda_intel" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Casablanca";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tatsuuya = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "TaTsuuYa";
    # I added "docker" to this array
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Required system packages (removed user packages that are now in home-manager)
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    steam
    steam-run
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # my edits
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
    "discord"

    # ollama
    "cuda_cccl"
    "cuda_cudart"
    "cuda_nvcc"
    "libcublas"
    "nvidia-settings"
    "nvidia-x11"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # "qbittorrent-qt5-4.6.4"
  ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Hardware acceleration and 32-bit support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # for piper
  services.ratbagd.enable = true;

  # uncomment to: do nothing when the lid is closed
  #services.upower.enable = lib.mkForce false;
  #services.logind.extraConfig = ''
  #  HandleLidSwitch=ignore
  #'';

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA Configuration
  hardware.nvidia = {
    # Modesetting is required for all Nvidia GPU generations
    modesetting.enable = true;

    # Nvidia power management. Re-enabled for better support
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Use the proprietary driver
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Use the stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Prime configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # These are more reliable default values for laptops
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Ensure NVIDIA settings are applied in the correct order
  system.activationScripts.nvidia-settings = {
    text = ''
      # Set up NVIDIA kernel parameters
      if [ -f /proc/sys/nvidia/registry ] ; then 
        echo "PowerMizerEnable=0x1" > /proc/sys/nvidia/registry
        echo "PerfLevelSrc=0x2222" > /proc/sys/nvidia/registry
        echo "PowerMizerLevel=0x3" > /proc/sys/nvidia/registry
        echo "PowerMizerDefault=0x3" > /proc/sys/nvidia/registry
        echo "TCCSupported=0x0" > /proc/sys/nvidia/registry
      fi
    '';
    deps = [];
  };

  # NVIDIA-specific kernel parameters
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # Re-enable suspend, hibernate, and resume services
  systemd.services.nvidia-suspend.enable = true;
  systemd.services.nvidia-hibernate.enable = true;
  systemd.services.nvidia-resume.enable = true;

  # Add ~/.local/bin/ to $PATH
  environment.localBinInPath = true;

  # for gpu-screen-recorder-gtk
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  # for dual-shock 4
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;

  # for docker
  virtualisation.docker.enable = true;

  # ASUS stuff
  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # bash aliases
  programs.bash = {
    shellAliases = {
      # default
      c = "clear";

      # Nix
      nx-conf = "code /etc/nixos/configuration.nix";
      nx-rb-switch = "sudo nixos-rebuild switch";
      nx-rb-switch-up = "sudo nixos-rebuild switch --upgrade";
      nx-rb-boot = "sudo nixos-rebuild boot";
      nx-rb-boot-up = "sudo nixos-rebuild boot --upgrade";

      # Git
      ginit = "git init";
      gadd = "git add";
      gcomm = "git commit";
      gpll = " git pull";
      gpsh = "git push";
      gs = "git status";
    };
  };

  # set git settings
  programs.git.config = {
    init.defaultBranch = "main"; # default branch: main
  };

  # ollama
  services.ollama = { enable = true; acceleration = "cuda"; };

  # Fix game latency
  # networking.interfaces.eno2.tc.qdisc = "fq_codel";
  # networking.interfaces.wlo1.tc.qdisc = "fq_codel";

  # pgsql
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/var/lib/postgresql/16"; # Directory for the database files
    initialScript = pkgs.writeText "init.sql" ''
      CREATE ROLE tatsuuya WITH LOGIN SUPERUSER PASSWORD 'yourpassword';
      CREATE DATABASE mydb OWNER tatsuuya;
    '';
  };

  # KDEConnect networking for Gnome
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  #environment.variables = {
  #  DOTNET_ROOT = "/nix/store/857lb4p516avw491s8i5pzglwrki8n36-dotnet-sdk-8.0.300";
  #};

  # subsplease notif service 
  # systemd.services.subspleasenotif = {
  #   description = "SubspleaseNotif";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig = {
  #     ExecStart = "/usr/bin/env bash -c /home/tatsuuya/.local/bin/subsplease-notif";
  #     Restart = "on-failure";
  #     User = "tatsuuya";
  #     Environment = [
  #       "PATH=/run/current-system/sw/bin:/usr/bin:/home/tatsuuya/.nix-profile/bin/"
  #       "DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/dbus-jkdz1R9iac,guid=e90813fc19fbf61d7488643566f30e63"
  #       "DBUS_SESSION_BUS_PID=91051"
  #       "DBUS_SESSION_BUS_WINDOWID=48234497"
  #     ];
  #   };
  # };

  # Font configuration
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  # lsfg-vk
  services.lsfg-vk = {
    enable = true;
    ui.enable = true; # installs gui for configuring lsfg-vk
  };

  # add windows boot entry
  boot.loader.systemd-boot.windows = { 
    "windows" =
    let
      # To determine the name of the windows boot drive, boot into edk2 first,
      # (uncomment the lines bellow) then run `map -c` to get drive aliases,
      # and try out running `FS1:`, then `ls EFI` to check which alias
      # corresponds to which EFI partition.
      boot-drive = "FS1";
    in
    {
      title = "Windows";
      efiDeviceHandle = boot-drive;
      sortKey = "y_windows";
    };
  };

  # auto garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +5";
  };

  # edk2 uefi shell
  # boot.loader.systemd-boot = {
  #   edk2-uefi-shell.enable = true;
  #   edk2-uefi-shell.sortKey = "z_edk2";
  # };
  
  # copyparty
  # services.copyparty = {
  #   enable = true;
  #   # directly maps to values in the [global] section of the copyparty config.
  #   # see `copyparty --help` for available options
  #   settings = {
  #     i = "0.0.0.0";
  #     # use lists to set multiple values
  #     p = [ 3210 3211 ];
  #     # use booleans to set binary flags
  #     no-reload = true;
  #     # using 'false' will do nothing and omit the value when generating a config
  #     ignored-flag = false;
  #   };

  #   # create users
  #   accounts = {
  #     # specify the account name as the key
  #     # ed = {
  #     #   # provide the path to a file containing the password, keeping it out of /nix/store
  #     #   # must be readable by the copyparty service user
  #     #   passwordFile = "/run/keys/copyparty/ed_password";
  #     # };
  #     # or do both in one go
  #     TaTsuuYa.passwordFile = "/home/tatsuuya/tatsuuya/.config/copypartypwd/file.txt";
  #   };

  #   # create a volume
  #   volumes = {
  #     # create a volume at "/" (the webroot), which will
  #     "/" = {
  #       # share the contents of "/srv/copyparty"
  #       path = "/home/tatsuuya/copyparty_volume/";
  #       # see `copyparty --help-accounts` for available options
  #       access = {
  #         # everyone gets read-access, but
  #         r = "*";
  #         # users "ed" and "k" get read-write
  #         A = [ "TaTsuuYa" ];
  #       };
  #       # see `copyparty --help-flags` for available options
  #       flags = {
  #         # "fk" enables filekeys (necessary for upget permission) (4 chars long)
  #         fk = 4;
  #         # scan for new files every 60sec
  #         scan = 60;
  #         # volflag "e2d" enables the uploads database
  #         e2d = true;
  #         # "d2t" disables multimedia parsers (in case the uploads are malicious)
  #         d2t = true;
  #         # skips hashing file contents if path matches *.iso
  #         nohash = "\.iso$";
  #       };
  #     };
  #   };
  #   # you may increase the open file limit for the process
  #   openFilesLimit = 8192;
  # };
}
