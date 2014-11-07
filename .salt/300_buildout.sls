{% set cfg = opts.ms_project %}
{%- set sdata = salt['mc_utils.json_dump'](cfg.data) %}
{#- Run the project buildout but skip the maintainance parts #}
{#- Wrap the salt configured setting in a file inputable to buildout #}
{{cfg.name}}-settings:
  file.managed:
    - template: jinja
    - name: {{cfg.project_root}}/etc/sys/settings-local.cfg
    - source: salt://makina-projects/{{cfg.name}}/files/settings.cfg
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 770


{{cfg.name}}-buildout-project:
  file.managed:
    - template: jinja
    - name: {{cfg.project_root}}/buildout-salt.cfg
    - source: salt://makina-projects/{{cfg.name}}/files/buildout.cfg
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 770
    - watch:
      - file: {{cfg.name}}-settings
    - defaults:
        project_name: '{{cfg.name}}'
  buildout.installed:
    - name: {{cfg.project_root}}
    - config: buildout-salt.cfg
    - runas: {{cfg.user}}
    - newest: {{{'true': True}.get(cfg.data.buildout.settings.buildout.get('newest', 'false').lower(), False) }}
    - use_vt: true
    - output_loglevel: info
    - watch:
      - file: {{cfg.name}}-settings
      - file: {{cfg.name}}-buildout-project
