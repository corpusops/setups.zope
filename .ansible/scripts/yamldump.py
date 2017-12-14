#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
import yaml
import StringIO
import os
import json
TEST_FILE = os.environ.get('YAML_TEST_FILE', '.gitlab-ci.yml')
data = yaml.load(open(TEST_FILE).read())
edata = json.loads(json.dumps(data))
out = StringIO.StringIO()
yaml.safe_dump(edata,
               out,
               allow_unicode=True,
               default_flow_style=False)
print(out.getvalue())
# vim:set et sts=4 ts=4 tw=80:
