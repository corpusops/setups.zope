{% import "makina-states/services/http/nginx/init.sls" as nginx %}
{% set cfg = opts.ms_project %}
{% set data = cfg.data %}

include:
  - makina-states.services.http.nginx


{% if data.get('front_domain', None) %}
{{ nginx.virtualhost(domain=data.front_domain,
                     doc_root=data.front_doc_root,
                     server_aliases=data.front_server_aliases,
                     vhost_basename='corpus-front-'+cfg.name,
                     ssl_common_name=data.ssl_common_name,
                     loglevel=data.nginx_front_loglevel,
                     vh_top_source=data.nginx_front_top,
                     vh_content_source=data.nginx_front_vhost,
                     project=cfg.name)}}
{% endif %}
{{ nginx.virtualhost(domain=data.domain,
                     doc_root=data.doc_root,
                     server_aliases=data.server_aliases,
                     vhost_basename='corpus-'+cfg.name,
                     ssl_common_name=data.ssl_common_name,
                     loglevel=data.nginx_loglevel,
                     vh_top_source=data.nginx_top,
                     vh_content_source=data.nginx_vhost,
                     project=cfg.name)}}

{% if data.get('http_users', {}) %}
{% for userrow in data.http_users %}
{% for user, passwd in userrow.items() %}
{{cfg.name}}-{{user}}-htaccess:
  webutil.user_exists:
    - name: {{user}}
    - password: {{passwd}}
    - htpasswd_file: {{data.htaccess}}
    - options: m
    - force: true
{% endfor %}
{% endfor %}
{% endif %}

{{cfg.name}}-admin-zmihtaccess:
  webutil.user_exists:
    - name: "{{data.buildout.settings.v['admin-user']}}"
    - password: "{{data.buildout.settings.v['admin-password']}}"
    - htpasswd_file: {{data.htaccess}}
    - options: m
    - force: true

{{cfg.name}}-htaccess:
  file.managed:
    - names: [{{data.htaccess}}]
    - source: ''
    - user: www-data
    - group: www-data
    - mode: 770
    - watch:
      - mc_proxy: nginx-post-conf-hook
