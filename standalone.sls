{% import "makina-states/projects/zope.jinja" as base with context %}
{% set pre = 'makinacorpus' %}
{% set name = 'zope-salt-project' %}
{% set url = 'ssh://git@github.com/{0}/salt-project.git'.format(pre, name) %}
{% set domain = 'zope.foobar.com' %}
{% macro do(full=False) %}
{{ base.install_generic_zope_project(
      name,
      url=url,
      salt_branch='zope-salt',
      project_branch='zope-project',
      domain=domain,
      domains=['otherzope.bar.com'], full=full) }}
{% endmacro %}
{{ do(full=False) }}
