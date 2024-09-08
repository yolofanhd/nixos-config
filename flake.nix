{
  description = "YoloFan's nixos config";

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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , lanzaboote
    , nixos-generators
    , ...
    } @ inputs:
    let
      includeHardwareConfig = builtins.getEnv "SKIP_HARDWARE_CONFIG" != "true";
    in
    {
      nixosModules.myFormats = { ... }: {
        imports = [
          nixos-generators.nixosModules.all-formats
        ];
        nixpkgs.hostPlatform = "x86_64-linux";
      };
      nixosConfigurations = {
        arithmancer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit includeHardwareConfig;
            system = "x86_64-linux";
            hostName = "arithmancer";
            username = "fractalix";
          };
          modules = [
            ./hosts/arithmancer/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            self.nixosModules.myFormats
          ];
        };
        spinorer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit includeHardwareConfig;
            system = "x86_64-linux";
            hostName = "spinorer";
            username = "vectorix";
          };
          modules = [
            ./hosts/spinorer/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            self.nixosModules.myFormats
          ];
        };
        rpi5 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit includeHardwareConfig;
            system = "aarch64-linux";
            hostName = "rpi5";
            username = "pi";
          };
          modules = [
            ./hosts/rpi5/configuration.nix
            inputs.home-manager.nixosModules.default
            self.nixosModules.myFormats
          ];
        };
      };
    };
}
