{ username, ... }:
let
  home = "/Users/${username}";
  secret_prefix = ../../secrets;
in
{
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    github-ssh = {
      file = secret_prefix + /github-ssh.age;
      path = "${home}/.ssh/github-ssh";
      owner = username;
      group = "staff";
      mode = "600";
    };
    github-ssh-pub = {
      file = secret_prefix + /github-ssh.pub.age;
      path = "${home}/.ssh/github-ssh.pub";
      owner = username;
      group = "staff";
      mode = "644";
    };

    gitlab-ssh = {
      file = secret_prefix + /gitlab-ssh.age;
      path = "${home}/.ssh/gitlab-ssh";
      owner = username;
      group = "staff";
      mode = "600";
    };
    gitlab-ssh-pub = {
      file = secret_prefix + /gitlab-ssh.pub.age;
      path = "${home}/.ssh/gitlab-ssh.pub";
      owner = username;
      group = "staff";
      mode = "644";
    };

    oracle-ssh = {
      file = secret_prefix + /oracle-ssh.age;
      path = "${home}/.ssh/oracle-ssh";
      owner = username;
      group = "staff";
      mode = "600";
    };
    oracle-ssh-pub = {
      file = secret_prefix + /oracle-ssh.pub.age;
      path = "${home}/.ssh/oracle-ssh.pub";
      owner = username;
      group = "staff";
      mode = "644";
    };

    kubernetes = {
      file = secret_prefix + /kubernetes.age;
      path = "${home}/.ssh/kubernetes.secret";
      owner = username;
      group = "staff";
    };
  };

  system.activationScripts.preActivation.text = ''
    mkdir -p ${home}/.ssh
    chown ${username}:staff ${home}/.ssh
    chmod 700 ${home}/.ssh
  '';
}
