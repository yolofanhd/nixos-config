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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    { self
    , nixpkgs
    , lanzaboote
    , nixos-generators
    , agenix
    , ...
    } @ inputs: {
      nixosModules.myFormats = { system, ... }: {
        imports = [
          nixos-generators.nixosModules.all-formats
        ];
        nixpkgs.hostPlatform = system;
      };
      nixosConfigurations = {
        arithmancer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            includeHardwareConfig = true;
            system = "x86_64-linux";
            hostName = "arithmancer";
            username = "fractalix";
          };
          modules = [
            ./hosts/arithmancer/configuration.nix
            inputs.home-manager.nixosModules.default
            agenix.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];
        };
        spinorer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            includeHardwareConfig = true;
            system = "x86_64-linux";
            hostName = "spinorer";
            username = "vectorix";
          };
          modules = [
            ./hosts/spinorer/configuration.nix
            inputs.home-manager.nixosModules.default
            agenix.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];
        };
        rpi5 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            includeHardwareConfig = true;
            system = "aarch64-linux";
            hostName = "rpi5";
            username = "pi";
          };
          modules = [
            ./hosts/rpi5/configuration.nix
            agenix.nixosModules.default
            inputs.home-manager.nixosModules.default
          ];
        };

        image = {
          arithmancer = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              includeHardwareConfig = false;
              system = "x86_64-linux";
              hostName = "arithmancer";
              username = "fractalix";
            };
            modules = [
              ./hosts/arithmancer/configuration.nix
              inputs.home-manager.nixosModules.default
              self.nixosModules.myFormats
            ];
          };
          spinorer = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              includeHardwareConfig = false;
              system = "x86_64-linux";
              hostName = "spinorer";
              username = "vectorix";
            };
            modules = [
              ./hosts/spinorer/configuration.nix
              inputs.home-manager.nixosModules.default
              self.nixosModules.myFormats
            ];
          };
          rpi5 = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              includeHardwareConfig = false;
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
    };
}
