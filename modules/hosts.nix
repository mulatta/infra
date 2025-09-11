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

    wg0 = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Wireguard interface 0 (wg0) address
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
        "office"
        "terraform"
      ];
      default = null;
      description = ''
        Physical location of this host

        IDC: INU datacenter
        office: SBEE lab office
        terraform: provisioned cloud instance
      '';
    };
  };
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
        ipv4 = "117.16.251.37";
        mac = "bc:fc:e7:52:e1:ab";
        wg0 = "10.100.0.1";
        gateway = "117.16.251.254";
        location = "IDC";
      };
      rho = {
        ipv4 = "10.80.169.39";
        mac = "9c:6b:00:9e:fa:de";
        wg0 = "10.100.0.2";
        gateway = "10.80.169.254";
        location = "office";
      };
      tau = {
        ipv4 = "10.80.169.40";
        mac = "9c:6b:00:9e:f8:ef";
        wg0 = "10.100.0.3";
        gateway = "10.80.169.254";
        location = "office";
      };
    };
  };
}
