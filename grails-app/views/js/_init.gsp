$(document).ready(function() {
	var msie = (navigator.appVersion.indexOf("MSIE") != -1);
	var version = (msie) ? parseFloat(navigator.appVersion.split("MSIE")[1]) : 0;

	if (Modernizr.draganddrop && !msie) {
		// Browser supports HTML5 drag & drop
		// initialize uploadr and use native HTML5 implementation
		var ${name} = $('.${classname}[name=${name}]').uploadr({<g:if test="${handlers.onStart}">
			onStart: function(file) { ${handlers.onStart} },</g:if><g:if test="${handlers.onProgress}">
			onProgress: function(file, domObj, percentage) { ${handlers.onProgress} },</g:if><g:if test="${handlers.onSuccess}">
			onSuccess: function(file, domObj, callback) { ${handlers.onSuccess} },</g:if><g:if test="${handlers.onLike}">
			onLike: function(file, domObj, callback) { ${handlers.onLike} },</g:if><g:if test="${handlers.onUnlike}">
			onUnlike: function(file, domObj, callback) { ${handlers.onUnlike} },</g:if><g:if test="${handlers.onChangeColor}">
			onChangeColor: function(file, domObj, color) { ${handlers.onChangeColor} },</g:if>
			onFailure: function(file, domObj) {
				<g:if test="${handlers.onFailure}">${handlers.onFailure}</g:if>
			},
			onAbort: function(file, domObj) {
				<g:if test="${handlers.onAbort}">${handlers.onAbort}</g:if>
			},
			onView: function(file, domObj) { <g:if test="${handlers.onView}">${handlers.onView}</g:if><g:else>
				// open a modal dialog to view the file contents
				var width = 640;
				var height= 400;
				$( '<iframe frameborder="0" src="http://www.google.com" style="width:600px; height: 450px;" seamless />' ).dialog({
					title 		: 'viewing ${fileName}',
					position 	: 'center',
					autoOpen 	: true,
					width 		: width,
					height 		: height,
					modal 		: true,
					buttons 	: {
						close: function() { $(this).dialog('close'); }
					}
				}).width(width - 10).height(height).animate({ top: '0' });
</g:else>},
			onDelete: function(file, domObj) { <g:if test="${handlers.onDelete}">${handlers.onDelete}</g:if><g:else>
				var a = $.ajax(
					'<g:createLink plugin="uploadr" controller="upload" action="delete"/>',
					{
						async: false,
						headers: {
							'X-File-Name': file.fileName,
							'X-Uploadr-Name': this.id
						}
					}
				);

				return (a.status == 200);
</g:else>},
			onDownload: function(file, domObj) { <g:if test="${handlers.onDownload}">${handlers.onDownload}</g:if><g:else>
				// redirect to file, not that the backend should implement
				// authentication and authorization to asure the user has
				// access to this file
				window.open('<g:createLink plugin="uploadr" controller="upload" action="download"/>?uploadr=' + escape('${name}') + '&file='+escape(file.fileName));
</g:else>},<g:if test="${classname != 'uploadr'}">
			dropableClass: '${classname}-dropable',
			hoverClass: '${classname}-hover',</g:if>
			uri: '${uri}',<g:if test="${sound}">
			notificationSound: '${resource(plugin: 'uploadr', dir:'sounds', file:'notify.wav')}',
			errorSound: '${resource(plugin: 'uploadr', dir:'sounds', file:'error.wav')}',
			deleteSound: '${resource(plugin: 'uploadr', dir:'sounds', file:'delete.wav')}',</g:if>
			labelDone: '<g:message code="uploadr.label.done" />',
			labelFailed: '<g:message code="uploadr.label.failed" />',
			labelAborted: '<g:message code="uploadr.label.aborted" />',
			fileSelectText: '<g:if test="${fileselect}">${fileselect}</g:if><g:else><g:message code="uploadr.button.select" /></g:else>',
			placeholderText: '<g:if test="${placeholder}">${placeholder}</g:if><g:else><g:message code="uploadr.placeholder.text" /></g:else>',
			fileDeleteText: '<g:message code="uploadr.button.delete" />',
			fileDeleteConfirm: '<g:message code="uploadr.button.delete.confirm" />',
			fileDownloadText: '<g:message code="uploadr.button.download" />',
			fileViewText: '<g:message code="uploadr.button.view" />',
			likeText: '<g:message code="uploadr.button.like" />',
			unlikeText: '<g:message code="uploadr.button.unlike" />',
			badgeTooltipSingular: '<g:message code="uploadr.badge.tooltip.singular" />',
			badgeTooltipPlural: '<g:message code="uploadr.badge.tooltip.plural" />',
			colorPickerText: '<g:message code="uploadr.button.color.picker" />',
			maxVisible: ${maxVisible},
			rating: ${rating as String},
			voting: ${voting as String},
			colorPicker: ${colorPicker as String},
			insertDirection: '${direction}',
			id: '${name}',
			files: {<g:each var="file" in="${files}" status="s">
				${s} : {
					deletable 		: ${file.value.deletable},
					fileName 		: '${file.key.replaceAll("'","\\\\'")}',
					fileSize 		: ${file.value.size},
					fileId 			: '${file.value.id.replaceAll("'","\\\\'")}',
					fileDate 		: ${file.value.modified}<g:if test="${file.value.color}">,
					fileColor 		: '${file.value.color}'</g:if><g:if test="${file.value.rating}">,
					fileRating 		: ${file.value.rating}</g:if><g:if test="${file.value.ratingText}">,
					fileRatingText 	: '${file.value.ratingText.replaceAll("'","\\\\'")}'</g:if><g:if test="${file.value.view}">,
					fileInfo 		: [<g:each in="${file.value.info}" var="info" status="i">
						'${info}'<g:if test="${(i+1) < file.value.info.size()}">,</g:if></g:each>
					]</g:if>
				}<g:if test="${(s+1) < files.size()}">,</g:if></g:each>
			}
		});
	} else {
		// Show warning
		$('.${classname}[name=${name}]').load('${unsupported}');
	}
});
