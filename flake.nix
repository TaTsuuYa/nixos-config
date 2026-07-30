{
  description = "TaTsuuYa's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # copyparty.url = "github:9001/copyparty";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anime-notif ={
      url = "github:TaTsuuYa/anime-notif";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lsfg-vk-flake, aagl, nix-index-database, anime-notif /* copyparty */ }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./Gnome.nix
          
          nix-index-database.nixosModules.default

          lsfg-vk-flake.nixosModules.default
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tatsuuya = {
            imports = [
                ./home-manager/home.nix
                anime-notif.homeManagerModules.default
              ];
              services.anime-notif = {
                enable = true;
                settings = {
                  downloads = {
                    base_dir = "~/Anime/Seasonal";
                    default_resolution = "1080";
                    default_method = "magnet";
                  };
                  notifications = {
                    sound_file = ./anime-notif/notif.wav;
                  };
                  categories = [
                    { name = "liked"; notify = true; auto_download = true; }
                    { name = "normal"; notify = true; auto_download = false; }
                    { name = "uninterested"; notify = false; auto_download = false; }
                  ];
                  sources = [ ./anime-notif/subsplease.toml ];
                };
              };
            };
          }

          {
            imports = [ aagl.nixosModules.default ];
            nix.settings = aagl.nixConfig;
            programs.anime-game-launcher.enable = true;
            programs.anime-games-launcher.enable = true;
            # programs.honkers-railway-launcher.enable = true;
            # programs.honkers-launcher.enable = true;
            # programs.wavey-launcher.enable = true;
            # programs.sleepy-launcher.enable = true;
          }
          
          # load the copyparty NixOS module
          # copyparty.nixosModules.default
          # ({ pkgs, ... }: {
          #   # add the copyparty overlay to expose the package to the module
          #   nixpkgs.overlays = [ copyparty.overlays.default ];
          #   # (optional) install the package globally
          #   environment.systemPackages = [ pkgs.copyparty ];
          #   # configure the copyparty module
          #   services.copyparty.enable = true;
          # })
        ];
      };
    };
  };
}
