{pkgs, ...}: let
  site =
    (builtins.getFlake
      "github:rnd/site")
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

  services.tailscale.enable = true;
  # create a oneshot job to authenticate to Tailscale
  #
  # taken from https://tailscale.com/blog/nixos-minecraft
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey file:/etc/tailscale/tskey
    '';
  };
}
