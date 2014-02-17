"""
Checking specifics portal settings.
"""

import unittest2 as unittest

from test.cgwb.tests import (
    base
)
from test.cgwb.testing import (
    Browser,
)


class TestSetup(base.IntegrationTestCase):
    """Check Policy."""

    def test_Noop(self):
        self.assertEquals(True, True)


class TestFunctionnalSetup(base.FunctionalTestCase):
    """Check Policy."""

    def test_FNoop(self):
        self.assertTrue(
            'Plone'
            in Browser.new(self.portal.absolute_url()).contents
        )
        self.assertTrue(
            'Plone'
            in Browser.new('/plone').contents
        )


def test_suite():
    """."""
    suite = unittest.TestSuite()
    suite.addTests(
        unittest.defaultTestLoader.loadTestsFromName(
            __name__))
    return suite
