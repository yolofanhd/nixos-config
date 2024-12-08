let
  fractalix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGT/Y1zgcuhNC1iWFyZX2p/6vyHsnm4z/6g6dzJ8wyjI";
  vectorix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIRGcNK8dw90AC9xXwzRDDe29uhKD+RhWn1rxvV831y";
  pi4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5n8GP9bJ0RBh3muDqX4kEgTRGo7OI43J0d5V0pjW0e";
  pi5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsFU9SsmH2OAoDZNOUWqWGwQwNH6uwaPzObhaDP23hL";
  users = [ fractalix vectorix pi4 pi5 ];

  arithmancer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS9kdQWuA+RbbF3LKhxYvcqjud8lU+AJg73lnZQMXR3";
  spinorer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRtKm8rjoGQkEl6KLNG7uq6KnoQrcrJEWAjnKRR5Qtp";
  pi4system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+CU5raZ+vwE6Nv2f8Y10/wG92gviik7LS2L6R9h8n/";
  pi5system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK1rlhG3imQL6jfzzEPZyX5T8eWku66b14gk6C96QFYW";
  systems = [ arithmancer spinorer pi4system pi5system ];
in
{
  "test.age".publicKeys = users ++ systems;

  "github-ssh.age".publicKeys = users ++ systems;
  "github-ssh.pub.age".publicKeys = users ++ systems;

  "oracle-ssh.age".publicKeys = users ++ systems;
  "oracle-ssh.pub.age".publicKeys = users ++ systems;

  "rpi5ssh.age".publicKeys = users ++ systems;
  "rpi4ssh.age".publicKeys = users ++ systems;

  "kubernetes.age".publicKeys = users ++ systems;
}
