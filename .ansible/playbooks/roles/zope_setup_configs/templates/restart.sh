#!/usr/bin/env bash
# {{ ansible_managed }}
# {% set d = cops_zope_vars %}
# {% set v = d['buildout']['settings']['v'] %}
set -x
ret=0
RESTART_MODE=${RESTART_MODE:-restart}
CONTROLLER=${CONTROLLER:-"{{ d.zroot}}/bin/supervisorctl"}
# {%- for nb in range(d.nbinstances) %}
# {%- set iid = 'instance{0}'.format(loop.index) %}
# {%- set id = 'autostart_{0}'.format(iid) %}
# {%- set comment = (v.get(id, 'false').lower() != 'true') and '# ' or '' %}
{{ comment }}$CONTROLLER $RESTART_MODE {{iid}}
{{ comment }}cret=$?
{{ comment }}if [ "x$cret" != "x0" ];then
{{ comment }}    ret=$cret
{{ comment }}fi
# {%- endfor %}
exit $ret
