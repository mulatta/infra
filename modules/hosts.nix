# https://github.com/TUM-DSE/doctor-cluster-config/tree/4702b65ba00ccaf932fa87c71eee5a5b584896ab/modules/hosts.nix
{
  lib,
  config,
  ...
}:
let
  hostOptions = with lib; {
    ipv4 = mkOption {
      type = types.str;
      description = ''
        own ipv4 address
      '';
    };

    mac = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        MAC address of the NIC port used as a gateway
      '';
    };

    dns = mkOption {
      type = types.listOf types.str;
      default = null;
      description = ''
        Nameserver
      '';
    };

    wg-mgnt = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Wireguard interface 0 (wg-mgnt) address
      '';
    };

    wg-serv = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Wireguard interface 0 (wg-mgnt) address
      '';
    };

    gateway = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Default gateway for this host
      '';
    };

    location = mkOption {
      type = types.enum [
        "IDC"
        "LAB"
        "VPS"
      ];
      default = null;
      description = ''
        Physical location of this host

        IDC: INU datacenter
        LAB: SBEE lab office
        terraform: provisioned cloud instance
      '';
    };
  };

  dns = [
    "117.16.191.6"
    "168.126.63.1"
  ];
in
{
  imports = [
    ./wireguard
  ];
  options = with lib; {
    networking.sbee.hosts = mkOption {
      type = with types; attrsOf (submodule [ { options = hostOptions; } ]);
      description = "A host in our cluster";
    };
    networking.sbee.currentHost = mkOption {
      type = with types; submodule [ { options = hostOptions; } ];
      default = config.networking.sbee.hosts.${config.networking.hostName};
      description = "The host that is described by this configuration";
    };
  };
  config = {
    warnings =
      lib.optional
        (
          !(config.networking.sbee.hosts ? ${config.networking.hostName})
          && config.networking.hostName != "nixos" # we dont care about nixos netboot/installer images
        )
        "Please add network configuration for ${config.networking.hostName}. None found in ${./hosts.nix}";

    networking.sbee.hosts = {
      psi = {
        inherit dns;
        ipv4 = "117.16.251.37";
        mac = "bc:fc:e7:52:e1:ab";
        wg-mgnt = "10.100.0.1";
        wg-serv = "10.200.0.1";
        gateway = "117.16.251.254";
        location = "IDC";
      };
      rho = {
        inherit dns;
        ipv4 = "10.80.169.39";
        mac = "9c:6b:00:9e:fa:de";
        wg-mgnt = "10.100.0.2";
        wg-serv = "10.200.0.2";
        gateway = "10.80.169.254";
        location = "LAB";
      };
      tau = {
        inherit dns;
        ipv4 = "10.80.169.40";
        mac = "9c:6b:00:9e:f8:ef";
        wg-mgnt = "10.100.0.3";
        wg-serv = "10.200.0.3";
        gateway = "10.80.169.254";
        location = "LAB";
      };
      eta = {
        ipv4 = "158.247.227.38";
        mac = "56:00:05:a2:d3:d7";
        dns = [
          "8.8.8.8"
          "1.1.1.1"
        ];
        wg-mgnt = "10.100.0.4";
        wg-serv = "10.200.0.4";
        gateway = "158.247.227.1";
        location = "VPS";
      };
    };
  };
}
