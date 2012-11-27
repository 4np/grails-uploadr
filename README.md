# About
This plugin allows dragging and dropping files on your browser window to upload them. It works out of the box, and it is also possible to add custom (javascript / ajax) event handlers and add initial files.

![example](https://dl.dropbox.com/s/yjkgq00jd7l6oca/uploadr-blank.png?dl=1)

Screenshot showing 6 files being uploaded:

![example1](https://dl.dropbox.com/s/y1hn2ix5jb3ianj/uploadr-uploading.png?dl=1)

Screenshot showing 7 files being uploaded, separated into two pages (maximum of 5 uploads visible):

![example2](https://dl.dropbox.com/s/mhc6nelsc2nnd5l/uploadr-uploadingPaginated.png?dl=1)

## Features
* upload files by
* * dragging & dropping files onto the uploadr element
* * button (optional)
* pagination (customizable number of uploads per 'page')
* sound effects (disablable)
* * file upload complete
* * transfer aborted
* * file deleted
* possibility to deny files over a certain file size (optional)
* rating (5 stars) (optional)
* voting (like / unlike) (optional)
* color picker (change background colors) (optional)
* upload progress
* * background progress
* * calculated file upload speed
* * estimated file upload duration
* adding default files (e.g. files uploaded in a previous session)
* customizable css
* internationalization through i18n
* custom JavaScript event handlers for:
* * onStart - start file upload
* * onProgress - file upload progress
* * onSuccess - file upload was successful
* * onFailure - file upload failure
* * onAbort - user aborted transfer
* * onView - user clicked 'view'
* * onDownload - user clicked 'download'
* * onDelete - user clicked 'delete'
* * onLike - user clicked 'like'
* * onUnlike - user clicked 'unlike'
* * onChangeColor - user picked a color in the color picker
* built for Grails' resources plugin
* JavaScript developed as a jQuery plugin

## Compatibility

| *browser* | *supported* |
|-----------|------------:|
| Safari | supported (as of version ?) |
| Chrome | supported (as of version ?) |
| Firefox | supported (as of version ?) |
| Internet Explorer | supported as of version [10.0.8102.0](http://ie.microsoft.com/testdrive/) |
| Opera | not supported |

This plugin heavily relies on the HTML5 Drag and Drop and File API's which Microsoft has unfortunately only implemented in Internet Explorer 10.0.8102.0 (part of the [Windows 8 developer preview](http://msdn.microsoft.com/en-us/windows/apps/br229516) distribution).

## Quickstart
The plugin incorporates a demo tag which demonstrates some examples of how to use the uploadr tag with examples and source code. You can see a live (continuous integration) demo [here](http://ci.uploadr.nmcdsp.org/):

```rhtml
<uploadr:demo/>
```
	
As the *uploadr* plugin depends on the resources plugin to pull in dependencies, your project should use the resources plugin as well (as will be the standard in Grails 2.x). If you are not familiar with the [resources plugin|http://grails.org/plugin/resources], the _demo_ tag can be used in a view as follows:*

```rhtml
<!DOCTYPE HTML>
<html>
<head>
	<r:require modules="uploadr"/>
	<r:layoutResources/>
</head>
<body>
	<uploadr:demo/>
	<r:layoutResources/>
</body>
</html>
```

## Adding an uploadr to your view
This tag will initialize the uploadr

```rhtml
<uploadr:add name="myUploadrName" path="/my/upload/path" direction="up" maxVisible="8" unsupported="/my/controller/action" rating="true" voting="true" colorPicker="true" maxSize="204800" />
```

Parameters

|*parameter* | *description* | *example* | *default* | *required*|
|------------|---------------|-----------|-----------|----------:|
|name | a unique name for your uploadr | myFirstUploadr | uploadr | yes|
|path | the upload path, this may be a temporary path | /tmp | none | yes|
|direction | manages whether new files will be added on top or on bottom (up/down) | up | down | no|
|maxVisible | determines how many files should be visible and handles pagination | 5 | 0 (=unlimited) | no|
|unsupported | shown when unsupported browser is used | /my/controller/action | default | no|
|class | override the default uploadr stylesheet with your own implementation | demo | uploadr | no|
|noSound | disable sound effects | noSound="true" | false | no|
|rating | enable / disable rating | rating="true" | false | no|
|voting | enable / disable voting | voting="true" | false | no|
|colorPicker | enable / disable colorPicker | colorPicker="true" | false | no|
|viewable | enable / disable view button | viewable="false" | true | no|
|downloadable | enable / disable download button | downloadable="false" | true | no|
|deletable | enable / disable delete button | deletable="false" | true | no|
|maxSize | max allowed size in bytes | maxSize="204800" | 0 (=unlimited) | no|
|allowedExtensions | only allow these extensions to be uploaded | allowedExtensions="gif,png,jpg,jpeg" | "" (= all) | no |
|controller | use your own controller to handle file uploads | controller="myController" | default controller/action | no|
|action | use your own action to handle file uploads | action="myAction" | default controller/action | no|
|plugin | plugin that contains your custom controller/action | plugin="myPlugin" | default plugin | no|

A screenshot of how the ```maxSize``` parameter (maxSize="204800") is handled in the front end:

![example1](https://dl.dropbox.com/s/dgwtupymrjt1ujs/uploadr-tooLarge.png?dl=1)

A screenshot of the default warning when an unsupported browser is used. This can be changed by setting the _unsupported_ parameter to load your own warning or fallback upload support (e.g. ```unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}"```):

![example1](https://dl.dropbox.com/s/qvk054yg5ic9x8j/uploadr-unsupported.jpg?dl=1)

## Adding initial files
You could just use the uploadr as an upload facility, but it can also be used to show a list of existing files you already uploaded previously and allow the user to view, download or delete the files. To add initial files you can use the ```uploadr:file``` tag as follows:

```rhtml
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
	</uploadr:file>
```

If you would like to show the list of files in a certain folder on disk, you could do that by doing something like this (also see the demo tag's second example) although it would be better to pass the file list from the controller to your view:

```rhtml
<% def path = new File("/path/to/folder") %>
<uploadr:add name="mySecondUploadr" path="${path}" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<% path.listFiles().each { file -> %>
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
	</uploadr:file>
<% } %>
</uploadr:add>
```

Of course in MVC one should not put logic in a view, and the above examples are merely here to provide some insight. Normally you
would pass -for example- a ```files``` variable to your view from your controller. So the example would be something like:

```rhtml
<uploadr:add name="mySecondUploadr" path="${path}" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<g:each in="${files}" var="file">
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
	</uploadr:file>
</g:each>
</uploadr:add>
```

_note though that these examples use RandomStringUtils which you should include:_

```rhtml
<%@ page import="org.apache.commons.lang.RandomStringUtils" %>
```

To override the color of a file you can user the color attribute:

```rhtml
        <uploadr:color>#f594cc</uploadr:color>
```

To hide the delete icon / action set the delete attribute to false. Note that if the global deletable parameter is set to false (in the uploadr tag), all delete buttons will be disabled / hidden. This attribute can be used to disable the delete button on a per-file basis: 

```rhtml
        <uploadr:deletable>false</uploadr:deletable>
```

To set a rating, use the rating attribute:

```rhtml
        <uploadr:rating>0.33</uploadr:rating>
```

To add a rating tooltip text, use the ratingText attribute:

```rhtml
        <uploadr:ratingText>This is the tooltip text of the rating for Assignment 2.pdf</uploadr:ratingText>
```

Screenshot of most of the features enabled and shown (e.g. pagination, color picker, voting, rating, tooltips, buttons):

![example1](https://dl.dropbox.com/s/37293qml4isyo94/uploadr-allFeatures.jpg?dl=1)
 

## Event handlers
By default the uploadr is fully functional as is, but it is possible to add your own event handles for certain types of events:

```rhtml
	<!-- upload event handlers //-->
	<uploadr:onStart>
		console.log('start uploading \'' + file.fileName + '\'');
	</uploadr:onStart>
	<uploadr:onProgress>
		console.log('\'' + file.fileName + '\' upload progress: ' + percentage + '%');
		return true; // return false to disable default progress handler
	</uploadr:onProgress>
	<uploadr:onSuccess>
		console.log('done uploading \'' + file.fileName + '\', setting some random file id for demonstration purposes');

		var text = "";
		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		for( var i=0; i < 12; i++ ) text += possible.charAt(Math.floor(Math.random() * possible.length));

		// set a random file id for demonstration purposes
		file.fileId = 'my-random-id::'+text;

		// set file to non-deletable (we do not get a delete icon)
		file.deletable = false;
		console.log('set file.deletable to false so the delete icon will not be shown');
 
		// override the background to purple (same as initial files)
		$('.progress',domObj).css('background-color', '#f594cc');
		console.log('and overrided the background color to #f594cc');
 
		// and set the rating tooltip text for the rating
		file.fileRatingText = 'you just uploaded this file and in the onSuccess handler the rating tooltip text is added';
 
		// callback when done
		callback();
	</uploadr:onSuccess>
	<uploadr:onFailure>
		console.log('failed uploading \'' + file.fileName + '\'');
	</uploadr:onFailure>

	<!-- user triggered event handlers //-->
	<uploadr:onAbort>
		console.log('aborted uploading \'' + file.fileName + '\'');
	</uploadr:onAbort>
	<uploadr:onView>
		console.log('you clicked view:');
		console.log(file);
		console.log(domObj);
	</uploadr:onView>
	<uploadr:onDownload>
		console.log('you clicked download:');
		console.log(file);
		console.log(domObj);
	</uploadr:onDownload>
	<uploadr:onDelete>
		console.log('you clicked delete:');
		console.log(file);
		console.log(domObj);

		// return true / false whether it was successful
		return true;
	</uploadr:onDelete>
	<uploadr:onLike>
        	console.log('you clicked like:');
        	console.log(file);
        	console.log(domObj);
 
        	// callback if like action was successfull
        	// and pass the new file rating
        	callback(file.fileRating + 0.1);
 	</uploadr:onLike>
 	<uploadr:onUnlike>
        	console.log('you clicked unlike:');
        	console.log(file);
        	console.log(domObj);
 
        	// callback if unlike action was successfull
        	// and pass the new file rating
        	callback(file.fileRating - 0.1);
 	</uploadr:onUnlike>
 	<uploadr:onChangeColor>
        	console.log('you changed the color to:');
        	console.log(color);
        	console.log(file);
        	console.log(domObj);
 
        	// you can perform an ajax call here
        	// to update the color in the back-end
        	// for this file
	</uploadr:onChangeColor>
```

## Internationalization / custom texts
The text labels the plugin uses are stored in [i18n messages](grails-uploadr/blob/master/grails-app/i18n/messages.properties), which can be overwritten / internationalized in your own application:

```properties
# labels that appears in the uploadr's percentage text when
# an upload is complete, failed or aborted
uploadr.label.done=done
uploadr.label.failed=failed
uploadr.label.aborted=aborted
uploadr.label.maxsize=too large

# label for the 'select files' button
uploadr.button.select=Click to upload files

# placeholder text
uploadr.placeholder.text=Drag and drop files here to upload...

# badge tooltip
uploadr.badge.tooltip.singular=%d file is still being uploaded...
uploadr.badge.tooltip.plural=%d files are still being uploaded...

# error messages / tooltips
uploadr.error.maxsize=The upload size of %s is larger than allowed maximum of %s

# file control tooltips
uploadr.button.delete=Click to delete this file
uploadr.button.delete.confirm=Are you sure you want to delete this file?
uploadr.button.abort=Click to abort file transfer
uploadr.button.abort.confirm=Are you sure you would like to abort this tranfer?
uploadr.button.download=Click to download this file
uploadr.button.view=Click to view this file
uploadr.button.like=Click to like
uploadr.button.unlike=Click to unlike
uploadr.button.color.picker=Click to change background color
uploadr.button.remove=Click to remove this aborted transfer from your view
```

In addition to these _default_ labels you can overwrite the _placeholder text_ (the text inside the drop area) and the the _select_ text (the text on the file upload link) on a per-uploadr basis using the following tags:

```rhtml
<uploadr:add ... placeholder="Behold: the drop area!" fileselect="Behold: the fileselect!" ...>
...
</uploadr:add>
```

## Disabling sound effects
The plugin plays some sound effects whether a file upload was completed, aborted or has failed. To disable these sound effects use the ```noSound``` parameter:

```rhtml
<uploadr:add ... noSound="true" ...>
...
</uploadr:add>
```

## Advanced usage: Creating your custom controller to handle file uploads
While the default controller works out of the box, your project's requirements might require a custom plugin. For example, if you would like to deploy your application on cloudfoundry, you need to create your own controller as you do not have file access. In order to accomplish this you can write your own controller, and specify to use it in your uploadr tag:

```rhtml
<uploadr:add ... controller="myController" action="myAction" ...>
...
</uploadr:add>
```

To have the file uploads being handled by _myAction_ action of _myController_. 

```rhtml
<uploadr:add ... controller="myController" action="myAction" plugin="myPlugin" ...>
...
</uploadr:add>
```

This would make the uploadr use the ```myAction``` of ```myController``` in ```myPlugin```. 

View the default [controller](grails-uploadr/blob/master/grails-app/controllers/hungry/wombat/UploadController.groovy)'s ```handle``` action to get an idea of how to implement your own controller to handle file uploads.

If you do this, you probably also want to create your own code to view, download and delete uploaded files. You can do this by creating your own event handlers (respectively: ```onView``` , ```onDownload``` and ```onDelete``` ). 

For example, if you store your files in a custom controller using MongoDB's GridFS, you could create your own download handler by using the ```onDownload``` event handler:

```javascript
            uploadr.onDownload {
                                // render a template (separation of concerns)
				out << g.render(template:'/js/uploadr/onDownload', model:[])
            }
```

where the view ```/js/uploadr/onDownload``` contains the following code:

```javascript
window.open('<g:createLink plugin="myPlugin" controller="uploadedFile" action="downloadUploadedFile"/>?fileId='+file.fileId);
```

and the ```uploadedFile``` controller's ```downloadUploadedFile``` action in ```myPlugin``` contains something like the following:

```groovy
    def downloadUploadedFile = {
        UploadedFile uploadedFile = UploadedFile.get(params.fileId)
        if (!uploadedFile) response.sendError(404, "No uploaded file could be found matching id: ${params.fileId}.")

        GridFSFile gridFSFile = uploadedFile.file
        if (!gridFSFile) response.sendError(404, "No file attached to UploadedFile")

		response.setStatus(200)
		response.setHeader("Content-disposition", "attachment; filename=\"${uploadedFile.fileName}\"")
		response.setContentType("application/octet-stream")
		response.setContentLength(uploadedFile.fileSize as int)

		// define input and output streams
		InputStream inStream = null
		OutputStream outStream = null

		// handle file download
		try {
			inStream = gridFSFile.inputStream
			outStream = response.getOutputStream()

			while (true) {
				synchronized (buffer) {
					int amountRead = inStream.read(buffer)
					if (amountRead == -1) {
						break
					}
					outStream.write(buffer, 0, amountRead)
				}
				outStream.flush()
			}
		} catch (Exception e) {
			// whoops, looks like something went wrong
			println "download failed! ${e.getMessage()}"
		} finally {
			if (inStream != null) inStream.close()
			if (outStream != null) outStream.close()
		}

		return false
    }
```

Take a look at the documentation above, and the default event handlers in the uploadr [initialization JavaScript](grails-uploadr/blob/master/grails-app/views/js/_init.gsp) for more information on how to create your own back-end logic to handle file upload, download, view and delete events.

## jQuery plugin
The front-end side (the gui) of the upload plugin is developed as a [jQuery](http://jquery.com/) plugin (javascript: [full](grails-uploadr/blob/master/web-app/js/jquery.uploadr.js), [minified](grails-uploadr/blob/master/web-app/js/jquery.uploadr.minified.js), css: [full](grails-uploadr/blob/master/web-app/css/uploadr.css), [minified](grails-uploadr/blob/master/web-app/css/uploadr.minified.css)) which means you can also use the front-end in _non-Grails_ projects. You will, however, have to create your own back-end logic (take the _handle_ method in the [default controller](grails-uploadr/blob/master/grails-app/controllers/hungry/wombat/UploadController.groovy) as an example) to handle the file uploads. The use of the jQuery plugin is currently undocumented, but the [initialization JavaScript](grails-uploadr/blob/master/grails-app/views/js/_init.gsp) will probably provide you with all the information you require...

## Changelog

###Version 0.6.0
Added support for an ```allowedExtensions``` parameter comma separated list (feature request [#1](grails-uploadr/issues/1)). When undefined/empty, all file uploads are allowed.

example:
```groovy
allowedExtensions="jpg,gif,png"
```

*Note that you should not add spaces to the allowed extensions parameter's value as spaces are evaluated as regular characters.
This means that _"jpg, gif, png"_ does not work and will try to validate the ```. png``` extentions (```bla. png```) instead
of the desired ```.png``` (```bla.png```).*

This new feature has also introduced two new [i18n internationalization labels](grails-uploadr/blob/master/grails-app/i18n/messages.properties), namely:

```groovy
uploadr.label.invalidFileExtension=invalid
...
uploadr.error.wrongExtension=You tried to upload a file with extension "%s" while only files with extensions "%s" \
  are allowed to be uploaded
```

![example user feedback](https://dl.dropbox.com/s/bq5cqiecgz8fa0h/uploadr-allowedExtensions.png?dl=1)

###Version 0.5.11
Upgraded to Grails 2.0.4 and Grails Central

###Version 0.5.10
Minor bugfix with casting string to double in Grails 2.0.1

###Version 0.5.9
Dependency map used >= which was wrong, changed it into >

###Version 0.5.8
Added grails 2.0 dependency configuration

###Version 0.5.7
Added three global parameters (downloadable, deletable, viewable) to define whether the file control buttons are visible (default) or not. Thanks to Michael Aube for the feedback :)

###Version 0.5.6
If the uploadr is put in a jquery-ui tab (http://jqueryui.com/demos/tabs/) there seems to be an issue with hiding elements by duration (e.g. ```$('myElement').hide(1000);```) which is ignored. This resulted in 'done' to remain visible in the percentage div when used in combination in a jquery-ui tab. To resolve this, the div is now explicitly hidden when the transition supposedly finished (e.g. ```$('myElement').hide(1000,function() { $(this).hide(); });``` )

###Version 0.5.5
FireFox drag and drop issue was fixed in 0.5.1 (see below), however the same issue apparently still existed in the 'click to upload' button

###Version 0.5.4
confirmed the File and Drag & Drop HTML5 API's to be working in Internet Explorer 10 10.0.8102.0 (part of Windows 8). Updated browser check to reflect this support, and improved the default warning message for unsupported browsers.

###Version 0.5.3
added support for ```maxSize``` argument (in bytes, so 204800 is 200KB). When a user tries to upload a file that is larger than the maximum size, the upload is not performed and a warning is shown. By default there is no limit (```maxSize=0```). Three i18n texts were added (```uploadr.error.maxsize```, ```uploadr.label.maxsize``` & ```uploadr.button.remove```). Added some tweaks that rating and voting does not show when an upload was not successful, and that a delete button will show to remove the failed / aborted transfer from view. Added ```maxSize``` limitation of 200KB to Example 3 in the ```<uploadr:demo/>``` tag.

###Version 0.5.2
Fixed an issue where some file tags did not always work properly (color, rating, ratingText and deletable)

###Version 0.5.1
Implemented support for the changed Firefox 7 File API. While in the previous versions (and in webkit based browsers) the file information was stored in ```file.fileSize``` , ```file.fileName``` and ```file.contentType``` , Firefox 7's File API now uses ```file.name``` , ```file.size``` and ```file.type``` instead. Implemented a fix to support this new behavior.
