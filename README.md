# path-docs

Mintlify-hosted documentation for Path Protocol.

## Local preview

```
npx mintlify@latest dev
```

Mintlify reads `mint.json` for routing + theme. MDX files are
auto-discovered.

## Deploy

This repo is connected to Mintlify via https://dashboard.mintlify.com.
The Mintlify GitHub app builds and hosts each branch as a preview URL.
The `main` branch publishes to https://pathprotocol.mintlify.app
(verified live 2026-05-15, HTTP 200, title `Introduction - Path`).

### Custom domain (docs.pathprotocol.finance) - wiring runbook

Tracked under ALF-965 (impl of the ALF-935 Option 0 design). Two
manual steps that need dashboard logins Alfred does not have:

1. **Mintlify dashboard** (https://dashboard.mintlify.com)
   - Open the `path-hq/path-docs` project.
   - Settings -> Custom domain -> add `docs.pathprotocol.finance`.
   - Mintlify will surface a CNAME target on screen (typically
     `cname.vercel-dns.com` or `cname.mintlify.app`). Copy it.
   - Per https://mintlify.com/pricing (verified 2026-05-15), custom
     domain is on the Hobby (Free) tier. If the dashboard paywalls,
     STOP and re-open ALF-965; do NOT enable Pro (zero-spend rule).

2. **Cloudflare DNS** (https://dash.cloudflare.com, pathprotocol.finance
   zone)
   - DNS -> Records -> Add record.
   - Type: CNAME. Name: `docs`. Target: the value from step 1.
   - Proxy status: DNS-only (grey cloud) so Mintlify can issue TLS.
     After the cert provisions, optionally flip to proxied.
   - Save.

3. **Verify** (5-30 min after the CNAME lands):
   - `bash scripts/verify-custom-domain.sh` (in this repo). The
     script exits 0 when `https://docs.pathprotocol.finance/`
     returns 200 and serves Path docs HTML.
   - Or manually: `curl -I https://docs.pathprotocol.finance/`
     should return HTTP 200 (or 308 redirect to /introduction).

## Content rules

1. No partner names. This is a Path-tech site, not a partnership
   announcement.
2. No code-style model identifiers. Use readable names
   ("1-day yield direction model", not "classifier_1d_binary").
3. No deprecated or shadow models in the public surface. Active
   stack only.
4. Numbers update via the live verifier daemon; do not hardcode
   numerics that will drift.
