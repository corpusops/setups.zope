# -*- coding: utf-8 -*-
"""Installer for the plonetheme.cgwb package."""

from setuptools import find_packages
from setuptools import setup

setup(
    name='plonetheme.cgwb',
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
    url='https://pypi.python.org/pypi/plonetheme.cgwb',
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
        'z3c.jbot',
        'plone.app.theming',
        'plone.app.themingplugins',
        # App requirements
        # 'collective.contact.core',
        # 'collective.instancebehavior',
        # 'collective.z3cform.datagridfield',
        # 'ecreall.helpers.upgrade',
        # 'ecreall.helpers.testing',
        'five.grok',
        'plone.restapi',
        #
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
