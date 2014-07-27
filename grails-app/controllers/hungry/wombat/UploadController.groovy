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

import grails.converters.JSON

class UploadController {
	static final int BUFF_SIZE = 100000;
	static final byte[] buffer = new byte[BUFF_SIZE];

    def index = {
        redirect(uri: "/")
	}

	def warning = {
		render(plugin: 'uploadr', template: '/upload/warning')
	}

	def handle = {
		def contentType	= request.getHeader("Content-Type") as String
		def fileName    = URLDecoder.decode(request.getHeader('X-File-Name'), 'UTF-8') as String
		def fileSize 	= (request.getHeader('X-File-Size') != "undefined") ? request.getHeader('X-File-Size') as Long : 0L
		def name 		= URLDecoder.decode(request.getHeader('X-Uploadr-Name'), 'UTF-8') as String
		def info		= session.getAttribute('uploadr')
        def myInfo      = (name && info && info.containsKey(name)) ? info.get(name) : [:]
        def model       = (myInfo.containsKey('model')) ? myInfo.get('model') : [:] // unused, demonstration purposes only
		def savePath	= ((myInfo.containsKey('path')) ? myInfo.get('path') : "/tmp") as String
		def dir 		= new File(savePath)
		def file		= new File(savePath,fileName)
		int dot         = 0
		def namePart    = ""
		def extension   = ""
		def testName    = ""
		def testIterator= 1
		int status      = 0
		def statusText  = ""

		// set response content type to json
		response.contentType    = 'application/json'

        // update lastUsed stamp in session
        if (name && info && info.containsKey(name)) {
            session.uploadr[name].lastUsed = new Date()
            session.uploadr[name].lastAction = "upload"
        }

		// does the path exist?
		if (!dir.exists()) {
			// attempt to create the path
			try {
				dir.mkdirs()
			} catch (Exception e) {
                response.sendError(500, "could not create upload path ${savePath}")
				render([written: false, fileName: file.name] as JSON)
				return false
			}
		}

		// do we have enough space available for this upload?
		def freeSpace = dir.getUsableSpace()
		if (fileSize > freeSpace) {
			// not enough free space
            response.sendError(500, "cannot store '${fileName}' (${fileSize} bytes), only ${freeSpace} bytes of free space left on device")
			render([written: false, fileName: file.name] as JSON)
			return false
		}

		// is the file writable?
		if (!dir.canWrite()) {
			// no, try to make it writable
			if (!dir.setWritable(true)) {
                response.sendError(500, "'${savePath}' is not writable, and unable to change rights")
				render([written: false, fileName: file.name] as JSON)
				return false
			}
		}

		// make sure the file name is unique
		dot         = fileName.lastIndexOf(".")
		namePart    = (dot) ? fileName[0..dot-1] : fileName
		extension   = (dot) ? fileName[dot+1..fileName.length()-1] : ""
		while (file.exists()) {
			testName = "${namePart}-${testIterator}.${extension}"
			file = new File(savePath,testName)
			testIterator++
		}

		// define input and output streams
		InputStream inStream = null
		OutputStream outStream = null

		// handle file upload
		try {
			inStream = request.getInputStream()
			outStream = new FileOutputStream(file)

			while (true) {
				synchronized (buffer) {
					int amountRead = inStream.read(buffer);
					if (amountRead == -1) {
						break
					}
					outStream.write(buffer, 0, amountRead)
				}
			}
			outStream.flush()

			status      = 200
			statusText  = "'${file.name}' upload successful!"
		} catch (Exception e) {
			// whoops, looks like something went wrong
			status      = 500
			statusText  = e.getMessage()
		} finally {
			if (inStream != null) inStream.close()
			if (outStream != null) outStream.close()
		}

		// make sure the file was properly written
		if (status == 200 && fileSize > file.size()) {
			// whoops, looks like the transfer was aborted!
			status      = 500
			statusText  = "'${file.name}' transfer incomplete, received ${file.size()} of ${fileSize} bytes"
		}

		// got an error of some sorts?
		if (status != 200) {
			// then -try to- delete the file
			try {
				file.delete()
			} catch (Exception e) { }
		}

		// render json response
		response.setStatus(status)
		render([written: (status == 200), fileName: file.name, status: status, statusText: statusText] as JSON)
	}

	def delete = {
		def fileName 	= URLDecoder.decode(request.getHeader('X-File-Name'), 'UTF-8')
		def name 		= URLDecoder.decode(request.getHeader('X-Uploadr-Name'), 'UTF-8')
		def info		= session.getAttribute('uploadr')
		def savePath	= (name && info && info.get(name) && info.get(name).path) ? info.get(name).path : '/tmp'
		def file		= new File(savePath,fileName)

        // update lastUsed stamp in session
        if (name && info && info.containsKey(name)) {
            session.uploadr[name].lastUsed = new Date()
            session.uploadr[name].lastAction = "delete"
        }

		if (file.exists()) {
			try {
				// delete file
				file.delete()

				response.sendError(200, "OK, deleted '${fileName}'")
			} catch (Exception e) {
				response.sendError(500, "could not delete '${fileName}' (${e.getMessage()}")
			}
		} else {
			response.sendError(200, "OK, '${fileName}' did not -yet- exist")
		}
	}

	def download = {
		def fileName    = URLDecoder.decode(params.get('file'), 'UTF-8')
        def name 		= URLDecoder.decode(params.get('uploadr'), 'UTF-8')
        def info		= session.getAttribute('uploadr')
        def savePath	= (name && info && info.get(name) && info.get(name).path) ? info.get(name).path : '/tmp'
        def file        = new File(savePath, fileName)

        // path traversal protection
        if (file && file.exists() && fileName =~ /\\|\//) {
            response.sendError(400, "could not download '${fileName}': access denied")
            return false
        } else if (file && file.exists() && file.canRead()) {
            // update lastUsed stamp in session
            if (name && info && info.containsKey(name)) {
                session.uploadr[name].lastUsed = new Date()
                session.uploadr[name].lastAction = "download"
            }

            // download file
            response.setStatus(200)
			response.setContentType("application/octet-stream")
			response.setContentLength(file.size() as int)

            // browsers do not handle RFC5987 properly, so Safari will be unable to decode the unicode filename
            // @see http://greenbytes.de/tech/tc2231/
            response.setHeader("Content-Disposition", "attachment; filename=${URLEncoder.encode(fileName, 'ISO-8859-1')}; filename*= UTF-8''${URLEncoder.encode(fileName, 'UTF-8')}")

			// define input and output streams
			InputStream inStream = null
			OutputStream outStream = null

			// handle file upload
			try {
				inStream = new FileInputStream(file)
				outStream = response.getOutputStream()

				while (true) {
					synchronized (buffer) {
						int amountRead = inStream.read(buffer);
						if (amountRead == -1) {
							break
						}
						outStream.write(buffer, 0, amountRead)
					}
					outStream.flush()
				}
			} catch (Exception e) {
				// whoops, looks like something went wrong
				log.error "download failed! ${e.getMessage()}"
			} finally {
				if (inStream != null) inStream.close()
				if (outStream != null) outStream.close()
			}
        } else if (file && file.exists() && !file.canRead()) {
            // file not readable
            response.sendError(400, "could not download '${fileName}': access denied")
            return false
		} else {
            // file not found
            response.sendError(400, "could not download '${fileName}': file not found")
            return false
        }

		// return false as we do not have a view
		return false
	}
}
