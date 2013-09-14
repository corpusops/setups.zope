# in global pillar
#makina-projects.zope-salt-project.default_env: dev
#zope-salt-project-default-settings.buildout.settings.ports-overrides:
#  foo: bar
zope-salt-project-default-settings.buildout.settings:
  v:
    sys-user: foobar
    sys-group: editor
    admin-password: secret
    admin-user: admin
    reverse-proxy-scheme: http
    reverse-proxy-host: foobar.foo.com
    reverse-proxy-edit-host: edit.foobar.foo.com
  ports:
    zope-front: '${ports:balancer}'
    cache-backend: '${ports:balancer}'
  hosts:
    zope-front: '${hosts:balancer}'
    instance1: '${hosts:ip}'
    instance2: '${hosts:ip}'
    instance3: '${hosts:ip}'
    instance4: '${hosts:ip}'

