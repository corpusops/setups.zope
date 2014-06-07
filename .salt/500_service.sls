{% set cfg = opts.ms_project %}
{%- set locations = salt['mc_locations.settings']() %}
# ensure at the bootstrap stage that user has permission execution on supervisor binaries
{{cfg.name}}-restricted-perms:
  file.managed:
    - name: {{cfg.project_dir}}/binaries-perms.sh
    - mode: 750
    - user: {% if not cfg.no_user%}{{cfg.user}}{% else -%}root{% endif %}
    - group: {{cfg.group}}
    - contents: |
            if [ -e "{{cfg.project_root}}" ];then
              "{{locations.resetperms}}" "${@}" \
              --dmode '0770' --fmode '0770'  \
              --paths "{{cfg.project_root}}"/bin \
              --users www-data \
              --users {% if not cfg.no_user%}{{cfg.user}}{% else -%}root{% endif %} \
              --groups {{cfg.group}} \
              --user {% if not cfg.no_user%}{{cfg.user}}{% else -%}root{% endif %} \
              --group {{cfg.group}};
            fi
  cmd.run:
    - name: {{cfg.project_dir}}/binaries-perms.sh
    - cwd: {{cfg.project_root}}
    - user: root
    - watch:
      - file: {{cfg.name}}-restricted-perms
{#- init script is marked as started at first, but the daemon is not there #}
etc-init.d-supervisor.{{cfg.name}}:
  file.symlink:
    - name: {{locations.initd_dir}}/supervisor.{{cfg.name}}
    - target: {{cfg.project_root}}/etc/init.d/supervisor.initd
{{cfg.name}}-service:
  service.running:
    - name: supervisor.{{cfg.name}}
    - enable: True
    - watch:
      - cmd: {{cfg.name}}-restricted-perms
      - file: etc-init.d-supervisor.{{cfg.name}}
  cmd.run:
    - name: {{locations.initd_dir}}/supervisor.{{cfg.name}} restart
    - onlyif: test "$({{cfg.project_root}}/bin/supervisorctl status 2>&1 |grep "refused connection"|wc -l)" != 0
    - user: root
    - watch:
      - service: {{cfg.name}}-service
