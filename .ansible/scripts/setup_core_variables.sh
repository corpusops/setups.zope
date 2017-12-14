#!/usr/bin/env bash
set -e
ci_cwd="$(pwd)"
export cops_cwd="${cops_cwd:-${ci_cwd}}"
export cops_path="${cops_path:-"${cops_cwd}/local/corpusops.bootstrap"}"
export cops_playbooks="${cops_playbooks:-"${cops_path}/playbooks/corpusops"}"
log() { echo "$@" >&2; }
vv() { log "($ci_cwd) $@";"$@"; }
debug() { if [[ -n "${ADEBUG-}" ]];then echo "$@" >&2;fi }
if [ ! -e local ];then
    mkdir local
fi

cat > local/gitlabci.yml << EOF
cops_path: "$cops_path"
cops_cwd: "$cops_cwd"
cops_playbooks: "$cops_playbooks"
EOF

debug "Core vault:"
debug "$(cat local/gitlabci.yml)"
