let
  fractalix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGT/Y1zgcuhNC1iWFyZX2p/6vyHsnm4z/6g6dzJ8wyjI";
  vectorix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIRGcNK8dw90AC9xXwzRDDe29uhKD+RhWn1rxvV831y";
  pi4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5n8GP9bJ0RBh3muDqX4kEgTRGo7OI43J0d5V0pjW0e";
  pi5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsFU9SsmH2OAoDZNOUWqWGwQwNH6uwaPzObhaDP23hL";
  users = [ fractalix vectorix pi4 pi5 ];

  arithmancer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS9kdQWuA+RbbF3LKhxYvcqjud8lU+AJg73lnZQMXR3";
  spinorer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRtKm8rjoGQkEl6KLNG7uq6KnoQrcrJEWAjnKRR5Qtp";
  pi4system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrpZYJfmCCOZGH/S7zJBV7H3l8xHPEC0pxWLyZeKUX2";
  pi5system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIi8vfVuB3fQISZ0oxanEJW6C3RnrP7yz9N1KQm+UpEE";
  systems = [ arithmancer spinorer pi4system pi5system ];
in
{
  "uni-gitconfig.age".publicKeys = users ++ systems;

  "test.age".publicKeys = users ++ systems;

  "github-ssh.age".publicKeys = users ++ systems;
  "github-ssh.pub.age".publicKeys = users ++ systems;

  "oracle-ssh.age".publicKeys = users ++ systems;
  "oracle-ssh.pub.age".publicKeys = users ++ systems;

  "rpi5ssh.age".publicKeys = users ++ systems;
  "rpi4ssh.age".publicKeys = users ++ systems;

  "kubernetes.age".publicKeys = users ++ systems;
  "tailscale.age".publicKeys = users ++ systems;
}
