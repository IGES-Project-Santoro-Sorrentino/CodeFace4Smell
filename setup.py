#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(name='codeface',
      version='0.2.0',
      description='Codeface: Socio-Technical Analysis of Software Development',
      author='Wolfgang Mauerer',
      author_email='wolfgang.mauerer@oth-regensburg.de',
      url='https://github.com/siemens/codeface',
      packages=find_packages(exclude=['experiments']),
      package_data={'codeface': ['R/*.r', 'R/cluster/*.r', 'perl/*.pl']},
      entry_points={'console_scripts': ['codeface = codeface.cli:main']},
      install_requires=[
                        # 'wheel',
                        'progressbar2', 
                        # 'pygments', 
                        #'VCS',
                        # 'importlib_metadata',
                        'mysqlclient',
                        'python-ctags3',
                        'PyYAML == 5.4.1',
                        'PyMySQL == 1.0.2'
      ],
      python_requires='>=3.6',
)