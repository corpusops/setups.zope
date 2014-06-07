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
    - defaults:
      salt_data: |
                 {{sdata}}

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
      skippedparts: |
                    '    ${v:maintainance-parts}'
                    '    chmod'
                    '    chown'
      salt_data: |
                 {{sdata}}
      config: buildout-{{cfg.default_env}}.cfg
  buildout.installed:
    - name: {{cfg.project_root}}
    - config: buildout-salt.cfg
    - runas: {{cfg.user}}
    - newest: {{cfg.data.buildout.newest}}
    - watch:
      - file: {{cfg.name}}-settings
      - file: {{cfg.name}}-buildout-project
