{ username, ... }:
let
  secret_prefix = ../secrets;
in
{
  age.secrets = {
    github-shh = {
      file = secret_prefix + /github-ssh.age;
      path = "/home/${username}/.ssh/github-ssh";
      owner = username;
      group = "users";
    };
    github-shh-pub = {
      file = secret_prefix + /github-ssh.pub.age;
      path = "/home/${username}/.ssh/github-ssh.pub";
      owner = username;
      group = "users";
    };

    oracle-shh = {
      file = secret_prefix + /oracle-ssh.age;
      path = "/home/${username}/.ssh/oracle-ssh";
      owner = username;
      group = "users";
    };
    oracle-shh-pub = {
      file = secret_prefix + /oracle-ssh.pub.age;
      path = "/home/${username}/.ssh/oracle-ssh.pub";
      owner = username;
      group = "users";
    };

    kubernetes = {
      file = secret_prefix + /kubernetes.age;
      path = "/home/${username}/.ssh/kubernetes.secret";
      owner = username;
      group = "users";
    };

    tailscale = {
      file = secret_prefix + /tailscale.age;
      path = "/home/${username}/.ssh/tailscale.secret";
      owner = username;
      group = "users";
    };
  };
}
