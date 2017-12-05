{% set build_py = data.get('build_py', True) or data.py_ver < 2.5 %}
{% set _ = data.update(
    {'_python': (data.get('orig_py', None)
                 or '/usr/bin/python{0}'.format(data.py_ver))})  %}
{% set _ = data.update({'_venv_bin': data.get('venv_bin', None)}) %}
{% if build_py %}
{% set _ = data.update({'_python': "{0}/bin/python".format(data.py_inst)}) %}
{% set _ = data.update({'_venv_bin': "{0}/bin/virtualenv".format(data.py_inst)}) %}
{% endif %}
{% set _ = data.update({'_build_py': build_py}) %}
