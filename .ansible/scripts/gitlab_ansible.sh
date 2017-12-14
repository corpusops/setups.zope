#!/usr/bin/env bash
ci_cwd=$(pwd)
vaultpwfile=''
if [ -e $SECRET_VAULT ];then
    vaultpwfile=--vault-password-file="$SECRET_VAULT"
fi
set -ex
echo "CWD: $ci_cwd"
if [[ -n ${NO_SILENT-} ]];then
    echo $PWD .sbin/corpusops.bootstrap/silent_run $AP $vaultpwfile \
        ${PLAYBOOK_PRE_ARGS-} \
        "$PLAYBOOK" \
        ${PLAYBOOK_POST_ARGS-}
else
    echo $PWD  $AP $vaultpwfile \
        ${PLAYBOOK_PRE_ARGS-} \
        "$PLAYBOOK" \
        ${PLAYBOOK_POST_ARGS-}
fi
