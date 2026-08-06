# Slack apps

Slack workspace applications live here, one directory per application. App
manifests contain identity, redirect URLs, and scopes; credentials stay with
the consuming service's SOPS configuration.

- `authentik_oidc/`: user OAuth/OIDC app for Authentik login
- `infra-alerts/`: Slack bot for infrastructure alert delivery
- `nextcloud_integration/`: user OAuth app for Nextcloud file sharing

Slack App creation, installation, and drift checks use the packaged Slack CLI
from each app directory.
