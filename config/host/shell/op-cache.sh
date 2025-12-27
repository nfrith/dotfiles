#!/bin/bash
# op-cache.sh - Cached 1Password secret reader
# Usage: op-cache <cache-key> <op-reference> [ttl-seconds]
#
# Caches secrets locally for fast shell startup. Re-fetches from 1Password
# when cache expires (default 24 hours).

set -uo pipefail

CACHE_KEY="${1:?Cache key required}"
OP_REF="${2:?1Password reference required}"
TTL="${3:-86400}"  # Default: 24 hours

CACHE_DIR="$HOME/.cache/op-secrets"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

mkdir -p "$CACHE_DIR"
chmod 700 "$CACHE_DIR"

# Check if cache exists and is fresh
if [[ -f "$CACHE_FILE" ]]; then
  # macOS uses -f %m, Linux uses -c %Y
  file_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)))
  if [[ $file_age -lt $TTL ]]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# Cache miss or stale - fetch from 1Password
secret=$(op read "$OP_REF" 2>/dev/null)

if [[ -n "$secret" ]]; then
  echo "$secret" > "$CACHE_FILE"
  chmod 600 "$CACHE_FILE"
  echo "$secret"
elif [[ -f "$CACHE_FILE" ]]; then
  # Fallback to stale cache if op fails
  cat "$CACHE_FILE"
fi
