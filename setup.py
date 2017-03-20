import os
from setuptools import setup
from setuptools import find_packages

name = "test.cgwb"
version = "1.0dev"

def read(*rnames):
    return open(
        os.path.join(".", *rnames)
    ).read()

long_description = "\n\n".join(
    [read("README.rst")]
)

classifiers = [
    "Framework :: Plone",
    "Framework :: Plone :: 4.0",
    "Framework :: Plone :: 4.1",
    "Framework :: Plone :: 4.2",
    "Framework :: Plone :: 4.3",
    "Framework :: Plone :: 5.0",
    "Programming Language :: Python",
    "Topic :: Software Development"]

setup(
    name=name,
    namespace_packages=[name.split(".")[0]],
    version=version,
    description="Project {0}".format(name),
    long_description=long_description,
    classifiers=classifiers,
    keywords="",
    author="",
    author_email="",
    url="",
    license="GPL",
    packages=find_packages("src"),
    package_dir={"": "src"},
    include_package_data=True,
    install_requires=[
        "setuptools",
        "chardet",
        "z3c.autoinclude",
        "Plone",
        "plone.app.upgrade",
        "collective.dexteritytextindexer",
        "plone.app.dexterity [relations]",
        "plone.app.referenceablebehavior",
        "plone.directives.dexterity",
        "plone.directives.form",
        "plone.app.theming",
        "plone.app.themingplugins",
        "python-dateutil",
        "plone.app.caching",
    ],
    extras_require={
        "test": [
            'plone.app.testing',
            'plone.app.contenttypes',
            'plone.app.robotframework[debug]',
            "ipython"
        ]
    },
    entry_points={
        "z3c.autoinclude.plugin": ["target = plone"],
    },
)
# vim:set ft=python:
