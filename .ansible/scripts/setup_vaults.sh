#!/usr/bin/env bash
set -e
ci_cwd=$(pwd)
log() { echo "$@" >&2; }
vv() { log "($ci_cwd) $@";"$@"; }
debug() { if [[ -n "${ADEBUG-}" ]];then echo "$@" >&2;fi }

VAULT_PASSWORD_VARIABLES_PREFIX=${VAULT_PASSWORD_VARIABLES_PREFIX:-CORPUSOPS_VAULT_PASSWORD_}
debug "VAULT_PASSWORD_VARIABLES_PREFIX: $VAULT_PASSWORD_VARIABLES_PREFIX"
if [[ -n ${SKIP_VAULT_PASSWORD_FILES_SETUP-} ]];then
    echo "-> Skip ansible vault password files setup" >&2
    exit 0
fi

# Setup ansible vault password files if any (via gitlab secret variable)
# from each found CORPUSOPS_VAULT_PASSWORD_XXX
export VAULT_VARS=$( printenv \
    | egrep -oe "^${VAULT_PASSWORD_VARIABLES_PREFIX}[a-zA-Z]+=" \
    | sed -e "s/=$//g"|awk '!seen[$0]++')
debug "VAULT_VARS: $VAULT_VARS"
for vault_var in $VAULT_VARS;do
    vault_name="$(echo $vault_var \
        | awk -F "${VAULT_PASSWORD_VARIABLES_PREFIX}" '{print $2}')"
    val="$(eval "echo \$$vault_var")"
    f="$SECRET_VAULT_PREFIX.$vault_name"
    echo "setup $vault_name vault: ($f)"
    if [[ -n "$val" ]];then
        echo "$val" > "$f"
        chmod 600 "$f"
    fi
done
