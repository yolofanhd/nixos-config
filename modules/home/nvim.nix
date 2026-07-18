{ inputs
, system
, ...
}:
let
  myvim = inputs.myvim.packages.${system}.default;
in
{
  home.packages = [ myvim ];
}
