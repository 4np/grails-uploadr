//= require shCore.js
//= require shAutoloader.js
//= require shBrushXml.js
//= require bootstrap.min.js
//= require_self

$(document).ready(
	function() { SyntaxHighlighter.all();

	$('#clearButton3').on('click', function() {
		$('.uploadr[name=myThirdUploadr]').data('uploadr').clear({
			sound: true,
			erase: false
		});
	});

	$('#onlyPNG3').on('click', function() {
		$('.uploadr[name=myThirdUploadr]').data('uploadr').set('allowedExtensions', 'png');
	});
});
