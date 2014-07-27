<%@page expressionCodec="raw" %>
$(document).ready(function() {
    $('.${classname}[name=${name}]').uploadr({<g:if test="${handlers.onStart}">
        onStart: function(file) { ${handlers.onStart} },</g:if><g:if test="${handlers.onProgress}">
        onProgress: function(file, domObj, percentage) { ${handlers.onProgress} },</g:if><g:if test="${handlers.onSuccess}">
        onSuccess: function(file, domObj, callback, response) { ${handlers.onSuccess} },</g:if><g:if test="${handlers.onLike}">
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
            console.log('You clicked the \'view\' action for the following uploaded file:');
            console.log(file);
            console.log('in the following DOM element:');
            console.log(domObj);
            console.log('Implement a \'onView\' event handler to actually do something in the UI.');
            console.log('see: https://github.com/4np/grails-uploadr#event-handlers');
</g:else>},
        onDelete: function(file, domObj) { <g:if test="${handlers.onDelete}">${handlers.onDelete}</g:if><g:else>
            var a = $.ajax(
                '<g:createLink plugin="uploadr" controller="upload" action="delete"/>',
                {
                    async: false,
                    headers: {
                        'X-File-Name': encodeURIComponent(file.fileName),
                        'X-Uploadr-Name': encodeURIComponent(this.id)
                    }
                }
            );

            return (a.status == 200);
</g:else>},
        onDownload: function(file, domObj) { <g:if test="${handlers.onDownload}">${handlers.onDownload}</g:if><g:else>
            // redirect to file, note that the backend should implement
            // authentication and authorization to asure the user has
            // access to this file
            window.open('<g:createLink plugin="uploadr" controller="upload" action="download"/>?uploadr=' + encodeURIComponent('${name}') + '&file='+encodeURIComponent(file.fileName));
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
        fileAbortText: '<g:message code="uploadr.button.abort" />',
        fileAbortConfirm: '<g:message code="uploadr.button.abort.confirm" />',
        fileDownloadText: '<g:message code="uploadr.button.download" />',
        fileViewText: '<g:message code="uploadr.button.view" />',
        fileTooLargeText: '<g:message code="uploadr.error.maxsize" />',
        labelFileTooLarge: '<g:message code="uploadr.label.maxsize" />',
        labelPaused: '<g:message code="uploadr.label.paused" />',
        maxConcurrentUploadsExceededSingular: '<g:message code="uploadr.error.maxConcurrentUploadsExceededSingular" />',
        maxConcurrentUploadsExceededPlural: '<g:message code="uploadr.error.maxConcurrentUploadsExceededPlural" />',
        fileExtensionNotAllowedText: '<g:message code="uploadr.error.wrongExtension" />',
        labelInvalidFileExtension: '<g:message code="uploadr.label.invalidFileExtension" />',
        likeText: '<g:message code="uploadr.button.like" />',
        removeFromViewText: '<g:message code="uploadr.button.remove"/>',
        unlikeText: '<g:message code="uploadr.button.unlike" />',
        badgeTooltipSingular: '<g:message code="uploadr.badge.tooltip.singular" />',
        badgeTooltipPlural: '<g:message code="uploadr.badge.tooltip.plural" />',
        colorPickerText: '<g:message code="uploadr.button.color.picker" />',
        maxVisible: ${maxVisible},
        maxConcurrentUploads: ${maxConcurrentUploads},
        maxConcurrentUploadsMethod: '${maxConcurrentUploadsMethod}',
        rating: ${rating as String},
        voting: ${voting as String},
        colorPicker: ${colorPicker as String},
        deletable: ${deletable as String},
        viewable: ${viewable as String},
        downloadable: ${downloadable as String},
        allowedExtensions: '${allowedExtensions as String}',
        insertDirection: '${direction}',
        id: '${name}',
        files: {<g:each var="file" in="${files}" status="s">
            ${s} : {
                deletable 		: ${file.deletable},
                fileName 		: '${file.name.replaceAll("'","\\\\'")}',
                fileSize 		: ${file.size},
                fileId 			: '${file.id.replaceAll("'","\\\\'")}',
                fileDate 		: ${file.modified}<g:if test="${file.color}">,
                fileColor 		: '${file.color}'</g:if><g:if test="${file.rating}">,
                fileRating 		: ${file.rating}</g:if><g:if test="${file.ratingText}">,
                fileRatingText 	: '${file.ratingText.replaceAll("'","\\\\'")}'</g:if><g:if test="${file.view}">,
                fileInfo 		: [<g:each in="${file.info}" var="info" status="i">
                    '${info}'<g:if test="${(i+1) < file.info.size()}">,</g:if></g:each>
                ]</g:if>
            }<g:if test="${(s+1) < files.size()}">,</g:if></g:each>
        },
        maxSize: ${maxSize}
    });
});