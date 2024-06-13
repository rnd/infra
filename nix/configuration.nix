{pkgs, ...}: let
  site =
    (builtins.getFlake
      "path:/home/randy/code/rnd/site")
    .packages
    .${builtins.currentSystem}
    .default;
in {
  system.stateVersion = "23.11";

  environment.systemPackages = with pkgs; [
    git
  ];

  networking.firewall.allowedTCPPorts = [22 80 443];

  services.openssh.settings.PasswordAuthentication = false;

  security.acme.certs."rndir.cc".email = "randy@rndir.cc";
  security.acme.acceptTerms = true;
  services.sshd.enable = true;

  systemd.services.rnd-site = {
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${site}/bin/site";
      WorkingDirectory = "${site}/bin";
      Restart = "on-failure";
      RestartSec = "10";
    };
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."rndir.cc" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7001";
    };
  };
}
