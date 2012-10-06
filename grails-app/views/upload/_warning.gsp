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
def msie = request.getHeader('user-agent').contains("MSIE")
%>
<div class="warning">
	<div class="message">
		To use this application you need a <a href="http://en.wikipedia.org/wiki/HTML5" target="_html5">HTML5</a> capable browser:
	</div>
	<div class="browsers">
		<div class="browser chrome">
			<div class="anchor">
				<a href="http://www.google.com/chrome" target="_chrome">Get Chrome</a>
			</div>
		</div>
		<div class="browser firefox">
			<div class="anchor">
				<a href="http://www.mozilla.com/firefox" target="_firefox">Get Firefox</a>
			</div>
		</div>
		<div class="browser safari">
			<div class="anchor">
				<a href="http://www.apple.com/safari/" target="_safari">Get Safari</a>
			</div>
		</div>
	</div>
<g:if test="${msie}">
	<div class="message">
		upgrade to <a href="http://ie.microsoft.com/testdrive/" target="_ie10">Internet Explorer 10</a> or install the<br/>
		<a href="http://www.google.com/chromeframe" target="_chromeframe">Google Chrome Frame</a> browser plugin for Internet Explorer:
	</div>
	<div class="button">
		<a href="http://www.google.com/chromeframe" target="_chromeframe">Install Google Chrome Frame Plugin</a>
	</div>
</g:if>
</div>