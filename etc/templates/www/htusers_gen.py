#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import (absolute_import, division,
                        print_function, unicode_literals)
__docformat__ = 'restructuredtext en'

import sys
import os

HTPASSWD = '${options.htpasswd.strip()}'
HTUSERS = [a.strip() for a in """
           ${options.credentials.strip()}
           """.split('\n')
           if a.strip() and (':' in a)]

if HTUSERS:
    with open(HTPASSWD, 'w') as fic:
        fic.write('\n')
    for line in HTUSERS:
        if ':' in line:
            parts = line.split(':')
            user = parts[0]
            password = ':'.join(parts[1:])
            if not user or not password:
                print("invalid line {0}".format(line))
                sys.exit(1)
            cmd = "htpasswd -bm \"{0}\" \"{1}\" \"{2}\"".format(
                HTPASSWD, user, password)
            ret = os.system(cmd)
            if ret != 0:
                print("invalid htpasswd return for line {0}".format(line))
                sys.exit(1)
else:
    print("No users")
    sys.exit(1)
# vim:set et sts=4 ts=4 tw=80:
