# -*- mode: ruby -*-
$ABSFILE = File.absolute_path(__FILE__)
$ABSDIR = File.dirname($ABSFILE)
$COPS_DIR = ENV.fetch('COPS_DIR', File.join($ABSDIR, "local/corpusops.bootstrap"))

def load_glue()
    # test for vagrant glue to be in a project ./local subdir or if
    # we are already on corpusops.bootstrap
    [[$ABSDIR, $COPS_DIR], [$ABSDIR, $ABSDIR]].each do |cwd, cops_path|
        v = "#{cops_path}/hacking/vagrant/Vagrantfile_common.rb"
        if File.exists? v
            vagrant_common = v
            require vagrant_common
            return cops_dance({:cwd => cwd, :cops_path => cops_path})
        end
    end
    raise "Corpusops.bootstrap vagrantfile not found"
end
cfg = load_glue()

# add here post common modification like modifying played ansible playbooks
# please use file variables to let users a way to call manually ansible
ansible_vars = {
    :raw_arguments => [
      "-e@.ansible/vaults/default.yml",
      "-e@.ansible/vaults/vagrant.yml",
      "-e@.ansible/vaults/app.yml"
    ]
}

# playbooks than plays everywhere
cfg = cops_inject_playbooks \
    :cfg => cfg,
    :playbooks => [
        # install docker
        {"#{cfg['COPS_REL_PLAYBOOKS']}/provision/vagrant/docker.yml" => ansible_vars},
        # install nginx http server
        # install PHP-FPM
        # install a postgresql server, db & user
        # install drupal (fpm-pool && drupal setup)
        {".ansible/playbooks/site_vagrant.yml" => ansible_vars},
    ]

# install rancher server only on first box
#cfg = cops_inject_playbooks \
#    :cfg => cfg,
#    :playbooks => [
#        # install rancher server
#        {"playbooks/vbox_server.yml" => ansible_vars},
#        # base configure server & register the vbox itself as an agent
#        {"playbooks/vbox_standalone.yml" => ansible_vars},
#        # cleanup
#        {"playbooks/vbox_rancher_cleanup.yml" => ansible_vars},
#    ],
#    :machine_num => cfg['MACHINE_NUM']

debug cfg.to_yaml
# vim: set ft=ruby ts=4 et sts=4 tw=0 ai:
