app:
{ config, lib, pkgs, ... }:
let
  flakeryDomain = builtins.readFile /metadata/flakery-domain;
in
{

  system.stateVersion = "23.05";
  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  systemd.services.go-webserver = {
    description = "go webserver";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${app}/bin/app";
      Restart = "always";
      KillMode = "process";
    };
  };

  services.tailscale = {
    enable = true;
    authKeyFile = "/tsauthkey";
    extraUpFlags = [ "--ssh" "--hostname" "flakery-tutorial" ];
  };


}
