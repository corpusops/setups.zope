{% set cfg = opts.ms_project %}
{%- set locations = salt['mc_locations.settings']() %}
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
      - file: etc-init.d-supervisor.{{cfg.name}}
  cmd.run:
    - name: {{locations.initd_dir}}/supervisor.{{cfg.name}} restart
    - onlyif: test "$({{cfg.project_root}}/bin/supervisorctl status 2>&1 |grep "refused connection"|wc -l)" != 0
    - user: root
    - watch:
      - service: {{cfg.name}}-service
