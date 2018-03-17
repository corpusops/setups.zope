# -*- coding: utf-8 -*-
"""Installer for the test.cgwb package."""

from setuptools import find_packages
from setuptools import setup

setup(
    name='test.cgwb',
    version='1.0a1',
    description="App project",
    long_description="",
    # Get more from https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        "Environment :: Web Environment",
        "Framework :: Plone",
        "Framework :: Plone :: 5.1",
        "Programming Language :: Python",
        "Programming Language :: Python :: 2.7",
        "Operating System :: OS Independent",
        "License :: OSI Approved :: GNU General Public License v2 (GPLv2)",
    ],
    keywords='Python Plone',
    author='Makina Corpus',
    author_email='contact@makina-corpus.com',
    url='https://pypi.python.org/pypi/test.cgwb',
    license='GPL version 2',
    packages=find_packages('src', exclude=['ez_setup']),
    namespace_packages=['test'],
    package_dir={'': 'src'},
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        # -*- Extra requirements: -*-
        'plone.api',
        'Products.GenericSetup>=1.8.2',
        'Products.DCWorkflowGraph',
        'setuptools',
        # App requirements
        # 'collective.contact.core',
        # 'collective.instancebehavior',
        # 'collective.z3cform.datagridfield',
        # 'ecreall.helpers.upgrade',
        # 'ecreall.helpers.testing',
        'five.grok',
        'plone.restapi',
        #
        'lxml',
        'Products.CMFPlomino',
        'plomino.tinymce',
        'Products.PloneFormGen',
        'collective.quickupload',
        'webcouturier.dropdownmenu',
        'collective.flowplayer',
        'collective.prettyphoto',
        'Products.Maps',
        'quintagroup.pfg.captcha',
        'collective.fancyzoomview',
        'Products.ContentWellPortlets',
        'collective.easyslideshow',
        'collective.plonetruegallery',
        'collective.ptg.highslide',
        'collective.ptg.fancybox',
        'collective.ptg.galleriffic',
        'collective.ptg.pikachoose',
        'collective.ptg.nivoslider',
        'collective.ptg.nivogallery',
        'collective.ptg.contentflow',
        'collective.ptg.supersized',
        'collective.ptg.thumbnailzoom',
        'collective.ptg.contactsheet',
        'collective.ptg.sheetgallery',
        'wildcard.foldercontents',
        'Products.PloneKeywordManager',
        'collective.localrolesdatatables',
        'collective.easyslideshow',
        'collective.contentleadimage',
        'ftw.blog',
        'quintagroup.theme.lite',
        'collective.z3cform.norobots',
    ],
    extras_require={
        'test': [
            'plone.app.testing',
            # Plone KGS does not use this version, because it would break
            # Remove if your package shall be part of coredev.
            # plone_coredev tests as of 2016-04-01.
            # 'plone.testing>=5.0.0',
            'plone.app.contenttypes',
            'plone.app.robotframework[debug]',
        ],
    },
    entry_points="""
    [z3c.autoinclude.plugin]
    target = plone
    """,
)
