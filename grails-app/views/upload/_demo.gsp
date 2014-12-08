<%@page import="org.apache.commons.lang.RandomStringUtils" %>
<%@page expressionCodec="raw" %>
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
 */

// Note that normally you should pass these variables to your view from your
// controller, as in MVC your controller should never contain business logic
// and just provide the view to your data. But for clarity sake I am breaking
// this rule and defining them in here...

def downloads = grailsApplication.config.uploadr.defaultUploadPath
def path1 = new File("${downloads}/myFirstUploadr")
def path2 = new File("${downloads}/mySecondUploadr")
def path3 = new File("${downloads}/myThirdUploadr")
def path4 = new File("${downloads}/myFourthUploadr")
def path5 = new File("${downloads}/myFifthUploadr")
%>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<a class="navbar-brand" href="#">Uploadr demo page</a>
		</div>
	</div>
</nav>

<!-- Example 1 //-->
<div class="jumbotron">
	<div class="container">
		<h1>Example one</h1>
		<p>This is the default Uploadr, how it functions out of the box</p>
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="col-md-6">
			<uploadr:add name="myFirstUploadr" path="${path1}" maxSize="52428800" />
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;uploadr:add name="myFirstUploadr" path="${path1}" maxSize="52428800" />
			</pre>
		</div>
	</div>
</div>
<!-- End Example 1 //-->

<!-- Example 2 //-->
<div class="jumbotron">
	<div class="container">
		<h1>Example 2</h1>
		<p>Initial files, files added on top, paginate into 5 files per page, allowed extensions .jpg, .png and .gif and additional custom variable passed to the controller (<i>model</i>)</p>
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="col-md-12">
			<h2>Initial files, files added on top, paginate into 5 files per page, allowed extensions .jpg, .png and .gif and additional custom variable passed to the controller (<i>model</i>)</h2>
		</div>
		<div class="col-md-6">
			<uploadr:add name="mySecondUploadr" path="${path2}" allowedExtensions="jpg,png,gif" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}" maxSize="52428800" model="[booleanOne:true, variableTwo: 'foo', variableThree: 'bar', variableFour: 4, myObject: someObject]">
				<g:each in="${path2.listFiles()}" var="file">
					<uploadr:file name="${file.name}">
						<uploadr:fileSize>${file.size()}</uploadr:fileSize>
						<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
						<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
					</uploadr:file>
				</g:each>
			</uploadr:add>
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;uploadr:add name="mySecondUploadr" path="${path2}" allowedExtensions="jpg,png,gif" direction="up" maxVisible="5" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}" model="[booleanOne:true, variableTwo: 'foo', variableThree: 'bar', variableFour: 4, myObject: someObject]">
				<g:each in="${path2.listFiles()}" var="file">
					&lt;uploadr:file name="${file.name}">
					&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
					&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
					&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
					&lt;/uploadr:file>
				</g:each>
				&lt;/uploadr:add>
			</pre>
		</div>
	</div>
</div>
<!-- End Example 2 //-->

<!-- Example 3 //-->
<div class="jumbotron">
	<div class="container">
		<h1>Example 3</h1>
		<p>Initial files, new files on top, 5 files per page, max file size is 500kb, maximum of 2 concurrent uploads (pausing others), enable rating and voting</p>
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="col-md-6">
			<uploadr:add name="myThirdUploadr" path="${path3}" direction="up" maxVisible="5" maxSize="512000" rating="true" voting="true" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}" maxConcurrentUploads="2" maxConcurrentUploadsMethod="pause">
				<g:each in="${path3.listFiles()}" var="file">
					<uploadr:file name="${file.name}">
						<uploadr:fileSize>${file.size()}</uploadr:fileSize>
						<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
						<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
						<uploadr:rating>${new Random().nextFloat()}</uploadr:rating>
					</uploadr:file>
				</g:each>
			</uploadr:add>
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;uploadr:add name="myThirdUploadr" path="${path3}" direction="up" maxVisible="5" maxSize="512000" rating="true" voting="true" unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}" maxConcurrentUploads="2" maxConcurrentUploadsMethod="pause">
				<g:each in="${path3.listFiles()}" var="file">
					&lt;uploadr:file name="${file.name}">
					&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
					&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
					&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
					&lt;uploadr:rating>${new Random().nextFloat()}&lt;/uploadr:rating>
					&lt;/uploadr:file>
				</g:each>
				&lt;/uploadr:add>
			</pre>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<input type="button" id="clearButton3" name="test1" value="clear the uploadr but do not erase files">
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;input type="button" id="test1" name="test" value="clear the uploadr but do not erase files">
				&lt;script>
				$(document).ready(function() {
					$('#test1').on('click', function() {
						$('.uploadr[name=myThirdUploadr]').data('uploadr').clear({
							sound: true,
							erase: false
						});
					});
				});
				&lt;/script>
			</pre>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<input type="button" id="onlyPNG3" name="test2" value="change the initialed uploadr to only allow .png">
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;input type="button" id="test2" name="test" value="change the initialed uploadr to only allow .png">
				&lt;script>
				$(document).ready(function() {
					$('#test2').on('click', function() {
						$('.uploadr[name=myThirdUploadr]').data('uploadr').set('allowedExtensions', 'png');
					});
				});
				&lt;/script>
			</pre>
		</div>
	</div>
</div>
<!-- End Example 3 //-->

<!-- Example 4 //-->
<div class="jumbotron">
	<div class="container">
		<h1>Example 4</h1>
		<p>Initial files, files are added to the bottom (default), custom event handlers, rating & voting, rating tooltips, override default file colors to <span style="color:#c78cda">#c78cda</span>, colorpicker, and disable file deletions</p>
		<p>note that due to using a custom <i>onDelete</i> handler the uploaded files do <i>not</i> get deleted anymore!</p>
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="col-md-6">
			<uploadr:add name="myFourthUploadr" path="${path4}" maxVisible="5" rating="true" voting="true" colorPicker="true" maxSize="52428800">
				<g:each in="${path4.listFiles()}" var="file">
					<uploadr:file name="${file.name}">
						<uploadr:fileSize>${file.size()}</uploadr:fileSize>
						<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
						<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
						<uploadr:color>#c78cda</uploadr:color>
						<uploadr:deletable>false</uploadr:deletable>
						<uploadr:ratingText>This is the tooltip text of the rating for ${file.name}</uploadr:ratingText>
					</uploadr:file>
				</g:each>
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
                    console.log('response was:');
                    console.log(response);

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
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;uploadr:add name="myFourthUploadr" path="${path4}" maxVisible="5" rating="true" voting="true" colorPicker="true">
				<g:each in="${path4.listFiles()}" var="file">
					&lt;uploadr:file name="${file.name}">
					&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
					&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
					&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
					&lt;uploadr:color>#f594cc&lt;/uploadr:color>
					&lt;uploadr:deletable>false&lt;/uploadr:deletable>
					&lt;uploadr:ratingText>This is the tooltip text of the rating for ${file.name}&lt;/uploadr:ratingText>
					&lt;/uploadr:file>
				</g:each>
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
					console.log('response was:');
					console.log(response);

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
		</div>
	</div>
</div>
<!-- End Example 4 //-->

<!-- Example 5 //-->
<div class="jumbotron">
	<div class="container">
		<h1>Example 5</h1>
		<p>Initial files, files are added to the top, custom <a href="${resource(plugin:'uploadr', dir:'css', file:'demo.scss')}" target="_new">scss</a>, custom drop text, custom file browse text, paginate to 4 files per page, rating, no sound effects</p>
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="col-md-6">
			<uploadr:add name="myFifthUploadr" path="${path5}" direction="up" class="demo" placeholder="Behold: the drop area!" fileselect="Behold: the fileselect!" maxVisible="4" noSound="true" maxSize="52428800">
				<g:each in="${path5.listFiles()}" var="file">
					<uploadr:file name="${file.name}">
						<uploadr:fileSize>${file.size()}</uploadr:fileSize>
						<uploadr:fileModified>${file.lastModified()}</uploadr:fileModified>
						<uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}</uploadr:fileId>
					</uploadr:file>
				</g:each>
			</uploadr:add>
		</div>
		<div class="col-md-6">
			<pre class="brush:html collapse:false">
				&lt;uploadr:add name="myFifthUploadr" path="${path5}" direction="up" rating="true" class="demo" placeholder="Behold: the drop area!" fileselect="Behold: the fileselect!" maxVisible="4" noSound="true">
				<g:each in="${path5.listFiles()}" var="file">
					&lt;uploadr:file name="${file.name}">
					&lt;uploadr:fileSize>${file.size()}&lt;/uploadr:fileSize>
					&lt;uploadr:fileModified>${file.lastModified()}&lt;/uploadr:fileModified>
					&lt;uploadr:fileId>myId-${RandomStringUtils.random(32, true, true)}&lt;/uploadr:fileId>
					&lt;/uploadr:file>
				</g:each>
				&lt;/uploadr:add>
			</pre>
		</div>
	</div>
	<!-- End Example 5 //-->

	<hr>

	<footer>
		<p>&copy; Jeroen Wesbeek 2011-${new Date().format("yyyy")} </p>
	</footer>
</div>