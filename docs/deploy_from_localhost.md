# Setup vars
- Before running commands, export or adapt the commands to reflect those vars
- First, create project working dir
- review local env (git url)
```sh
$EDITOR .ansible/scripts/ansible_deploy_env.local
```

- launch env script
```sh
# Export variables
export A_ENV_NAME="staging"
# local working directory
export COPS_CWD=$HOME/projects/myproject
export A_GIT_URL=https://gitlab/your/project
# Setup root dir
if [ ! -e "$COPS_CWD" ];then  mkdir "$COPS_CWD";fi
```

## Prepare localhost for deployment
##  Clone project
- Attention folder must be empty for cloning directly inside it.
```sh
cd $COPS_CWD
git clone --recursive $A_GIT_URL $COPS_CWD
```

# Install & keep corpusops.bootstrap up to date
- If you want to reuse a working cops, symlink it into <br/>
  ``local/corpusops.bootstrap`` before launching the script

```sh
# With a working install of corpusops inside corig_root
# ln -s $corig_root local/corpusops.bootstrap
cd $COPS_CWD
.ansible/scripts/download_corpusops.sh
.ansible/scripts/setup_corpusops.sh
```

# Setup environment ssh key, vault, & inventory
## non interactive mode
```sh
export NONINTERACTIVE=1
```


## create env ssh key
- To generate a ssh keypair:
```sh
cd $COPS_CWD/local
ssh-keygen -t rsa -b 2048 -N '' -f <env_name>
```

## Create or update env vault
The env vault contains the ssh key to deploy on environments, replace the ssh settings (pub & private by the content of the key files generated previously)

Inspire from:
- [.ansible/vaults/staging.yml](../.ansible/vaults/staging.yml)
- [.ansible/vaults/staging.clear.yml](../.ansible/vaults/staging.clear.yml)
- Create/edit vault
```sh
cd $COPS_CWD
eval "CORPUSOPS_VAULT_PASSWORD_${A_ENV_NAME}='SUPER_SECRET_PASSWORD' \
    .ansible/scripts/setup_vaults.sh"
# crypted vars (password, keys)
.ansible/scripts/edit_vault.sh
# or .ansible/scripts/edit_vault.sh .ansible/vaults/specificvault.yml
# not crypted vars
$EDITOR .ansible/vaults/${A_ENV_NAME}.clear.yml
```

## Review inventory
- Copy &/or edit the inventory to adapt to your env (``.ansible/inventory_*``)
- If you copy, think to adapt variables

## Run a deployment for a host

### Setup ansible
#### Generate core vars
```sh
.ansible/scripts/setup_core_variables.sh
```
#### Generate boilerplate all at once
- Alternativly you can launch this one command to
    - Generate core vars
    - Setup vault password files
    - Refresh corpusops
    - think that you can also setup the ``CORPUSOPS_VAULT_PASSWORD_<env>`` var in your CI secret variables in a CI/CD env.
```sh
export A_ENV_NAME=staging
eval "CORPUSOPS_VAULT_PASSWORD_${A_ENV_NAME}='SUPER_SECRET_PASSWORD' \
.ansible/scripts/setup_ansible.sh"
```

## Generate SSH deploy key locally
```sh
export A_ENV_NAME=staging
.ansible/scripts/call_ansible.sh .ansible/playbooks/deploy_key_setup.yml
```

## Launch the deployment
```sh
export A_ENV_NAME=staging
# .ansible/scripts/call_ansible.sh .ansible/playbooks/<playbook>.yml
# eg:
.ansible/scripts/call_ansible.sh .ansible/playbooks/app.yml
.ansible/scripts/call_ansible.sh .ansible/playbooks/db.yml
.ansible/scripts/call_ansible.sh .ansible/playbooks/haproxy.yml
.ansible/scripts/call_ansible.sh .ansible/playbooks/db_backup.yml
```
