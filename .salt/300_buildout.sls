{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{% import  "makina-projects/{0}/includes/python.sls".format(
      cfg.name) as py with context %}


{#- Run the project buildout but skip the maintainance parts #}
{#- Wrap the salt configured setting in a file inputable to buildout #}
{{cfg.name}}-settings:
  file.managed:
    - name: {{data.zroot}}/etc/sys/settings-local.cfg
    - contents: "#read ../../buildout-salt.cfg"
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 770

# fix https://github.com/buildout/buildout/issues/425
{{cfg.name}}-buildout-fixsetuptools:
  cmd.run:
    - name: |
          set -ex
          cd {{cfg.project_root }}
          {{data. py_root}}/bin/pip install --upgrade "setuptools=={{data.setuptools_egg_ver}}"
    - use_vt: {{data.use_vt}}

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
    - name: {{data.zroot}}
    - config: buildout-salt.cfg
    - buildout_ver: {{data.buildout.version}}
    {%- if data.get('setuptools_egg_ver', None)  %}
    - setuptools_egg_ver: {{data.setuptools_egg_ver}}
    {% endif %}
    {%- if data.get('buildout_egg_ver', None)  %}
    - buildout_egg_ver: {{data.buildout_egg_ver}}
    {% endif %}
    - python: "{{data.py}}"
    - user: {{cfg.user}}
    - newest: {{{'true': True}.get(cfg.data.buildout.settings.buildout.get('newest', 'false').lower(), False) }}
    - use_vt: {{data.use_vt}}
    - loglevel: info
    - watch:
      - file: {{cfg.name}}-settings
      - file: {{cfg.name}}-buildout-project
      - cmd: {{cfg.name}}-buildout-fixsetuptools
