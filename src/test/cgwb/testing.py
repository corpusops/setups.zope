# -*- coding: utf-8 -*-
from plone.app.contenttypes.testing import PLONE_APP_CONTENTTYPES_FIXTURE
from plone.app.robotframework.testing import REMOTE_LIBRARY_BUNDLE_FIXTURE
from plone.app.testing import applyProfile
from plone.app.testing import FunctionalTesting
from plone.app.testing import IntegrationTesting
from plone.app.testing import PloneSandboxLayer
from plone.testing import z2

import test.cgwb


class TestCgwbLayer(PloneSandboxLayer):

    defaultBases = (PLONE_APP_CONTENTTYPES_FIXTURE,)

    def setUpZope(self, app, configurationContext):
        # Load any other ZCML that is required for your tests.
        # The z3c.autoinclude feature is disabled in the Plone fixture base
        # layer.
        self.loadZCML(package=test.cgwb)

    def setUpPloneSite(self, portal):
        applyProfile(portal, 'test.cgwb:default')


TEST_CGWB_FIXTURE = TestCgwbLayer()


TEST_CGWB_INTEGRATION_TESTING = IntegrationTesting(
    bases=(TEST_CGWB_FIXTURE,),
    name='TestCgwbLayer:IntegrationTesting'
)


TEST_CGWB_FUNCTIONAL_TESTING = FunctionalTesting(
    bases=(TEST_CGWB_FIXTURE,),
    name='TestCgwbLayer:FunctionalTesting'
)


TEST_CGWB_ACCEPTANCE_TESTING = FunctionalTesting(
    bases=(
        TEST_CGWB_FIXTURE,
        REMOTE_LIBRARY_BUNDLE_FIXTURE,
        z2.ZSERVER_FIXTURE
    ),
    name='TestCgwbLayer:AcceptanceTesting'
)
