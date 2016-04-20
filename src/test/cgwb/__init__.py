import logging
from zope.i18nmessageid import MessageFactory

MessageFactory = testcgwbMessageFactory = MessageFactory('test.cgwb')
logger = logging.getLogger('test.cgwb')
EXTENSION_PROFILES = ('test.cgwb:default',)
SKIN = 'test.skin'
PRODUCT_DEPENDENCIES = (
)


def initialize(context):
    """Initializer called when used as a Zope 2 product."""


GLOBALS = globals()
