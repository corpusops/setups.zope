"""
Launching all doctests in the tests directory using:

    - the base layer in testing.py

"""
from test.cgwb.testing import (
    TEST_CGWB_FUNCTIONAL_TESTING
    as FUNCTIONAL_TESTING
)

import unittest2 as unittest
import glob
import os
import logging
import doctest
from plone.testing import layered

optionflags = (doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE)


def test_suite():
    """."""
    logger = logging.getLogger('test.cgwb.tests')
    cwd = os.path.dirname(__file__)
    files = []
    try:
        files = []
        for e in ['*rst', '*txt']:
            uplevel = os.path.dirname(cwd)
            for d in [cwd, uplevel]:
                files += [a for a in
                          glob.glob(os.path.join(d, e))
                          if a != os.path.join(
                              uplevel, 'version.txt')]
    except Exception:
        logger.warn('No doctests for test.cgwb')
    suite = unittest.TestSuite()
    globs = globals()
    for s in files:
        suite.addTests([
            layered(
                doctest.DocFileSuite(
                    s,
                    globs=globs,
                    module_relative=False,
                    optionflags=optionflags,
                ),
                layer=FUNCTIONAL_TESTING
            ),
        ])
    return suite

# vim:set ft=python:
