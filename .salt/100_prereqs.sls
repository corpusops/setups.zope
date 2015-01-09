{% set cfg = opts.ms_project %}
{% set data = cfg.data %}

{# workaround the l;ibjpegturbo transitional
 package hell by installing it explicitly #}
prepreq-pre-{{cfg.name}}:
  pkg.{{salt['mc_pkgs.settings']()['installmode']}}:
    - pkgs:
      - libjpeg-dev

prepreq-{{cfg.name}}:
  pkg.{{salt['mc_pkgs.settings']()['installmode']}}:
    - pkgs:
      - apache2-utils
      - liblcms2-2
      - liblcms2-dev
      - autoconf
      - automake
      - build-essential
      - bzip2
      - gettext
      - git
      - groff
      - libbz2-dev
      - libcurl4-openssl-dev
      - libdb-dev
      - libgdbm-dev
      - libreadline-dev
      - libfreetype6-dev
      - libsigc++-2.0-dev
      - libsqlite0-dev
      - libsqlite3-dev
      - libtiff5
      - libtiff5-dev
      - libwebp5
      - libwebp-dev
      - libssl-dev
      - libtool
      - libxml2-dev
      - libxslt1-dev
      - libopenjpeg-dev
      - libopenjpeg2
      - m4
      - man-db
      - pkg-config
      - poppler-utils
      - python-dev
      - python-imaging
      - python-setuptools
      - tcl8.4
      - tcl8.4-dev
      - tcl8.5
      - tcl8.5-dev
      - tk8.5-dev
      - wv
      - zlib1g-dev

var-dirs-{{cfg.name}}:
  file.directory:
    - names:
      - {{data.ui}}
      - {{data.buildout.settings.buildout['download-cache']}}
      - {{data.buildout.settings.buildout['download-directory']}}
      - {{data.buildout.settings.buildout['parts-directory']}}
      - {{data.buildout.settings.buildout['eggs-directory']}}
    - makedirs: true
    - user: {{cfg.user}}
    - group: {{cfg.group}}

var-dir-{{cfg.name}}:
  file.symlink:
    - name: {{data.zroot}}/var
    - target: {{data['var-directory'] }}
    - watch:
       - file: var-dirs-{{cfg.name}}


# unpack the generic installer eggs cache to speed up installations
{{cfg.name}}-wgetplone:
  cmd.run:
    - name: |
            set -e
            set -x
            plone_ver="$(grep dist.plone.org/release "{{cfg.project_root}}/etc/base.cfg"|head -n1|sed -re "s/.*dist.plone.org\/release\/(([0-9]+\.?){3})/\1/g")"
            plone_major="$(echo "${plone_ver}"|sed -re "s/^([0-9]+\.[0-9]+).*/\1/g")"
            wget -c "{{data.installer_url}}" -O "{{data.plone_arc}}"
            touch skip_plone_download
    - unless: test -e skip_plone_download && test -e "{{data.plone_arc}}"
    - cwd: {{data.ui}}
    - user: {{cfg.user}}
    - require:
      - file: var-dirs-{{cfg.name}}

{{cfg.name}}-unpackplone:
  cmd.run:
    - name: tar xzvf {{data.plone_arc}} && touch skip_plone_unpack
    - unless: |
              pv="$(grep dist.plone.org/release "{{data.zroot}}/etc/base.cfg"|head -n1|sed -re "s/.*dist.plone.org\/release\/(([0-9]+\.?){3})/\1/g")"
              test -e skip_plone_unpack && test -e "{{data.ui}}/Plone-${pv}-UnifiedInstaller/install.sh"
    - cwd: {{data.ui}}
    - user: {{cfg.user}}
    - require:
      - cmd: {{cfg.name}}-wgetplone

{{cfg.name}}-unpackcache:
  cmd.run:
    - name: |
            pv="$(grep dist.plone.org/release "{{cfg.project_root}}/etc/base.cfg"|head -n1|sed -re "s/.*dist.plone.org\/release\/(([0-9]+\.?){3})/\1/g")"
            tar xjf "{{data.ui}}/Plone-${pv}-UnifiedInstaller/packages/buildout-cache.tar.bz2"
    - unless: test -e {{data.buildout.settings.buildout['eggs-directory']}}/Products.CMFCore*
    - cwd: {{data.buildout.settings.buildout['cache-directory']}}/..
    - user: {{cfg.user}}
    - require:
      - cmd: {{cfg.name}}-unpackplone
