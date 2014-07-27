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

package hungry.wombat

class UploadrTagLib {
    // set encoding
    static defaultEncodeAs = [all: 'raw']

	// define namespace
	static namespace = "uploadr"

	/**
	 * render an file uploadr element
	 * @param Map           attributes
	 * @param Closure       body
	 */
	def add = { attrs, body ->
		def uri
		def sound 			= !(attrs.containsKey('noSound') && attrs.get('noSound').toString().toBoolean())
		def name			= (attrs.containsKey('name') ? attrs.get('name') : UUID.randomUUID())
		def classname		= (attrs.containsKey('class') ? attrs.get('class') : 'uploadr')
		def direction 		= (attrs.containsKey('direction') ? attrs.get('direction') : 'down')
		def placeholder		= (attrs.containsKey('placeholder') ? attrs.get('placeholder') : '')
		def fileselect		= (attrs.containsKey('fileselect') ? attrs.get('fileselect') : '')
		def maxVisible		= (attrs.containsKey('maxVisible') ? attrs.get('maxVisible') : 0)
		def rating 			= (attrs.containsKey('rating') ? attrs.get('rating').toString().toBoolean() : false)
		def voting 			= (attrs.containsKey('voting') ? attrs.get('voting').toString().toBoolean() : false)
		def colorPicker		= (attrs.containsKey('colorPicker') ? attrs.get('colorPicker').toString().toBoolean() : false)
		def maxSize			= (attrs.containsKey('maxSize') ? attrs.get('maxSize') as Integer : 0)
		def deletable		= (attrs.containsKey('deletable') ? attrs.get('deletable').toString().toBoolean() : true)
		def viewable		= (attrs.containsKey('viewable') ? attrs.get('viewable').toString().toBoolean() : true)
		def downloadable	= (attrs.containsKey('downloadable') ? attrs.get('downloadable').toString().toBoolean() : true)
		def allowedExtensions= (attrs.containsKey('allowedExtensions') ? attrs.get('allowedExtensions').toString() : "")
        def model           = (attrs.containsKey('model') ? attrs.get('model') : [:])
		def maxConcurrentUploads= (attrs.containsKey('maxConcurrentUploads') ? attrs.get('maxConcurrentUploads').toString().toInteger() : 0)
		def maxConcurrentUploadsMethod = (attrs.containsKey('maxConcurrentUploadsMethod') ? attrs.get('maxConcurrentUploadsMethod').toString() : 'pause')

		// define uri
		if (attrs.get('controller')) {
		    // got an action attribute?
			if (attrs.get('action')) {
				// got a plugin attribute?
				if (attrs.get('plugin')) {
					uri = createLink(plugin: attrs.plugin, controller: attrs.controller, action: attrs.action)
				} else {
					uri = createLink(controller: attrs.controller, action: attrs.action)
				}
			} else {
				// got a plugin attribute?
				if (attrs.get('plugin')) {
					uri = createLink(plugin: attrs.plugin, controller: attrs.controller)
				} else {
					uri = createLink(controller: attrs.controller)
				}
			}
		} else {
			// use default controller for handeling file uploads
			uri = createLink(plugin: 'uploadr', controller: 'upload', action: 'handle')
		}

		// got a path attribute?
		if (attrs.get('path')) {
			// initialize session if necessary
			if (!session.uploadr) session.uploadr = [:]

			// and remember stuff in the session
			if (!session.uploadr[name]) {
				session.uploadr[name] = [
					uri		: uri,
					path	: attrs.path,
                    model   : model,
                    created : new Date()
				]
			} else if (session.uploadr[name].path != attrs.path) {
				// another uploadr with this name already exists in the session
                // spit out a warning
                log.error "uploadr: warning! Another uploadr with the same name (${name}) is already using another upload path (${attrs.path}). Make sure you are using unique names for your uploadr elements!"
			} else {
                // update the model in the session
                session.uploadr[name].model = model
                session.uploadr[name].lastUsed = new Date()
                session.uploadr[name].lastAction = "render"
            }
		}

		// init pageScope
		pageScope.name			= name
		pageScope.path			= session.uploadr?.get(name)?.path
		pageScope.handlers		= [:]
		pageScope.files			= []
		pageScope.temp			= [:]

		// make sure body tags are handled
		body()

		// render file upload div
		out << "<div name=\"${name}\" class=\"${classname}\"></div>"

		// and render inline initialization javascript
//        asset.script(assetScriptBlocks: g.render(
//        asset.script([:], g.render(
//		out << r.script([:], g.render(
        out << "<script>"
        out << g.render(
			plugin	: 'uploadr',
			template:'/js/init',
			model	:[
				name		        : name,
				maxSize		        : maxSize,
				uri			        : uri,
				direction 	        : direction,
				placeholder	        : placeholder,
				fileselect 	        : fileselect,
				classname	        : classname,
				maxVisible	        : maxVisible,
				sound 		        : sound,
				rating		        : rating,
				voting		        : voting,
				colorPicker	        : colorPicker,
				viewable	        : viewable,
				downloadable        : downloadable,
				deletable	        : deletable,
				handlers	        : pageScope.handlers,
				files		        : pageScope.files,
				allowedExtensions   : allowedExtensions,
				maxConcurrentUploads: maxConcurrentUploads,
				maxConcurrentUploadsMethod: maxConcurrentUploadsMethod,
				unsupported	        : (attrs.get('unsupported')) ? attrs.unsupported : createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')
			]
		)
        out << "</script>"
	}

	def demo = { attrs, body ->
		out << g.render(plugin: 'uploadr', template:'/upload/demo')
	}

	def onStart = { attrs, body ->
		pageScope.handlers.onStart = body()
	}

	def onProgress = { attrs, body ->
		pageScope.handlers.onProgress = body()
	}

	def onSuccess = { attrs, body ->
		pageScope.handlers.onSuccess = body()
	}

	def onFailure = { attrs, body ->
		pageScope.handlers.onFailure = body()
	}

	def onAbort = { attrs, body ->
		pageScope.handlers.onAbort = body()
	}

	def onDelete = { attrs, body ->
		pageScope.handlers.onDelete = body()
	}

	def onDownload = { attrs, body ->
		pageScope.handlers.onDownload = body()
	}

	def onLike = { attrs, body ->
		pageScope.handlers.onLike = body()
	}

	def onUnlike = { attrs, body ->
		pageScope.handlers.onUnlike = body()
	}

	def onChangeColor = { attrs, body ->
		pageScope.handlers.onChangeColor = body()
	}

	def onView = { attrs, body ->
		pageScope.handlers.onView = body()
	}

	def file = { attrs, body ->
		if (!attrs.get('name')) return

		// use child tags to insert file
		pageScope.temp = [
			name 		: attrs.name,
			size		: 0 as Long,
			modified 	: 0 as Long,
			deletable	: true,
			id 			: "",
			info 		: [],
			color		: '',
			rating		: 0,
			ratingText	: ''
		]

		// do we have child tags to override the regular handler?
		if (!(body().trim())) {
			// try to read file from path
			def file = new File(pageScope.path, attrs.name)

			if (file.exists()) {
				pageScope.files[ pageScope.files.size() ] = [
					name 		: attrs.name,
				    size 		: file.size(),
					modified 	: file.lastModified()
				]
			} else {
				log.error "ignoring predefined file '${file}' as it does not exist!"
			}
		} else {
			pageScope.files[ pageScope.files.size() ] = pageScope.temp
		}
	}

	def fileInfo = { attrs, body ->
		def count

		if (pageScope.temp.info) {
			count = pageScope.temp.info.size()
		} else {
			count = 0
			pageScope.temp.info = []
		}

		pageScope.temp.info[ count ] = body()
		out << "fileInfo"
	}

	def fileSize = { attrs, body ->
		pageScope.temp.size = body() as Long
		out << "fileSize"
	}

	def fileModified = { attrs, body ->
        String bodyString = body()
        pageScope.temp.modified = bodyString as Long
		out << "fileModified"
	}

	def fileId = { attrs, body ->
		pageScope.temp.id = (body() as String).trim()
		out << "fileId"
	}

	def color = { attrs, body ->
		pageScope.temp.color = (body() as String).trim()
		out << "color"
	}

	def rating = { attrs, body ->
        String bodyString = body()
        def rating = bodyString as double

		if (rating < 0) rating = 0;
		if (rating > 1) rating = 1;

		pageScope.temp.rating = rating

		out << "rating"
	}

	def ratingText = { attrs, body ->
		pageScope.temp.ratingText = body() as String

		out << "ratingText"
	}

	def deletable = { attrs, body ->
		pageScope.temp.deletable = ((body() as String).toLowerCase().trim() == "true") ? true : false

		out << "deletable"
	}
}
