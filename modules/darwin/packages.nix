{ inputs
, pkgs
, system
, ...
}:
let
  prusaSlicer = pkgs.callPackage ../../packages/prusa-slicer-darwin.nix { };
in
{
  environment.systemPackages = with pkgs; [
    ast-grep
    bat
    btop
    clang
    cmake
    delta
    discord
    docker
    eza
    fd
    fzf
    gcc
    git
    inputs.agenix.packages.${system}.default
    inputs.codex-cli-nix.packages.${system}.default
    inputs.nixpkgs-stable.legacyPackages.${system}.blender
    inputs.nixpkgs-zed.legacyPackages.${system}.zed-editor
    inputs.zen-browser.packages.${system}.default
    jq
    just
    kitty
    nil
    nix-index
    nix-tree
    nixd
    nodejs
    prusaSlicer
    python3
    ripgrep
    ruff
    spotify
    tree
    unzip
    uv
    vim
    wget
    yq
  ];
}
