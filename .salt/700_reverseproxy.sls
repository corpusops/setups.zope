{% set cfg = opts.ms_project %}
{% set data = cfg.data %}
{%- set apacheSettings = salt['mc_apache.settings']() %}
include:
{% if data.nginx %}
  - makina-states.services.http.nginx
{% else %}
  - makina-states.services.http.nginx.hooks
{% endif %}
{% if data.apache %}
  - makina-states.services.http.apache_modproxy
{% else %}
  - makina-states.services.http.apache.hooks
{% endif %}

{%if data.apache and data.nginx %}
ERROR -- PLEASE CHOOSE BETWEEN NGINX & APACHE
{% endif %}

{# VHOST #}
{{cfg.name}}-buildout-vhost-directory:
  file.directory:
    - name: {{cfg.project_root}}/etc/www
    - user: {{cfg.user}}
    - group: {{cfg.user}}
    - makedirs: true
    - dir_mode: 755
  cmd.run:
    - name: >
            ln -s {{cfg.project_root}}/www/apache.reverseproxy.conf {{cfg.project_root}}/etc/www/apache.reverseproxy.conf
            && ln -s {{cfg.project_root}}/www/nginx.reverseproxy.conf {{cfg.project_root}}/etc/www/nginx.reverseproxy.conf
    - user: {{cfg.user}}
    - unless: ls {{cfg.project_root}}/etc/www/apache.reverseproxy.conf {{cfg.project_root}}/etc/www/nginx.reverseproxy.conf
    - onlyif: ls {{cfg.project_root}}/www/apache.reverseproxy.conf {{cfg.project_root}}/www/nginx.reverseproxy.conf
    - watch:
      - file: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: nginx-post-conf-hook

{% if data.apache %}

{{cfg.name}}-buildout-apache-vhost:
  file.symlink:
    - target: {{cfg.project_root}}/etc/www/apache.reverseproxy.conf
    - name: {{apacheSettings.vhostdir}}/100-{{cfg.data.domain}}.conf
    - makedirs: true
    - watch:
      - file: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: makina-apache-vhostconf

{{cfg.name}}-buildout-vhost-active:
  file.symlink:
    - target: {{apacheSettings.vhostdir}}/100-{{cfg.data.domain}}.conf
    - name: {{apacheSettings.evhostdir}}/100-{{cfg.data.domain}}.conf
    - makedirs: true
    - watch:
      - file: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: makina-apache-vhostconf
{%else %}
{{cfg.name}}-buildout-apache-vhost:
  file.absent:
    - name: {{apacheSettings.vhostdir}}/100-{{cfg.data.domain}}.conf
    - watch:
      - cmd: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: makina-apache-vhostconf

{{cfg.name}}-buildout-vhost-active:
  file.absent:
    - name: {{apacheSettings.evhostdir}}/100-{{cfg.data.domain}}.conf
    - watch:
      - cmd: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: makina-apache-vhostconf
 

{% endif %}
{% if data.nginx %}
{{cfg.name}}-buildout-nginx-vhost:
  file.symlink:
    - target: {{cfg.project_root}}/etc/www/nginx.reverseproxy.conf
    - name: /etc/nginx/sites-available/100-{{cfg.data.domain}}.conf
    - makedirs: true
    - watch:
      - file: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: nginx-post-conf-hook

{{cfg.name}}-buildout-nginx-vhost-active:
  file.symlink:
    - target: /etc/nginx/sites-available/100-{{cfg.data.domain}}.conf
    - name: /etc/nginx/sites-enabled/100-{{cfg.data.domain}}.conf
    - makedirs: true
    - watch:
      - file: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: nginx-post-conf-hook
{%else %}

{{cfg.name}}-buildout-nginx-vhost:
  file.absent:
    - name: /etc/nginx/sites-available/100-{{cfg.data.domain}}.conf
    - watch:
      - cmd: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: nginx-post-conf-hook

{{cfg.name}}-buildout-nginx-vhost-active:
  file.absent:
    - name: /etc/nginx/sites-enabled/100-{{cfg.data.domain}}.conf
    - watch:
      - cmd: {{cfg.name}}-buildout-vhost-directory
    - watch_in:
      - mc_proxy: nginx-post-conf-hook
{% endif %}
