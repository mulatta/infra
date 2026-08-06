# SjangLab Authentik Login

Slack OAuth/OIDC application used as an Authentik source. It also exposes
`/onboard` to start account creation or linking.

## Create or update

Use the Slack CLI from the repository dev shell:

```sh
nix develop .#slack-deploy
cd slack/authentik_oidc
slack init
slack app install
```

If `apps.manifest.create` is unavailable for your Slack account, create it from the web UI instead:

1. Open <https://api.slack.com/apps>
2. Select **Create New App**
3. Select **From an app manifest**
4. Paste `slack-app-manifest.json`
5. Create app, then run `slack app link`

Push later manifest changes to app settings with:

```sh
slack manifest sync --force --app APP_ID
```

`slack deploy` targets Run on Slack projects and does not apply this manifest-only app.

After creation, copy the Slack app Client ID and Client Secret into the Authentik source secret store. Do not commit credentials here.

## Redirect URL

```text
https://auth.sjanglab.org/source/oauth/callback/slack/
```

## Slash command

```text
/onboard -> https://auth.sjanglab.org/slack/onboard
```

The endpoint must verify Slack request signatures and accept requests only from
workspace `T018TQRSHFY`. It returns a short-lived, single-use Authentik
enrollment or account-link URL.

## Scopes

Bot scope:

- `commands`

User scopes:

- `openid`
- `email`
- `profile`
