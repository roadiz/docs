# -*- coding: utf-8 -*-
"""`roadiz_rtd_theme` lives on `Github`_.

.. _github: https://www.github.com/roadiz/roadiz_rtd_theme

"""
from setuptools import setup
from roadiz_rtd_theme import __version__


setup(
    name='roadiz_rtd_theme',
    version=__version__,
    url='https://github.com/roadiz/roadiz_rtd_theme/',
    license='MIT',
    author='Julien Blanchet, Ambroise Maupate, Dave Snider',
    author_email='julien@rezo-zero.com, ambroise@rezo-zero.com, dave.snider@gmail.com',
    description='Roadiz theme for Sphinx, 2014 version.',
    long_description=open('README.rst').read(),
    zip_safe=False,
    packages=['roadiz_rtd_theme'],
    package_data={'roadiz_rtd_theme': [
        'theme.conf',
        '*.html',
        'static/css/*.css',
        'static/js/*.js',
        'static/font/*.*',
        'static/img/*.*'
    ]},
    include_package_data=True,
    install_requires=open('requirements.txt').read().splitlines(),
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: BSD License',
        'Environment :: Console',
        'Environment :: Web Environment',
        'Intended Audience :: Developers',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Operating System :: OS Independent',
        'Topic :: Documentation',
        'Topic :: Software Development :: Documentation',
    ],
)
