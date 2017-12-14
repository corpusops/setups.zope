#!/usr/bin/env bash
set -e
vv() { echo "-> $@" >&2;"$@"; }
T=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
vv "$T/setup_vaults.sh"
vv "$T/setup_core_variables.sh"
vv "$T/setup_corpusops.sh"
