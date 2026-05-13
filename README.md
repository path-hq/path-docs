# path-docs

Mintlify-hosted documentation for Path Protocol.

## Local preview

```
npx mintlify@latest dev
```

Mintlify reads `mint.json` for routing + theme. MDX files are
auto-discovered.

## Deploy

Connect this repo to Mintlify via https://dashboard.mintlify.com.
The Mintlify GitHub app builds + hosts each branch as a preview URL
and the `main` branch flips production at https://docs.pathprotocol.finance
(once the DNS CNAME is set on the apex).

## Content rules

1. No partner names. This is a Path-tech site, not a partnership
   announcement.
2. No code-style model identifiers. Use readable names
   ("1-day yield direction model", not "classifier_1d_binary").
3. No deprecated or shadow models in the public surface. Active
   stack only.
4. Numbers update via the live verifier daemon; do not hardcode
   numerics that will drift.
