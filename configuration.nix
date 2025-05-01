# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./Hyprland.nix
      ./Gnome.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ]; # added by me

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
  hardware.pulseaudio.enable = false;
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
    description = "TaTsuuYa";
    # I added "docker" to this array
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    steam
    steam-run
    neofetch
    vlc
    discord
    google-chrome
    python3
    git
    wget
    vscode
    #vscode-extensions.ms-dotnettools.vscodeintellicode-csharp
    #vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
    #vscode-extensions.ms-dotnettools.csharp
    #vscode-extensions.ms-dotnettools.csdevkit
    #dotnet-sdk_8
    #dotnet-runtime_8
    #dotnetCorePackages.sdk_8_0_2xx
    #dotnetCorePackages.dotnet_8.sdk
    #omnisharp-roslyn
    gnome-tweaks
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
    vlc
    bat
    tree
    #ollama
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

  # Enables support for 32bit libs that steam uses
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    enable32Bit = true;
    # added for gpu-screen-recorder-gtk
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
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
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

	hardware.nvidia.prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:14:0:0";
	};

  # Add ~/.local/bin/ to $PATH
  environment.localBinInPath = true;

  # for gpu-screen-recorder-gtk
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # for dual-shock 4
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;

  # to keep `source` when deleteing older generations
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

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
  services.ollama = { enable = true; acceleration="cuda"; };

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
}
