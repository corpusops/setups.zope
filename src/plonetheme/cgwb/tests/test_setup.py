# -*- coding: utf-8 -*-
"""Setup tests for this package."""
from plone import api
from plone.app.testing import setRoles
from plone.app.testing import TEST_USER_ID
from plonetheme.cgwb.testing import PLONETHEME_CGWB_INTEGRATION_TESTING  # noqa

import unittest


class TestSetup(unittest.TestCase):
    """Test that plonetheme.cgwb is properly installed."""

    layer = PLONETHEME_CGWB_INTEGRATION_TESTING

    def setUp(self):
        """Custom shared utility setup for tests."""
        self.portal = self.layer['portal']
        self.installer = api.portal.get_tool('portal_quickinstaller')

    def test_product_installed(self):
        """Test if plonetheme.cgwb is installed."""
        self.assertTrue(self.installer.isProductInstalled(
            'plonetheme.cgwb'))

    def test_browserlayer(self):
        """Test that IPlonethemeCgwbLayer is registered."""
        from plonetheme.cgwb.interfaces import (
            IPlonethemeCgwbLayer)
        from plone.browserlayer import utils
        self.assertIn(IPlonethemeCgwbLayer, utils.registered_layers())


class TestUninstall(unittest.TestCase):

    layer = PLONETHEME_CGWB_INTEGRATION_TESTING

    def setUp(self):
        self.portal = self.layer['portal']
        self.installer = api.portal.get_tool('portal_quickinstaller')
        roles_before = api.user.get_roles(username=TEST_USER_ID)
        setRoles(self.portal, TEST_USER_ID, ['Manager'])
        self.installer.uninstallProducts(['plonetheme.cgwb'])
        setRoles(self.portal, TEST_USER_ID, roles_before)

    def test_product_uninstalled(self):
        """Test if plonetheme.cgwb is cleanly uninstalled."""
        self.assertFalse(self.installer.isProductInstalled(
            'plonetheme.cgwb'))

    def test_browserlayer_removed(self):
        """Test that IPlonethemeCgwbLayer is removed."""
        from plonetheme.cgwb.interfaces import \
            IPlonethemeCgwbLayer
        from plone.browserlayer import utils
        self.assertNotIn(
            IPlonethemeCgwbLayer,
            utils.registered_layers(),
        )
