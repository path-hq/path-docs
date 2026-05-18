#!/usr/bin/env bash
# ALF-965: verify docs.pathprotocol.finance is live after Mintlify +
# Cloudflare wiring. Exits 0 when the custom domain serves Path docs,
# non-zero otherwise. Designed for re-run in a poll loop while DNS
# propagates (5-30 min typical).

set -u
TARGET="${1:-https://docs.pathprotocol.finance/}"
EXPECT_TITLE="Path"

# DNS check first (cheap, no TLS handshake)
HOST=$(echo "$TARGET" | awk -F/ '{print $3}')
CNAME=$(dig +short CNAME "$HOST" @1.1.1.1 | head -1)
if [ -z "$CNAME" ]; then
  echo "FAIL: no CNAME record for $HOST yet (DNS not propagated or not added)"
  exit 2
fi
echo "OK: $HOST -> $CNAME"

# HTTP check
CODE=$(curl -s -o /tmp/alf965-body.html -w "%{http_code}" -m 15 -L "$TARGET" || echo "000")
if [ "$CODE" != "200" ]; then
  echo "FAIL: $TARGET returned HTTP $CODE (expected 200 after redirect)"
  exit 3
fi
echo "OK: $TARGET HTTP $CODE"

# Content check
if ! grep -q "$EXPECT_TITLE" /tmp/alf965-body.html; then
  echo "FAIL: response body does not contain '$EXPECT_TITLE'"
  exit 4
fi
echo "OK: response contains '$EXPECT_TITLE'"
echo "PASS: docs.pathprotocol.finance is live"
