{% set cfg = opts.ms_project %}
{#-Cron from generic:
#    pack & backup & restart each day,
#    fullbackup per week (sunday)
#}
{%- set locations = salt['mc_locations.settings']() %}
{%- set cron_hour   = cfg.data.get('cron_hour', 1) %}
{%- set cron_minute = cfg.data.get('cron_minute', 0) %}
{{cfg.name}}-crons:
  file.managed:
    - name: /etc/cron.d/zope-{{cfg.name.replace('.', '_')}}
    - user: root
    - group: root
    - mode: 750
    - contents: |
                {% for nb in range(1, cfg.data.nbinstances+1) %}
                {%- set iid='instance{0}'.format(nb) %}
                {%- set id='autostart_{0}'.format(iid) %}
                {%- if cfg.data['buildout']['settings']['v'].get(id, 'false') == 'true' %}
                # daily restart
                {{cron_minute+30}} {{cron_hour}} * * * {{cfg.user}} {{ cfg.project_root}}/bin/supervisorctl restart {{iid}}
                {%- endif %}
                {%- endfor %}
                # daily incremental save
                {{ cron_minute + 15 }} {{cron_hour}} * * * {{cfg.user}} {{cfg.project_root}}/bin/backup
                #  weekly full save
                {{ cron_minute + 45 }} * * * 6 {{cfg.user}} {{cfg.project_root}}/bin/snapshotbackup

                # daily pack
                {{ cron_minute + 0 }} {{cron_hour}} * * * {{cfg.user}} {{cfg.project_root}}/bin/zeoserver-zeopack

{#- Logrotate #}
etc-logrotate.d-{{cfg.name}}.conf:
  file.copy:
    - name: {{locations.conf_dir}}/logrotate.d/{{cfg.name}}.conf
    - source: {{cfg.project_root}}/etc/logrotate.conf
    - force: true
    - user: root
    - group: root
    - mode: 640
