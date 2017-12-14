#!/usr/bin/env bash
set -e
ci_cwd=$(pwd)
export COPS_ROOT="${cops_path:-"${ci_cwd}/local/corpusops.bootstrap"}"
export AP=${AP:-"$COPS_ROOT/bin/ansible-playbook"}
log() { echo "$@" >&2; }
vv() { log "($ci_cwd) $@";"$@"; }
debug() { if [[ -n "${ADEBUG-}" ]];then echo "$@" >&2;fi }
vaultpwfiles=''
for SECRET_VAULT in $SECRET_VAULTS;do
    vault=$(echo "$SECRET_VAULT"|awk -F@ '{print $1}')
    if [ -e $vault ];then
        echo "-> Using vault: $vault" >&2
        if "$AP" --help|grep -q vault-id;then
            vaultpwfiles="--vault-id=$vault"
        else
            vaultpwfiles="--vault-password-file=$vault"
        fi
    else
        debug "No vault password found in $vault" >&2
    fi
done
log "-> In $ci_cwd"
if [[ -n ${ANSIBLE_DRY_RUN-${DRY_RUN-}} ]];then
    log run \
      $AP \
      $vaultpwfiles \
      $A_INVENTORY \
      ${A_CUSTOM_ARGS-} \
      ${PLAYBOOK_PRE_ARGS-} \
      ${PLAYBOOK_PRE_CUSTOM_ARGS-} \
      $PLAYBOOK \
      ${PLAYBOOK_POST_ARGS-} \
      ${PLAYBOOK_POST_CUSTOM_ARGS-}
    exit 0
fi
debug "vaultpwfiles: $vaultpwfiles"
if [[ -z "${NO_SILENT-}" ]];then
  $COPS_ROOT/bin/silent_run \
      $AP \
      $vaultpwfiles \
      $A_INVENTORY \
      ${A_CUSTOM_ARGS-} \
      ${PLAYBOOK_PRE_ARGS-} \
      ${PLAYBOOK_PRE_CUSTOM_ARGS-} \
      $PLAYBOOK \
      ${PLAYBOOK_POST_ARGS-} \
      ${PLAYBOOK_POST_CUSTOM_ARGS-}
else
  $AP \
      $vaultpwfiles \
      $A_INVENTORY \
      ${A_CUSTOM_ARGS-} \
      ${PLAYBOOK_PRE_ARGS-} \
      ${PLAYBOOK_PRE_CUSTOM_ARGS-} \
      $PLAYBOOK \
      ${PLAYBOOK_POST_ARGS-} \
      ${PLAYBOOK_POST_CUSTOM_ARGS-}
fi
