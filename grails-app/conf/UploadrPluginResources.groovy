/**
 *  Uploadr, a multi-file uploader plugin
 *  Copyright (C) 2011 Jeroen Wesbeek
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  $Author$
 *  $Rev$
 *  $Date$
 */
modules = {
	uploadr {
		dependsOn 'jquery, modernizr, jquery-ui'

		if (grails.util.GrailsUtil.environment == "development") {
			resource id:'js', url:[plugin: 'uploadr', dir:'js', file: 'jquery.uploadr.js']
			resource id:'css', url:[plugin: 'uploadr', dir:'css', file: 'uploadr.css']
		} else {
			resource id:'js', url:[plugin: 'uploadr', dir:'js', file: 'jquery.uploadr.min.js']
			resource id:'css', url:[plugin: 'uploadr', dir:'css', file: 'uploadr.min.css']
		}

		// tip tip resources
		resource id:'js', url:[plugin: 'uploadr', dir:'js', file: 'jquery.tipTip.minified.js']
		resource id:'css', url:[plugin: 'uploadr', dir:'css', file: 'tipTip.css']
	}
}