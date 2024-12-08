let
  fractalix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGT/Y1zgcuhNC1iWFyZX2p/6vyHsnm4z/6g6dzJ8wyjI";
  vectorix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIRGcNK8dw90AC9xXwzRDDe29uhKD+RhWn1rxvV831y";
  users = [ fractalix vectorix ];

  arithmancer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS9kdQWuA+RbbF3LKhxYvcqjud8lU+AJg73lnZQMXR3";
  spinorer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRtKm8rjoGQkEl6KLNG7uq6KnoQrcrJEWAjnKRR5Qtp";
  systems = [ arithmancer spinorer ];

  pi4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSbadmd06YNsvjtypxqQCZSyVcEjysyXpCDyi6NZWhC";
  pi5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSbadmd06YNsvjtypxqQCZSyVcEjysyXpCDyi6NZWhC";

  pi4system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+CU5raZ+vwE6Nv2f8Y10/wG92gviik7LS2L6R9h8n/";
  pi5system = "";

  k3s_users = [ pi4 pi5 ];
  k3s_systems = [ pi4system pi5system ];
in
{
  "test.age".publicKeys = users ++ systems;

  "github-ssh.age".publicKeys = users ++ systems;
  "github-ssh.pub.age".publicKeys = users ++ systems;

  "oracle-ssh.age".publicKeys = users ++ systems;
  "oracle-ssh.pub.age".publicKeys = users ++ systems;

  "rpi5ssh.age".publicKeys = users ++ systems;
  "rpi4ssh.age".publicKeys = users ++ systems;

  "kubernetes.age".publicKeys = k3s_users ++ k3s_systems;
}
