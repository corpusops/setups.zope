# Zope app

DISCLAIMER - ABANDONED/UNMAINTAINED CODE / DO NOT USE
=======================================================
While this repository has been inactive for some time, this formal notice, issued on **December 10, 2024**, serves as the official declaration to clarify the situation. Consequently, this repository and all associated resources (including related projects, code, documentation, and distributed packages such as Docker images, PyPI packages, etc.) are now explicitly declared **unmaintained** and **abandoned**.

I would like to remind everyone that this project’s free license has always been based on the principle that the software is provided "AS-IS", without any warranty or expectation of liability or maintenance from the maintainer.
As such, it is used solely at the user's own risk, with no warranty or liability from the maintainer, including but not limited to any damages arising from its use.

Due to the enactment of the Cyber Resilience Act (EU Regulation 2024/2847), which significantly alters the regulatory framework, including penalties of up to €15M, combined with its demands for **unpaid** and **indefinite** liability, it has become untenable for me to continue maintaining all my Open Source Projects as a natural person.
The new regulations impose personal liability risks and create an unacceptable burden, regardless of my personal situation now or in the future, particularly when the work is done voluntarily and without compensation.

**No further technical support, updates (including security patches), or maintenance, of any kind, will be provided.**

These resources may remain online, but solely for public archiving, documentation, and educational purposes.

Users are strongly advised not to use these resources in any active or production-related projects, and to seek alternative solutions that comply with the new legal requirements (EU CRA).

**Using these resources outside of these contexts is strictly prohibited and is done at your own risk.**

Regarding the potential transfer of the project to another entity, discussions are ongoing, but no final decision has been made yet. As a last resort, if the project and its associated resources are not transferred, I may begin removing any published resources related to this project (e.g., from PyPI, Docker Hub, GitHub, etc.) starting **March 15, 2025**, especially if the CRA’s risks remain disproportionate.

## Corpusops doc (deployment)

### Setup variables
```sh
export A_GIT_URL="git@gitlab.makina-corpus.net:foo/bar.git"
export COPS_CWD="$HOME/makina/<your project>"
export NONINTERACTIVE=1
# VM NOT DONE
export FTP_URL=<tri>@ftp.makina-corpus.net:/srv/projects/makina_commun/data/commun/nobackup/vm_bar/*-*box
```
### Clone the project
- Note the **--recursive** switch; if you follow the next commands, you can then skip this step on the next docs.

    ```sh
    git clone --recursive $A_GIT_URL $COPS_CWD
    git submodule update
    .ansible/scripts/download_corpusops.sh
    .ansible/scripts/setup_ansible.sh
    ```

### Deploy the dev VM
- [corpusops vagrant doc](https://github.com/corpusops/corpusops.bootstrap/blob/master/docs/projects/vagrant.md)<br/>
  or ``local/corpusops.bootstrap/docs/projects/vagrant.md`` after corpusops.bootstrap download.

### Deploy on enviromnents
- Setup needed when you dont have Ci setup for doing it for you
- [corpusops deploy doc](https://github.com/corpusops/corpusops.bootstrap/blob/master/docs/projects/deploy.md)<br/>
  or ``local/corpusops.bootstrap/docs/projects/deploy.md`` after corpusops.bootstrap download.


## Exemple of a generic plone portal deployment

### Add you own sources
- Generate a Plone add-on with mr.bob
- Replace src/test with your generated addon src/ content
- Replace setup.py with the generated version
- Change the `mainegg` value in ./etc/sys/settings.cfg

### OVERRIDE DEFAULT SETTINGS
- On the first checkout you need to create ``etc/sys/settings-local.cfg``/
- You can either create an empty file or copy ``etc/sys/settings.cfg`` and adapt it to your needs.
- Edit the etc/sys/settings-local.cfg file.
```
etc/sys
|
|-- settings.cfg       -> various common settings (crons hours, hosts, installation paths, ports, passwords)
`-- settings-local.cfg -> override locally the common settings (do not commit the file)
```
### PRODUCTION MODE
- To make your application safe for production, run the ``buildout-prod.cfg`` buildout'.
- It extends this one with additionnal crontabs and backup scripts and some additionnal instances creation.

### BASE BUILDOUTS WHICH DO ONLY SCHEDULE PARTS FROM THERE & THERE
```
|-- etc/base.cfg               -> The base buildout
|-- buildout-prod.cfg          -> buildout for production
|-- buildout-dev.cfg           -> buildout for development
```

### PROJECT Files
- Think you have the most important sections of this buildout configuration in etc/cgwb.cfg
Set the project developement  specific settings there
```
etc/project/
|-- plone.cfg       -> your project needs (packages, sources, product, version spinngss)
|-- versions.cfg    -> your project version pinnings (KGS)
`-- kgs.cfg         -> autogenerated to be manual merged in your project version pinngs.
```

### SYSTEM ADMINISTRATORS RELATED FILES
```
etc/sys/
|-- ha.cfg           -> Project loadbalancer settings
|-- supervisor.cfg   -> Project production settings for supervision
|-- system.cfg       -> Project settings (backup)

```

### Static build procedure
```
git checkout prod
git reset --hard origin prod
git merge master
git yarn build # or whatever to build static
# make sure gulp is running, so theme/front is regenerated)
git commit -am "update assets"
git push origin prod:prod
```

**IMPORTANT**: never merge prod in master (as master ignore theme/map, but prod does not)


## USE/Install With makina-states (mostly obsolete)
- Iniatilise on the target platform the project if it is not already done
```sh
salt mc_project.init_project name=<foo>
```

- Keep under the hood both remotes (pillar & project).
- Clone the project pillar remote inside your project top directory
- Add/Relace your salt deployment code inside **.salt** inside your repository.
- Add the project remote
    - replace remotenickname with a sensible name (eg: prod)::
    - replace the_project_remote_given_in_init with the real url
    - Run the following commands::

        ```sh
        git remote add <remotenickname>  <the_project_remote_given_in_init>
        git fetch --all
        ```

- Each time you need to deploy from your computer, run::
    ```sh
    cd pillar
    git push [--force] <remotenickname> <yourlocalbranch(eg: master,prod,whatever)>:master
    cd ..
    git push [--force] <remotenickname> <yourlocalbranch(eg: master,prod,whatever)>:master
    ```

- Notes:
    - The distant branch is always *master**
    - If you force the push, the local working copy of the remote deployed site
      will be resetted to the TIP changeset your are pushing.

- If you want to install locally on the remote computer, or test it locally and
  do not want to run the full deployement procedure, when you are on a shell
  (connected via ssh on the remote computer or locally on your box), run::
    ```sh
    salt mc_project.deploy only=install,fixperms
    ```
- You can also run just specific step(s)::
    ```sh
    salt mc_project.deploy only=install,fixperms only_steps=000_whatever
    salt mc_project.deploy only=install,fixperms only_steps=000_whatever,001_else
    ```
- If you want to commit in prod and then push back from the remote computer, remember
  to push on the right branch, eg::
    ```sh
    git remote add github https://github.com/orga/repo.git
    git fetch --all
    git push github master:prod
    ```

