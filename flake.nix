{
  description = "YoloFan's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    rpi5-flake.url = "git+https://gitlab.com/vriska/nix-rpi5.git";

    home-manager.url = "github:nix-community/home-manager";
    myvim.url = "github:yolofanhd/nixvim-config";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    , nixpkgs-stable
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

        rpi5 = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            includeHardwareConfig = true;
            isPi5 = true;
            isNotMain = false;
            system = "aarch64-linux";
            hostName = "rpi5";
            username = "pi";
          };
          modules = [
            ./hosts/rpi/configuration.nix
            agenix.nixosModules.default
            inputs.home-manager.nixosModules.default
          ];
        };
        rpi4 = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            includeHardwareConfig = true;
            isPi5 = false;
            isNotMain = true;
            system = "aarch64-linux";
            hostName = "rpi4";
            username = "pi";
          };
          modules = [
            ./hosts/rpi/configuration.nix
            agenix.nixosModules.default
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
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
