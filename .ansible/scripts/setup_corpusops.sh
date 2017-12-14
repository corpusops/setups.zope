#!/usr/bin/env bash
set -e

if [[ -n ${SKIP_CORPUSOPS_SETUP-} ]];then
    echo "-> Skip corpusops setup" >&2
    exit 0
fi

sr=local/corpusops.bootstrap/bin/silent_run
# Maintain corpusops fresh and operational
# Using system one
if [ ! -e local ];then mkdir local;fi

if [ -e /srv/corpusops/corpusops.bootstrap ];then
    echo "Reuse corpusops from system"
    if [ -e local/corpusops.bootstrap ] && [ ! -h local/corpusops.bootstrap ];then
        rm -rvf local/corpusops.bootstrap
    fi
    ln -sf /srv/corpusops/corpusops.bootstrap local/corpusops.bootstrap
fi

# Using local copy in fallback
if [ ! -e local/corpusops.bootstrap ];then
    echo "Install a local copy of corpusops"
    $sr ./sbin/corpusops_install.sh -C -S
fi

# Update corpusops code, ansible & roles
if [[ -z "${SKIP_CORPUSOPS_UPDATE-}" ]];then
    $sr ./sbin/corpusops_install.sh -C -s
else
    echo "-> Skip corpusops update" >&2
fi
