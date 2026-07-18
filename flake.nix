{
  description = "YoloFan's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-zed.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    rpi5-flake.url = "git+https://gitlab.com/vriska/nix-rpi5.git";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    myvim.url = "github:yolofanhd/nixvim-config";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
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

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , nix-darwin
    , lanzaboote
    , nixos-generators
    , agenix
    , ...
    } @ inputs:
    let
      hardwareConfigPath = builtins.getEnv "NIXOS_HARDWARE_CONFIG";
      hardwareConfig =
        if hardwareConfigPath == "" then
          null
        else
          builtins.toPath hardwareConfigPath;

      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              agenix.packages.${system}.default
              bash
              gh
              git
              just
              nix
              python3
            ];
          };
        }
      );

      formatter = forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      nixosModules.myFormats = { system, ... }: {
        imports = [
          nixos-generators.nixosModules.all-formats
        ];
        nixpkgs.hostPlatform = system;
      };
      nixosConfigurations = {
        arithmancer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit hardwareConfig;
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
        rpi5 = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            inherit hardwareConfig;
            isPi5 = true;
            isNotMain = false;
            system = "aarch64-linux";
            hostName = "rpi5";
            username = "pi";
          };
          modules = [
            ./hosts/rpi/configuration.nix
            agenix.nixosModules.default
            inputs.home-manager-stable.nixosModules.default
          ];
        };
        rpi4 = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
            inherit hardwareConfig;
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
            inputs.home-manager-stable.nixosModules.default
          ];
        };
      };
      darwinConfigurations = {
        macos = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
            system = "aarch64-darwin";
            hostName = "macos";
            username = "dl";
          };
          modules = [
            ./hosts/darwin/configuration.nix
            inputs.home-manager.darwinModules.default
            agenix.darwinModules.default
          ];
        };
      };
    };
}
