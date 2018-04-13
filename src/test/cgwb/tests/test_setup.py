# -*- coding: utf-8 -*-
"""Setup tests for this package."""
from plone import api
from plone.app.testing import setRoles
from plone.app.testing import TEST_USER_ID
from test.cgwb.testing import TEST_CGWB_INTEGRATION_TESTING  # noqa

import unittest


class TestSetup(unittest.TestCase):
    """Test that test.cgwb is properly installed."""

    layer = TEST_CGWB_INTEGRATION_TESTING

    def setUp(self):
        """Custom shared utility setup for tests."""
        self.portal = self.layer['portal']
        self.installer = api.portal.get_tool('portal_quickinstaller')

    def test_product_installed(self):
        """Test if test.cgwb is installed."""
        self.assertTrue(self.installer.isProductInstalled(
            'test.cgwb'))

    def test_browserlayer(self):
        """Test that ITestCgwbLayer is registered."""
        from test.cgwb.interfaces import (
            ITestCgwbLayer)
        from plone.browserlayer import utils
        self.assertIn(ITestCgwbLayer, utils.registered_layers())


class TestUninstall(unittest.TestCase):

    layer = TEST_CGWB_INTEGRATION_TESTING

    def setUp(self):
        self.portal = self.layer['portal']
        self.installer = api.portal.get_tool('portal_quickinstaller')
        roles_before = api.user.get_roles(username=TEST_USER_ID)
        setRoles(self.portal, TEST_USER_ID, ['Manager'])
        self.installer.uninstallProducts(['test.cgwb'])
        setRoles(self.portal, TEST_USER_ID, roles_before)

    def test_product_uninstalled(self):
        """Test if test.cgwb is cleanly uninstalled."""
        self.assertFalse(self.installer.isProductInstalled(
            'test.cgwb'))

    def test_browserlayer_removed(self):
        """Test that ITestCgwbLayer is removed."""
        from test.cgwb.interfaces import \
            ITestCgwbLayer
        from plone.browserlayer import utils
        self.assertNotIn(
            ITestCgwbLayer,
            utils.registered_layers(),
        )
