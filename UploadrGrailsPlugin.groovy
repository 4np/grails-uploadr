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
 */
class UploadrGrailsPlugin {
	def version         = "1.0.0"
	def grailsVersion   = "2.4 > *"
    def loadBefore      = ['jquery', 'asset-pipeline']
	def pluginExcludes  = [
			"grails-app/views/error.gsp"
	]
	def author          = "Jeroen Wesbeek"
	def authorEmail     = "work@osx.eu"
	def title           = "A HTML5 drag and drop multi-file upload plugin"
	def description     = "A HTML5 drag and drop multi-file upload plugin"
	def documentation   = "https://github.com/4np/grails-uploadr/blob/master/README.md"
	def license         = "APACHE"
	def issueManagement = [system: "github", url: "https://github.com/4np/grails-uploadr/issues"]
	def scm             = [url: "https://github.com/4np/grails-uploadr"]

	// Extra (optional) plugin metadata

    // Details of company behind the plugin (if there is one)
    // def organization = [ name: "My Company", url: "http://www.my-company.com/" ]

    // Any additional developers beyond the author specified above.
    // def developers = [ [ name: "Joe Bloggs", email: "joe@bloggs.net" ]]

    def doWithWebDescriptor = { xml ->
        // TODO Implement additions to web.xml (optional), this event occurs before
    }

    def doWithSpring = {
        // TODO Implement runtime spring config (optional)
    }

    def doWithDynamicMethods = { ctx ->
        // TODO Implement registering dynamic methods to classes (optional)
    }

    def doWithApplicationContext = { applicationContext ->
        // TODO Implement post initialization spring config (optional)
    }

    def onChange = { event ->
        // TODO Implement code that is executed when any artefact that this plugin is
        // watching is modified and reloaded. The event contains: event.source,
        // event.application, event.manager, event.ctx, and event.plugin.
    }

    def onConfigChange = { event ->
        // TODO Implement code that is executed when the project configuration changes.
        // The event is the same as for 'onChange'.
    }

    def onShutdown = { event ->
        // TODO Implement code that is executed when the application shuts down (optional)
    }
}