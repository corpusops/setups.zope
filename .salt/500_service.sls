{% set cfg = opts.ms_project %}
{%- set locations = salt['mc_locations.settings']() %}
{#- init script is marked as started at first, but the daemon is not there #}
etc-init.d-supervisor.{{cfg.name}}:
  {# systemd needs a file and not a symlink #}
  file.copy:
    - source: {{cfg.project_root}}/etc/init.d/supervisor.initd
    - name: {{locations.initd_dir}}/supervisor.{{cfg.name}}
    - force: true
  cmd.run:
    - onlyif: hash -r systemctl && systemctl status|grep -q State
    - name: systemctl daemon-reload && echo changed=false
    - stateful: true
{{cfg.name}}-service:
  service.running:
    - name: supervisor.{{cfg.name}}
    - enable: True
    - watch:
      - file: etc-init.d-supervisor.{{cfg.name}}
  cmd.run:
    - name: {{locations.initd_dir}}/supervisor.{{cfg.name}} restart
    - onlyif: test "$({{cfg.project_root}}/bin/supervisorctl status 2>&1 |grep "refused connection"|wc -l)" != 0
    - user: root
    - watch:
      - service: {{cfg.name}}-service
{{cfg.name}}-reboot:
  file.managed:
    - name: {{cfg.data_root}}/restart.sh
    - user: root
    - group: root
    - mode: 755
    - contents: |
                {% for nb in range(1, cfg.data.nbinstances+1) %}
                {%- set iid='instance{0}'.format(nb) %}
                {%- set id='autostart_{0}'.format(iid) %}
                {%- if cfg.data['buildout']['settings']['v'].get(id, 'false') == 'true' %}
                {{ cfg.project_root}}/bin/supervisorctl restart {{iid}}
                {%- endif %}
                {%- endfor %}
  cmd.run:
    - name: {{cfg.data_root}}/restart.sh
    - user: root
    - watch:
      - cmd: {{cfg.name}}-service

