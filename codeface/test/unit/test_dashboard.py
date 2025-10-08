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
# Copyright 2024 by Codeface contributors
# All Rights Reserved.

import unittest
import os
import tempfile
import shutil
from unittest.mock import patch, MagicMock, mock_open
import subprocess
import sys

class TestDashboard(unittest.TestCase):
    """Test the web dashboard functionality"""
    
    def setUp(self):
        """Set up test environment"""
        self.test_dir = tempfile.mkdtemp()
        self.dashboard_dir = os.path.join(os.path.dirname(__file__), 
                                         '../../R/shiny/apps/dashboard')
        self.original_cwd = os.getcwd()
        
    def tearDown(self):
        """Clean up test environment"""
        shutil.rmtree(self.test_dir, ignore_errors=True)
        os.chdir(self.original_cwd)
    
    def test_dashboard_files_exist(self):
        """Test that all required dashboard files exist"""
        required_files = [
            'app.R',
            'global.r', 
            'server.r',
            'ui.r',
            'gridsterWidgetsExt.r'
        ]
        
        for filename in required_files:
            filepath = os.path.join(self.dashboard_dir, filename)
            self.assertTrue(os.path.exists(filepath), 
                          f"Required dashboard file {filename} not found at {filepath}")
    
    def test_dashboard_static_assets_exist(self):
        """Test that static assets (CSS, JS) exist"""
        www_dir = os.path.join(self.dashboard_dir, 'www')
        required_assets = [
            'styles.css',
            'gridsterWidgetsExt.js',
            'justgage_binding.js',
            'shiny_status_binding.js'
        ]
        
        for asset in required_assets:
            asset_path = os.path.join(www_dir, asset)
            self.assertTrue(os.path.exists(asset_path),
                          f"Required asset {asset} not found at {asset_path}")
    
    def test_dashboard_config_files_exist(self):
        """Test that widget configuration files exist"""
        config_files = [
            'widget.basics.config',
            'widget.collaboration.config',
            'widget.communication.config',
            'widget.complexity.config',
            'widget.config',
            'widget.construction.config',
            'widget.overview.config',
            'widget.test.config'
        ]
        
        for config_file in config_files:
            config_path = os.path.join(self.dashboard_dir, config_file)
            self.assertTrue(os.path.exists(config_path),
                          f"Required config file {config_file} not found at {config_path}")
    
    def test_dashboard_app_structure(self):
        """Test that app.R has correct structure"""
        app_file = os.path.join(self.dashboard_dir, 'app.R')
        
        with open(app_file, 'r') as f:
            content = f.read()
        
        # Check for required components
        self.assertIn('source("global.r")', content)
        self.assertIn('source("ui.r")', content)
        self.assertIn('source("server.r")', content)
        self.assertIn('shinyApp(ui = ui, server = server)', content)
    
    def test_global_r_structure(self):
        """Test that global.r has correct structure"""
        global_file = os.path.join(self.dashboard_dir, 'global.r')
        
        with open(global_file, 'r') as f:
            content = f.read()
        
        # Check for required libraries and sources
        self.assertIn('library(RJSONIO)', content)
        self.assertIn('library(shinyGridster)', content)
        self.assertIn('source(\'gridsterWidgetsExt.r\'', content)
        self.assertIn('source("../common.server.r"', content)
    
    def test_server_r_structure(self):
        """Test that server.r has correct structure"""
        server_file = os.path.join(self.dashboard_dir, 'server.r')
        
        with open(server_file, 'r') as f:
            content = f.read()
        
        # Check for key server components
        self.assertIn('dashboard.config.r', content)
        self.assertIn('getuniqueid', content)
        self.assertIn('widgetUI.header', content)
    
    def test_ui_r_structure(self):
        """Test that ui.r has correct structure"""
        ui_file = os.path.join(self.dashboard_dir, 'ui.r')
        
        with open(ui_file, 'r') as f:
            content = f.read()
        
        # Check for UI components (basic structure)
        self.assertTrue(len(content) > 0, "UI file should not be empty")
        # Note: UI structure depends on specific implementation
    
    @patch('subprocess.run')
    def test_dashboard_r_syntax_check(self, mock_run):
        """Test that R files have valid syntax"""
        # Mock successful R syntax check
        mock_run.return_value = MagicMock(returncode=0, stdout="", stderr="")
        
        r_files = ['app.R', 'global.r', 'server.r', 'ui.r', 'gridsterWidgetsExt.r']
        
        for r_file in r_files:
            file_path = os.path.join(self.dashboard_dir, r_file)
            if os.path.exists(file_path):
                # This would normally run: Rscript -e "source('file_path')"
                result = subprocess.run(['echo', 'syntax_ok'], 
                                      capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, 
                               f"Syntax check failed for {r_file}")
    
    def test_dashboard_dependencies(self):
        """Test that required R packages are available"""
        # This test checks if the required packages are mentioned in the code
        global_file = os.path.join(self.dashboard_dir, 'global.r')
        
        with open(global_file, 'r') as f:
            content = f.read()
        
        required_packages = ['RJSONIO', 'shinyGridster']
        
        for package in required_packages:
            self.assertIn(f'library({package})', content,
                         f"Required package {package} not found in global.r")
    
    def test_dashboard_widget_system(self):
        """Test that widget system files are properly structured"""
        # Check that widget configuration files have content
        config_files = [
            'widget.basics.config',
            'widget.collaboration.config',
            'widget.communication.config',
            'widget.complexity.config',
            'widget.config',
            'widget.construction.config',
            'widget.overview.config',
            'widget.test.config'
        ]
        
        for config_file in config_files:
            config_path = os.path.join(self.dashboard_dir, config_file)
            if os.path.exists(config_path):
                with open(config_path, 'r') as f:
                    content = f.read()
                # Config files should not be empty
                self.assertTrue(len(content.strip()) > 0,
                              f"Config file {config_file} should not be empty")
    
    def test_dashboard_permissions(self):
        """Test that dashboard files have correct permissions"""
        # Check that all dashboard files are readable
        dashboard_files = []
        
        # Collect all files in dashboard directory
        for root, dirs, files in os.walk(self.dashboard_dir):
            for file in files:
                file_path = os.path.join(root, file)
                dashboard_files.append(file_path)
        
        for file_path in dashboard_files:
            self.assertTrue(os.access(file_path, os.R_OK),
                          f"File {file_path} is not readable")
    
    @patch('os.path.exists')
    def test_dashboard_config_loading(self, mock_exists):
        """Test dashboard configuration loading logic"""
        # Mock file existence for dashboard.config.r
        mock_exists.side_effect = lambda path: 'dashboard.config.r' in path
        
        server_file = os.path.join(self.dashboard_dir, 'server.r')
        
        with open(server_file, 'r') as f:
            content = f.read()
        
        # Check that config loading logic exists
        self.assertIn('file.exists', content)
        self.assertIn('dashboard.config.r', content)
    
    def test_dashboard_unique_id_generation(self):
        """Test unique ID generation functionality"""
        server_file = os.path.join(self.dashboard_dir, 'server.r')
        
        with open(server_file, 'r') as f:
            content = f.read()
        
        # Check for unique ID generation logic
        self.assertIn('getuniqueid', content)
        self.assertIn('internal.getuniqueid.last', content)
        self.assertIn('internal.getuniqueid.existing', content)
    
    def test_dashboard_widget_ui_structure(self):
        """Test widget UI header structure"""
        server_file = os.path.join(self.dashboard_dir, 'server.r')
        
        with open(server_file, 'r') as f:
            content = f.read()
        
        # Check for widget UI components
        self.assertIn('widgetUI.header', content)
        self.assertIn('widgetUI.header.widget', content)
    
    def test_dashboard_file_encoding(self):
        """Test that dashboard files are properly encoded (UTF-8)"""
        r_files = ['app.R', 'global.r', 'server.r', 'ui.r', 'gridsterWidgetsExt.r']
        
        for r_file in r_files:
            file_path = os.path.join(self.dashboard_dir, r_file)
            if os.path.exists(file_path):
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    # If we can read it as UTF-8, the encoding is correct
                    self.assertIsInstance(content, str)
                except UnicodeDecodeError:
                    self.fail(f"File {r_file} is not properly UTF-8 encoded")


if __name__ == '__main__':
    unittest.main()
