# suhlig.foundation.tailscale_service

Publishes a local HTTP(S) backend as a [Tailscale Service](https://tailscale.com/kb/1552/tailscale-services): stable MagicDNS name (`<name>.<tailnet>.ts.net`), TailVIP, auto-provisioned TLS certificate, tailnet-only access.

## Role variables

| Variable | Default | Description |
|---|---|---|
| `tailscale_service_name` | `svc:example` | Service identity (`svc:` prefix required); must match the Service defined in the admin console |
| `tailscale_service_port` | `443` | Port the Service listens on |
| `tailscale_service_backend` | `http://127.0.0.1:8080` | Local backend URL to proxy to |

## Example: Home Assistant on opus

```yaml
- hosts: opus
  become: true
  roles:
    - role: suhlig.foundation.tailscale_service
      vars:
        tailscale_service_name: svc:home-assistant
        tailscale_service_backend: http://127.0.0.1:8123
```

Result: `https://home-assistant.<tailnet>.ts.net/`.

The role runs `tailscale serve --service=<name> --https=<port> <backend>` in background mode, which configures and advertises the endpoint in one step. Re-running updates the same endpoint and leaves other Services on the host untouched.

## Manual Tailscale steps

### One-time per tailnet

1. Enable MagicDNS and HTTPS certificates (admin console > DNS).
2. Define a device tag (Access controls > Tags, or `tagOwners` in the JSON editor), e.g. `tag:server`.
3. Add an SSH rule for tagged devices — tagging a device drops the default "SSH to your own devices" (`autogroup:self`) rule:

   ```json
   {"action": "accept", "src": ["autogroup:admin"], "dst": ["tag:server"], "users": ["autogroup:nonroot", "root"]}
   ```

4. (Recommended) Auto-approve service hosts by merging into the *existing* `autoApprovers` block — the key must include the `svc:` prefix:

   ```json
   "autoApprovers": { "services": { "svc:metrics": ["tag:server"] } }
   ```

### Per service

1. Tag the host device once: `sudo tailscale up --advertise-tags=tag:server`.
2. Define the Service (admin console > Services > Advertise > Define a Service): name (e.g. `metrics`), endpoint `tcp:443`, optional tag.
3. Run the role (see example above).
4. Approve the host if there is no auto-approval (Services > `<name>` > Service hosts > Approve).
5. Verify: browse `https://<name>.<tailnet>.ts.net/`.

Client versions: host >= 1.86; peers >= 1.94 (older Linux peers need `tailscale set --accept-routes`).
