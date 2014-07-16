{% set cfg = opts.ms_project %}
{%- set sdata = salt['mc_utils.json_dump'](cfg.data) %}
{{cfg.name}}-develop-up:
  cmd.run:
    - name: {{cfg.project_root}}/bin/develop up -f
    - cwd: {{cfg.project_root}}
    - user: {{cfg.user}}
