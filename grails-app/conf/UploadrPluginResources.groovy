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
 *  $Author: work@osx.eu $
 *  $Rev: 628 $
 *  $Date: 2011-08-11 14:04:06 +0200 (Thu, 11 Aug 2011) $
 */
modules = {
	uploadr {
		dependsOn 'jquery, modernizr, jquery-ui'

		resource id:'js', url:[plugin: 'uploadr', dir:'js', file: 'uploadr.js']
		resource id:'css', url:[plugin: 'uploadr', dir:'css', file: 'uploadr.css']
		resource id:'js', url:[plugin: 'uploadr', dir:'js', file: 'jquery.tipTip.minified.js']
		resource id:'css', url:[plugin: 'uploadr', dir:'css', file: 'tipTip.css']
	}
}