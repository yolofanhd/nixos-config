{
  description = "YoloFanHD's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    myvim.url = "github:yolofanhd/nixvim-config";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";
    rpi5-flake.url = "git+https://gitlab.com/vriska/nix-rpi5.git";
  };

  outputs =
    { nixpkgs
    , lanzaboote
    , ...
    } @ inputs: {
      nixosConfigurations = {
        arithmancer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
            hostName = "arithmancer";
            username = "fractalix";
            rootDeviceUuid = "65eec619-2d7c-45e3-b905-898f4ee59be8";
          };
          modules = [
            ./hosts/arithmancer/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];
        };
        spinorer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
            hostName = "spinorer";
            username = "vectorix";
            rootDeviceUuid = "4a76637d-da9f-4eb9-a278-532252a1d104";
          };
          modules = [
            ./hosts/spinorer/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];
        };
        rpi5 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "aarch64-linux";
            hostName = "rpi5";
            username = "pi";
          };
          modules = [
            ./hosts/rpi5/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
