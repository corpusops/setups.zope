#!/usr/bin/env bash
set -e
log() { echo "$@" >&2; }
vv() { log "($COPS_CWD) $@";"$@"; }
debug() { if [[ -n "${ADEBUG-}" ]];then log "$@";fi }
export COPS_CWD="${COPS_CWD:-$(pwd)}"
export LOCAL_COPS_ROOT="${LOCAL_COPS_ROOT:-$COPS_CWD/local/corpusops.bootstrap}"
export COPS_ROOT="${COPS_ROOT:-/srv/corpusops/corpusops.bootstrap}"
export CORPUSOPS_URL="${CORPUSOPS_URL:-https://github.com/corpusops/corpusops.bootstrap.git}"
sr=$LOCAL_COPS_ROOT/bin/silent_run
installer=$LOCAL_COPS_ROOT/bin/install.sh
if [[ -n ${SKIP_CORPUSOPS_SETUP-} ]];then
    log "-> Skip corpusops setup"
    exit 0
fi
# Maintain corpusops fresh and operational
# Using system one
if [[ -z ${SKIP_CORPUSOPS_FROM_SYSTEM-} ]] && [ ! -e "$LOCAL_COPS_ROOT" ];then
    if [ ! -e local ];then mkdir local;fi
    if [ "x$(whoami)" = "xroot" ];then
        if [ -e $COPS_ROOT ];then
            log "Reuse corpusops from system"
                if [ -e local/corpusops.bootstrap ] && [ ! -h local/corpusops.bootstrap ];then
                rm -rvf local/corpusops.bootstrap
            fi
            ln -sf $COPS_ROOT $LOCAL_COPS_ROOT
        fi
    fi
fi
# Using local copy in fallback
if [[ -z ${SKIP_CORPUSOPS_CHECKOUT-} ]] && [ ! -e "$LOCAL_COPS_ROOT/.git" ];then
    if ! git clone "$CORPUSOPS_URL" "$LOCAL_COPS_ROOT";then
        log "Error while cloning $CORPUSOPS_URL -> $LOCAL_COPS_ROOT"
        log "Clone error"
        exit 21
    fi
else
        log "corpusops.bootstrap already there in $LOCAL_COPS_ROOT"
fi
