{
  description = "YoloFanHD's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    myvim.url = "./modules/nixvim";

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
            hostname = "arithmancer";
            username = "fractalix";
          };
          modules = [
            ./hosts/arithmancer/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote # Secure boot
          ];
        };
        spinorer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
            hostname = "spinorer";
            username = "vectorix";
          };
          modules = [
            ./hosts/spinorer/configuration.nix
            inputs.home-manager.nixosModules.default
            #lanzaboote.nixosModules.lanzaboote # Secure boot
          ];
        };
      };
    };
}
