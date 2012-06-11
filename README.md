# About
This plugin allows dragging and dropping files on your browser window to upload them. It works out of the box, and it is also possible to add custom (javascript / ajax) event handlers and add initial files.

Screenshot showing 12 files being uploaded, separated into two pages (maximum of 8 uploads visible).

![example1](http://grails.org/wikiImage/plugin-uploadr-screenshots/uploadr-uploading.png)

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
The plugin incorporates a demo tag which demonstrates some examples of how to use the uploadr tag with examples and source code. You can see a live (continuous integration) demo [here|http://ci.uploadr.nmcdsp.org/]:

```html
<uploadr:demo/>
```
	
*As the *uploadr* plugin depends on the resources plugin to pull in dependencies, your project should use the resources plugin as well (as will be the standard in Grails 2.x). If you are not familiar with the [resources plugin|http://grails.org/plugin/resources], the _demo_ tag can be used in a view as follows:*

```html
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

