#!/usr/bin/env bash
# One entry: Homebrew (profile) + shell/theme helpers. Use from Makefile or bootstrap.
# shellcheck shell=bash

set -euo pipefail

_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$_ROOT/modules/lib.sh"
# shellcheck source=brew.sh
source "$_ROOT/modules/brew.sh"
# shellcheck source=zsh.sh
source "$_ROOT/modules/zsh.sh"

require_darwin
main_brew
main_zsh
success "Apps setup finished (SETUP_PROFILE=$(setup_profile))."
