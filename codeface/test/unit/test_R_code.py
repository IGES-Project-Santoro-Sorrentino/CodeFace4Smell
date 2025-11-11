# This file is part of Codeface. Codeface is free software: you can
# redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Copyright 2013 by Siemens AG, Johannes Ebke <johannes.ebke.ext@siemens.com>
# All Rights Reserved.

import unittest
import os
from pkg_resources import resource_filename
from codeface.util import execute_command

class TestRCode(unittest.TestCase):
    '''Execute R tests as part of the test suite'''
    def testThat_cluster_dir(self):
        '''Test R code in cluster directory'''
        path = resource_filename("codeface", "R")
        cmd = ["Rscript", "do_test.r"]
        
        # Skip if not in a proper environment (e.g., not in container)
        # R tests require database and other dependencies
        try:
            # Use direct_io=False to capture output for better error messages
            result = execute_command(cmd, direct_io=False, cwd=path)
        except Exception as e:
            # Check if this is a critical error or just missing dependencies
            error_msg = str(e).lower()
            if "cannot open the connection" in error_msg or "database" in error_msg:
                self.skipTest("R tests require database connection - skipping (run inside container)")
            elif "package" in error_msg and ("not found" in error_msg or "there is no package called" in error_msg):
                self.skipTest("R tests require additional packages - skipping")
            elif "error exiting because of test failures" in error_msg:
                # This is an actual test failure in R code, not a missing dependency
                # Extract more info from the error message
                self.fail(f"R tests failed: {error_msg}")
            else:
                # Re-raise if it's a different error
                raise
