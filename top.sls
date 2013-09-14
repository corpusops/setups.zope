{% import "makina-projects/zope-salt-project/standalone.sls" as base with context %}
{% set name = base.name %}
{% set url = base.url %}
{% set domain = base.domain %}
{{ base.do(full=True) }}
