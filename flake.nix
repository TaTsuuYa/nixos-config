{
  description = "TaTsuuYa's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # copyparty.url = "github:9001/copyparty";
  };

  outputs = { self, nixpkgs, home-manager, lsfg-vk-flake, aagl, /* copyparty */ }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./Gnome.nix
          lsfg-vk-flake.nixosModules.default
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tatsuuya = import ./home-manager/home.nix;
          }

          {
            imports = [ aagl.nixosModules.default ];
            nix.settings = aagl.nixConfig;
            programs.anime-game-launcher.enable = true;
            # programs.anime-games-launcher.enable = true;
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
