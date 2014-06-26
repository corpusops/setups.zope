{% set cfg = opts.ms_project %}
prepreq-{{cfg.name}}:
  pkg.{{salt['mc_pkgs.settings']()['installmode']}}:
    - pkgs:
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
      - libjpeg62-dev
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
      - {{cfg.data.buildout.settings.buildout['download-cache']}}
      - {{cfg.data.buildout.settings.buildout['download-directory']}}
      - {{cfg.data.buildout.settings.buildout['parts-directory']}}
      - {{cfg.data.buildout.settings.buildout['eggs-directory']}}
    - makedirs: true
    - user: {{cfg.user}}
    - group: {{cfg.group}}

var-dir-{{cfg.name}}:
  file.symlink:
    - name: {{cfg.project_root}}/var
    - target: {{cfg.data['var-directory'] }}
    - watch:
       - file: var-dirs-{{cfg.name}}
