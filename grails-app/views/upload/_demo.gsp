<%@ page import="org.apache.commons.lang.RandomStringUtils" %>
<%
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
def path = null;
def desktop = "${System.getProperty('user.home')}/Desktop"
%>

<% path = new File("${desktop}/myFirstUploadr") %>
<h1>1. Default uploadr</h1>
<uploadr:add name="myFirstUploadr" path="${path}"/>
<pre class="brush:html collapse:true">
&lt;uploadr:add name="myFirstUploadr" path="${path}"/>
</pre>

<% path = new File("${desktop}/mySecondUploadr") %>
<h1>2. Initial files, files added on top, paginate into 5 files per page</h1>
<uploadr:add name="mySecondUploadr" path="${path}" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<% path.listFiles().each { file -> %>
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
	</uploadr:file>
<% } %>
</uploadr:add>
<pre class="brush:html collapse:true">
	&lt;uploadr:add name="mySecondUploadr" path="${path}" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<% path.listFiles().each { file -> %>
		&lt;uploadr:file name="${file.name}">
			&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
			&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
			&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
		&lt;/uploadr:file>
<% } %>
	&lt;/uploadr:add>
</pre>

<% path = new File("${desktop}/myThirdUploadr") %>
<h1>3. Initial files, new files on top, 5 files per page, enable rating and voting</h1>
<uploadr:add name="myThirdUploadr" path="${path}" direction="up" maxVisible="5" rating="true" voting="true" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<% path.listFiles().each { file -> %>
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
		<uploadr:rating>${new Random().nextFloat()}</uploadr:rating>
	</uploadr:file>
<% } %>
</uploadr:add>
<pre class="brush:html collapse:true">
	&lt;uploadr:add name="myThirdUploadr" path="${path}" direction="up" maxVisible="5" rating="true" voting="true" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}">
<% path.listFiles().each { file -> %>
		&lt;uploadr:file name="${file.name}">
			&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
			&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
			&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
			&lt;uploadr:rating>${new Random().nextFloat()}&lt;/uploadr:rating>
		&lt;/uploadr:file>
<% } %>
	&lt;/uploadr:add>
</pre>

<% path = new File("${desktop}/myFourthUploadr") %>
<h1>4. Initial files, files are added to the bottom (default), custom event handlers, rating & voting, rating tooltips, override default file colors to <span style="color:#c78cda">#c78cda</span>, colorpicker, and disable file deletions</h1>
<h3>note that due to using a custom <i>onDelete</i> handler the uploaded files do <i>not</i> get deleted anymore!</h3>
<uploadr:add name="myFourthUploadr" path="${path}" maxVisible="5" rating="true" voting="true" colorPicker="true">
<% path.listFiles().each { file -> %>
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
		<uploadr:color>#c78cda</uploadr:color>
		<uploadr:deletable>false</uploadr:deletable>
		<uploadr:ratingText>This is the tooltip text of the rating for ${file.name}</uploadr:ratingText>
	</uploadr:file>
<% } %>
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
		$('.progress',domObj).css('background-color', '#c78cda');
		console.log('and overrided the background color to #c78cda');

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
</uploadr:add>
<pre class="brush:html collapse:true">
&lt;uploadr:add name="myFourthUploadr" path="${path}" maxVisible="5" rating="true" voting="true" colorPicker="true">
<% path.listFiles().each { file -> %>
	&lt;uploadr:file name="${file.name}">
		&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
		&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
		&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
		&lt;uploadr:color>#f594cc&lt;/uploadr:color>
		&lt;uploadr:deletable>false&lt;/uploadr:deletable>
		&lt;uploadr:ratingText>This is the tooltip text of the rating for ${file.name}&lt;/uploadr:ratingText>
	&lt;/uploadr:file>
<% } %>
	&lt;!-- upload event handlers //-->
	&lt;uploadr:onStart>
		console.log('start uploading \'' + file.fileName + '\'');
	&lt;/uploadr:onStart>
	&lt;uploadr:onProgress>
		console.log('\'' + file.fileName + '\' upload progress: ' + percentage + '%');
		return true; // return false to disable default progress handler
	&lt;/uploadr:onProgress>
	&lt;uploadr:onSuccess>
		console.log('done uploading \'' + file.fileName + '\', setting some random file id for demonstration purposes');

		var text = "";
		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		for( var i=0; i &lt; 12; i++ ) text += possible.charAt(Math.floor(Math.random() * possible.length));

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
	&lt;/uploadr:onSuccess>
	&lt;uploadr:onFailure>
		console.log('failed uploading \'' + file.fileName + '\'');
	&lt;/uploadr:onFailure>

	&lt;!-- user triggered event handlers //-->
	&lt;uploadr:onAbort>
		console.log('aborted uploading \'' + file.fileName + '\'');
	&lt;/uploadr:onAbort>
	&lt;uploadr:onView>
		console.log('you clicked view:');
		console.log(file);
		console.log(domObj);
	&lt;/uploadr:onView>
	&lt;uploadr:onDownload>
		console.log('you clicked download:');
		console.log(file);
		console.log(domObj);
	&lt;/uploadr:onDownload>
	&lt;uploadr:onDelete>
		console.log('you clicked delete:');
		console.log(file);
		console.log(domObj);

		// return true / false whether it was successful
		return true;
	&lt;/uploadr:onDelete>
	&lt;uploadr:onLike>
		console.log('you clicked like:');
		console.log(file);
		console.log(domObj);

		// callback if like action was successfull
		// and pass the new file rating
		callback(file.fileRating + 0.1);
	&lt;/uploadr:onLike>
	&lt;uploadr:onUnlike>
		console.log('you clicked unlike:');
		console.log(file);
		console.log(domObj);

		// callback if unlike action was successfull
		// and pass the new file rating
		callback(file.fileRating - 0.1);
	&lt;/uploadr:onUnlike>
	&lt;uploadr:onChangeColor>
		console.log('you changed the color to:');
		console.log(color);
		console.log(file);
		console.log(domObj);

		// you can perform an ajax call here
		// to update the color in the back-end
		// for this file
	&lt;/uploadr:onChangeColor>
&lt;/uploadr:add>
</pre>

<% path = new File("${desktop}/myFifthUploadr") %>
<h1>5. Initial files, files are added to the top, custom <a href="${resource(plugin:'uploadr', dir:'css', file:'demo.css')}" target="_new">css</a>, custom drop text, custom file browse text, paginate to 4 files per page, rating, no sound effects</h1>
<uploadr:add name="myFifthUploadr" path="${path}" direction="up" class="demo" placeholder="Behold: the drop area!" fileselect="Behold: the fileselect!" maxVisible="4" noSound="true">
<% path.listFiles().each { file -> %>
	<uploadr:file name="${file.name}">
		<uploadr:fileSize>${file.size()}</uploadr:fileSize>
		<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
		<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
	</uploadr:file>
<% } %>
</uploadr:add>
<pre class="brush:html collapse:true">
&lt;uploadr:add name="myFifthUploadr" path="${path}" direction="up" rating="true" class="demo" placeholder="Behold: the drop area!" fileselect="Behold: the fileselect!" maxVisible="4" noSound="true">
<% path.listFiles().each { file -> %>
	&lt;uploadr:file name="${file.name}">
		&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
		&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
		&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
	&lt;/uploadr:file>
<% } %>
&lt;/uploadr:add>
</pre>
