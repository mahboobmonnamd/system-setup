#!/usr/bin/env bash
# Wrapper so existing paths keep working; logic lives in modules/stow.sh.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec bash "$ROOT/modules/stow.sh" "$@"
