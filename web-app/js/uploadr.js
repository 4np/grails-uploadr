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
 *  $Author: work@osx.eu $
 *  $Rev: 628 $
 *  $Date: 2011-08-11 14:04:06 +0200 (Thu, 11 Aug 2011) $
 */
(function($){
	// methods
	var methods = {
		playNotification: function() {
			if (notification) notification.play();
		},

		playError: function() {
			if (error) error.play();
		},

		cancel: function(event) {
			// prevent default browser behaviour
  			if (event.preventDefault) {
    			event.preventDefault();
    			event.stopPropagation();
  			}

			// IE requires false
  			return false;
		},

		dragOver: function(event) {
			methods.cancel(event);
		},

		dragEnter: function(event, obj, domObj, hoverClass, options) {
			obj.addClass(hoverClass);
			methods.cancel(event, obj, domObj, hoverClass, options);
			if (!options.workvars.gotFiles) $('.placeholder', obj).hide(); 
		},

		dragLeave: function(event, obj, domObj, hoverClass, options) {
			if (event.target && event.target == obj[0]) {
				obj.removeClass(hoverClass);
			}
			methods.cancel(event);
			$('.placeholder', obj).html(options.placeholderText);
			if (!options.workvars.gotFiles) $('.placeholder', obj).show(); 
		},

		addFile: function(domObj, file, options) {
			// add dom element for this file
			var fileDiv = methods.addFileElements(domObj, file, options, false);
			var fileDomObj = $(fileDiv);

			// and set to complete
			methods.onProgressHandler(fileDomObj, file, 100, 'done');

			// hide the placeholder text
			$('.placeholder', domObj).hide();

			// set work var
			options.workvars.gotFiles = true;

			// add buttons
			methods.addButtons(file, fileDomObj, options);
		},

		addFileElements: function(domObj, file, options, showPercentage) {
			var fileNameDivName = (options.id + 'File' + options.workvars.files.length);

			// add file div and progress bar
			var fileDiv = document.createElement('div');
			fileDiv.setAttribute('class', 'file');

			// add a background bar div
			var backgroundDiv = document.createElement('div');
			backgroundDiv.setAttribute('class', 'background');

			// add a progress bar div
			var progressDiv = document.createElement('div');
			progressDiv.setAttribute('class', 'progress');

			// add fileinfo div
			// - info
			//    +- details
			//    |     +- name
			//    |     +- size
			//    |     +- percentage
			//    +- buttons
			var infoDiv = document.createElement('div');
				infoDiv.setAttribute('class', 'info');

			var detailsDiv = document.createElement('div');
				detailsDiv.setAttribute('class', 'details');
			var fileButtonDiv = document.createElement('div');
				fileButtonDiv.setAttribute('class', 'buttons');

			var spinnerDiv = document.createElement('div');
				spinnerDiv.setAttribute('class', 'spinner');
				spinnerDiv.style.display = 'none';

			var fileNameDiv = document.createElement('div');
				fileNameDiv.setAttribute('class', 'name');
				fileNameDiv.setAttribute('id', fileNameDivName);
			var fileNameSpan = document.createElement('span');
				fileNameSpan.setAttribute('class', 'fileName');
				fileNameSpan.innerHTML = methods.shortenFileName(options.maxFileNameLength, file.fileName);

			var fileSizeDiv = document.createElement('div');
				fileSizeDiv.setAttribute('class', 'size');
				fileSizeDiv.innerHTML = methods.bytesToSize(file.fileSize);

			var filePercentageDiv = document.createElement('div');
				filePercentageDiv.setAttribute('class', 'percentage');
				filePercentageDiv.innerHTML = ((showPercentage) ? '0%' : 'done');

			var fileSpeedDiv = document.createElement('div');
				fileSpeedDiv.setAttribute('class', 'speed');

			// append child divs to infoDiv
			infoDiv.appendChild(detailsDiv);
			infoDiv.appendChild(fileButtonDiv);
			infoDiv.appendChild(spinnerDiv);

			fileNameDiv.appendChild(fileNameSpan);

			detailsDiv.appendChild(fileNameDiv);
			detailsDiv.appendChild(fileSizeDiv);
			detailsDiv.appendChild(filePercentageDiv);
			detailsDiv.appendChild(fileSpeedDiv);

			// add divs to fileDiv
			fileDiv.appendChild(backgroundDiv);
			fileDiv.appendChild(progressDiv);
			fileDiv.appendChild(infoDiv);

			// append fileDiv to the parent element
			var insertIn = $('.files',domObj)[0];

			if (options.insertDirection == 'down') {
				// add to bottom
				insertIn.appendChild(fileDiv);
			} else {
				// add to top
				insertIn.insertBefore(fileDiv,insertIn.childNodes[0]);
			}

			// attach tipTip tooltips
			methods.addFileTooltip($('.fileName', $('#'+fileNameDivName)), file);

			// add this file to the files array
			if (options.insertDirection == 'up') {
				options.workvars.files.unshift(fileDiv);
				if (options.workvars.viewing > 0) options.workvars.viewing++;
			} else {
				if (!(options.workvars.files.length>0 && options.workvars.viewing < (options.workvars.files.length - 1))) {
					options.workvars.viewing = options.workvars.files.length;
				}

				options.workvars.files.push(fileDiv);
			}

			// handle pagination
			methods.handlePagination(domObj, options);

			return fileDiv;
		},

		removeFileElement: function(domObj, options) {
			var parent = domObj.parent();

			// remove file
			domObj.animate({height: '0px'}, 200, 'swing', function() {
				// remove file from files array
				for (var c = 0; c < options.workvars.files.length; c++) {
					if (options.workvars.files[c] == domObj.get(0)) {
						options.workvars.files.splice(c, 1);
						break;
					}
				}

				// change viewing parameter
				if (options.insertDirection == 'up') {
					options.workvars.viewing = (c > 0) ? c-1 : 0;
				} else {
					options.workvars.viewing = (c > (options.workvars.files.length - 1)) ? (options.workvars.files.length - 1) : c;
				}

				// remove element from DOM
				domObj.remove();

				// got any files left?
				if ($('.info', parent).size() < 1) {
					// show placeholder text
					$('.placeholder', parent).show();
				}

				// handle pagination
				methods.handlePagination(options.workvars.uploadrDiv,options);
			});
		},

		handleBadge: function(count, options) {
			// increase upload count
			options.workvars.uploading += count;
			if (options.workvars.uploading < 0) options.workvars.uploading = 0;

			var badgeDiv = options.workvars.badgeDiv,
				uploading= options.workvars.uploading;

			// set badge upload count
			badgeDiv.html(uploading);

			if (uploading < 1 && count < 0) {
				badgeDiv.animate({opacity:0}, { duration: 1000 });
			} else if (uploading == 1 && count > 0) {
				badgeDiv.animate({opacity:1 }, { duration: 700 });
			}
		},

		handlePagination: function(domObj, options) {
			var file, pages, page, v, from, to, prevButton, nextButton,pagesDiv,
				paginationDiv = $('.pagination', domObj),
				pageList = '',
				files = options.workvars.files;

			// unlimited?
			if (options.maxVisible == 0) {
				if (paginationDiv.is(':visible')) paginationDiv.hide();
				return;
			}

			// check if we have more files than can be visible
			if (files.length > options.maxVisible || paginationDiv.is(':visible')) {
				pages	= Math.ceil( files.length / options.maxVisible );
				page = Math.ceil( (options.workvars.viewing + 1) / options.maxVisible );

				// calculate which files to show
				to		= (( options.maxVisible * page) - 1);
				from	= (to - options.maxVisible + 1);

				for (v=0; v < files.length; v++) {
					file = $(files[v]);

					if (v < from || v > to) {
						if (file.is(':visible')) {
							file.hide();
						}
					} else if (file.is(':hidden')) {
						file.show();
					}
				}
			}

			// show / hide controls?
			if (!page || !pages || pages == 1) {
				// hide pagination div
				if (paginationDiv.is(':visible')) paginationDiv.hide();
			} else {
				prevButton = options.workvars.prevButton;
				nextButton = options.workvars.nextButton;
				pagesDiv = options.workvars.pagesDiv;

				// show pagination div
				if (paginationDiv.is(':hidden')) paginationDiv.show();

				// create the page list
				for (v = 1; v <= pages ; v++) {
					pageList += "<li" + ((v == page) ? ' class="current"' : '' ) + ">" + v + "</li>";
				}
				pagesDiv.html(pageList);

				// show/hide the pagination buttons
				if (page == 1) {
					prevButton.hide();
					nextButton.show();
				} else if (page == pages) {
					prevButton.show();
					nextButton.hide();
				} else {
					prevButton.show();
					nextButton.show();
				}
			}

		},

		addFileTooltip: function(domObj, file) {
			domObj.tipTip({
				content		: 'name: ' + file.fileName + '<br/>size: ' + methods.bytesToSize(file.fileSize) + ((file.fileDate) ? ('<br/>date: ' + file.fileDate) : '')
			});
		},

		drop: function(event, obj, domObj, hoverClass, options) {
			var files = event.dataTransfer.files;

			var dropElement = obj;

			// remove class
			dropElement.removeClass(hoverClass);

			// stops the browser from redirecting off to the text.
  			if (event.preventDefault) {
    			event.preventDefault();
    			event.stopPropagation();
  			}

			// iterate through files
			if (typeof files !== "undefined") {
				// hide the placeholder text
				$('.placeholder', obj).hide();

				// set work var
				options.workvars.gotFiles = true;

				// iterate through files
				$.each(files, function(index, file) {
					// add file DOM elements
					var fileAttrs = { fileName: file.fileName, fileSize: file.fileSize, startTime: new Date().getTime() }
					var fileDiv = methods.addFileElements(domObj, fileAttrs, options);

					// and start file upload
					methods.startUpload(file, fileAttrs, $(fileDiv), options);
				});
			}

  			return false;
		},
		
		startUpload: function(file, fileAttrs, domObj, options) {
			var status = "";

			// increase upload counter
			methods.handleBadge(1,options);

			// call onStart event handler
			options.onStart(fileAttrs);

			// check for filesize?
			if (options.maxSize && file.fileSize > options.maxSize) {
				console.log('file is too large!');
				return false;
			}

			// initialze XML Http Request
			var xhr			= new XMLHttpRequest(),
				upload		= xhr.upload,
				progressBar	= $('.progress', domObj);

			// add cancel button
			methods.addButton(domObj, 'cancel', 'cancel.png', 'click to abort file transfer', 'are you sure you would like to abort this tranfer?', options, function(e) {
				// abort transfer
				status = "abort";
				xhr.abort();
			});

			// attach listeners
			upload.addEventListener("progress", function(ev) {
				if (options.onProgress(fileAttrs, domObj, Math.ceil((ev.loaded / ev.total) * 100))) {
					methods.onProgressHandler(domObj, fileAttrs, Math.ceil((ev.loaded / ev.total) * 100));
				}
			}, false);

			upload.addEventListener("error", function (ev) {
				methods.playError();

				if (options.onProgress(fileAttrs, domObj, 100)) {
					methods.onProgressHandler(domObj, fileAttrs, 100);

					// decrease upload counter
					methods.handleBadge(-1,options);
				}

				progressBar.addClass('failed');
			}, false);
			
			upload.addEventListener("abort", function (ev) {
				if (options.errorSound) new Audio(options.errorSound).play();

				if (options.onProgress(fileAttrs, domObj, 100)) {
					methods.onProgressHandler(domObj, fileAttrs, 100, 'aborted');
				}

				progressBar.addClass('failed');

				// callback after abort
				options.onAbort(fileAttrs, domObj);

				// add a delete button to remove the file div
				methods.addButton(domObj, 'delete', 'delete.png', 'click to remove this aborted transfer from your view', '', options, function() {
					methods.removeFileElement(domObj, options);
				});
			}, false);

			xhr.onreadystatechange = function() {
				if (xhr.readyState != 4) { return; }

				var response = (xhr.responseText) ? JSON.parse(xhr.responseText) : {}

				// has the fileName changed in the back end?
				if (response.fileName && fileAttrs.fileName != response.fileName) {
					// yes, update it in the front end
					fileAttrs.fileName = response.fileName;
					methods.addFileTooltip($(".fileName",domObj).html(methods.shortenFileName(options.maxFileNameLength, response.fileName)), fileAttrs);
				}

				// check if everything went well
				if (xhr.status == 200) {
					if (options.onProgress(fileAttrs, domObj, 100)) {
						methods.onProgressHandler(domObj, fileAttrs, 100);
					}

					// show the spinner
					var spinner = $('.spinner', domObj);
					spinner.show('slow');

					// callback when done uploading
					options.onSuccess(fileAttrs, domObj, function() {
						// hide the spinner
						spinner.hide();

						// play notification sound?
						methods.playNotification();

						// decrease upload counter
						methods.handleBadge(-1,options);

						// add buttons
						methods.addButtons(fileAttrs, domObj, options);
					});
				} else {
					methods.playError();

					// whoops, we've got an error!
					if (options.onProgress(fileAttrs, domObj, 100)) {
						methods.onProgressHandler(domObj, fileAttrs, 100);

						// decrease upload counter
						methods.handleBadge(-1,options);
					}

					progressBar.addClass('failed');

					// callback after failure
					options.onFailure(fileAttrs, domObj);

					// delete file if this was an error
					if (status != "abort") options.onDelete(fileAttrs, domObj);

					return;
				}
			};
			
			// start data transfer
			xhr.open("POST",options.uri);
        	xhr.setRequestHeader("Cache-Control", "no-cache");
        	xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        	xhr.setRequestHeader("X-File-Name", file.fileName);
        	xhr.setRequestHeader("X-File-Size", file.fileSize);
        	xhr.setRequestHeader("X-Uploadr-Name", options.id);
			xhr.setRequestHeader("Content-Type", file.contentType);
        	xhr.send(file);
		},

		onProgressHandler: function(domObj, fileAttrs, percentage, text) {
			var progressMaxWidth = domObj.parent().width();
			var progressBar = $('.progress', domObj);

			// calculate speed
			var time, seconds, data, speed, average, secondsLeft;
			if (fileAttrs.startTime && percentage < 100) {
				time	= new Date().getTime();
				seconds	= Math.ceil((time - fileAttrs.startTime) / 1000);
				data	= ((fileAttrs.fileSize / 100) * percentage) / seconds;

				// calculate average
				if (fileAttrs.avg) {
					average = Math.round((fileAttrs.avg + data) / 2);
					fileAttrs.avg = average;
				} else {
					fileAttrs.avg = data;
					average = data;
				}

				// time to go
				secondsLeft = Math.ceil((fileAttrs.fileSize / average) - seconds);

				// calculate average upload speed
				speed = methods.bytesToSize(average) + '/s (about '+methods.secondsToTime(secondsLeft)+' to go)';
			} else {
				speed = '';
			}

			// show upload speed
			$('.speed', domObj).html(speed);

			// handle progressbar width
			progressBar.width((progressMaxWidth / 100) * percentage);
			$('.percentage',domObj).html((text) ? text : percentage + '%');

			// are we done uploading?
			if (percentage >= 100) {
				progressBar.addClass('complete');

				// remove cancel button
				$('.cancel', domObj).hide();

				// unset speed array to save memory
				fileAttrs.speed = null;
			}
		},
		
		addButtons: function(file, domObj, options) {
			// add view, download and delete buttons
			methods.addButton(domObj, 'delete', 'delete.png', 'click to delete this file', 'are you sure you want to delete this file?', options, function() {
				if (options.onDelete(file, domObj)) methods.removeFileElement(domObj, options);
			});
			methods.addButton(domObj, 'download', 'page_link.png', 'click to download this file', '', options, function() {
				options.onDownload(file, domObj);
			});
			methods.addButton(domObj, 'view', 'magnifier.png', 'click to view this file', '', options, function() {
				options.onView(file, domObj);
			});
		},

		addButton: function(domObj, type, image, tooltipText, confirmationText, options, handler) {
			var buttonDiv = document.createElement('div');
				buttonDiv.setAttribute('class', 'button ' + type);
				buttonDiv.setAttribute("style", "display: none");
			var buttonImage = document.createElement('img');
				buttonImage.setAttribute('src', options.famfamfam + '/' + image);
				buttonDiv.appendChild(buttonImage);
			var buttonsDiv = $('.buttons', domObj);

			buttonsDiv[0].appendChild(buttonDiv);

			var button = $('.' + type, domObj);

			// add tooltip?
			if (tooltipText) {
				button.tipTip({content: tooltipText});
			}

			// bind event handler
			button.bind('click', function(event) {
			    if (!confirmationText || (confirm && confirm(confirmationText))) {
					handler();
			    }
			});

			button.show('slow');

			return button;
		},
		
		/**
		 * return human readable file sizes
		 * @param int bytes
		 * @returns string human readable filesize
		 */
		bytesToSize: function(bytes) {
			var sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
			if (bytes == 0) return 'n/a';
			var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
			return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
		},

		secondsToTime: function(seconds) {
			var sizes = [' seconds', 'minutes', 'hours'];
			if (seconds == 0) return 'n/a';
			var i = parseInt(Math.floor(Math.log(seconds) / Math.log(60)));
			return Math.round(seconds / Math.pow(60, i), 2) + ' ' + sizes[i];
		},

		/**
		 * return a shortened filename
		 * @param length
		 * @param fullFileName
		 */
		shortenFileName: function(length, fullFileName) {
			var fileName    = "",
				extension   = "",
				middle      = "",
				strip       = 0,
				dot         = fullFileName.lastIndexOf(".");

			if (fullFileName.length <= length) {
				return fullFileName;
			} else if (dot) {
				fileName	= fullFileName.substring(0,dot);
				extension	= fullFileName.substring(dot+1,fullFileName.length);
				strip       = (length - 4 - extension.length);

				// check if this is a filename which is made unique
				// (hence, ending with \-[0-9]+
				if (fileName.match(/\-\d+$/)) {
					dot         = fileName.lastIndexOf("-")
					middle      = fileName.substring(dot+1,fileName.length)
					fileName    = fileName.substring(0,dot);
					strip -= middle.length;
				}
			} else {
				fileName	= fullFileName;
			}

			return fileName.substring(0, strip) + ((middle) ? ('...' + middle + '.') : '....') + extension
		},

		addFileUploadField: function(j,domObj,options) {
			// insert upload field
			var fileUploadElement = document.createElement('input');
				fileUploadElement.setAttribute('type', 'file');
				fileUploadElement.multiple = true;
			var messageDiv = document.createElement('div');
				messageDiv.setAttribute('class', 'message');
				messageDiv.innerHTML = options.fileSelectText;
			var fileInputDiv = document.createElement('div');
				fileInputDiv.setAttribute('class','fileinput');
				fileInputDiv.appendChild(messageDiv);
				fileInputDiv.appendChild(fileUploadElement);

			domObj.appendChild(fileInputDiv);
			var inputField = $('input[type=file]',j);

			// bind image click to file input click
			$('.message', j).bind('click', function() {
				// trigger click event on file input field
				inputField[0].click();
			});

			// bind file field event handler
			inputField.bind('change', function() {
				// iterate through files
				if (typeof this.files !== "undefined") {
					// hide the placeholder text
					$('.placeholder', domObj).hide();

					// set work var
					options.workvars.gotFiles = true;

					// iterate through files
					$.each(this.files, function(index,file) {
						// add file DOM elements
						var fileAttrs = { fileName: file.fileName, fileSize: file.fileSize }
						var fileDiv = methods.addFileElements(domObj, fileAttrs, options);

						// and start file upload
						methods.startUpload(file, fileAttrs, $(fileDiv), options);
					});
				}
			});
		}
	};

	// define the jquery plugin code
	$.fn.uploadr = function(options) {
		// default settings
		var defaults = {
			placeholderText		: 'drag and drop your files here to upload...',
			fileSelectText 		: 'Select files to upload',
			dropableClass		: 'uploadr-dropable',
			hoverClass			: 'uploadr-hover',
			uri					: '/upload/uri',
			id					: 'uploadr',
			famfamfam 			: '/images/icons',
			maxFileNameLength	: 34,
			maxSize				: 0,	// 0 = unlimited
			maxVisible 			: 5,	// 0 = unlimited
			files				: [],
			uploadField 		: true,
			insertDirection 	: 'down',

			// default sound effects
			notificationSound   : '',
			errorSound          : '',

			// workvariables, internal use only
			workvars 			: {
				gotFiles		: false,
				files			: [],
				notification	: null,
				error			: null,
				viewing			: 0,
				uploading		: 0,
				badgeDiv 		: null,
				uploadrDiv 		: null,
				paginationDiv 	: null,
				pagesDiv 		: null,
				nextButton 		: null,
				prevButton 		: null
			},

			// default event handlers
			onStart 			: function(file) {},
			onProgress			: function(file, domObj, percentage) {
				// return false to cancel default progress handler
				return true;
			},
			onSuccess			: function(file, domObj, callback) { callback(); },
			onFailure			: function(file, domObj) { return true; },
			onAbort             : function(file, domObj) { return true; },
			onView              : function(file, domObj) { return true; },
			onDownload          : function(file, domObj) { return true; },
			onDelete            : function(file, domObj) { return true; }
		};

		// extend the jQuery options
		var options = $.extend(defaults, options);

		return this.each(function() {  
			var obj	= $(this);
			var e	= obj.get(0);

			// add file upload field
			if (options.uploadField) methods.addFileUploadField(obj,e,options);

			// add badge
			var badgeDiv = document.createElement('div');
				badgeDiv.setAttribute('class', 'badge hidden');

			// add placeholder text
			var placeholderDiv = document.createElement('div');
				placeholderDiv.setAttribute('class', 'placeholder');
				placeholderDiv.innerHTML = defaults.placeholderText;

			// add files div
			var filesDiv = document.createElement('div');
				filesDiv.setAttribute('class', 'files '+defaults.dropableClass);
				filesDiv.appendChild(placeholderDiv);

			// add pagination div
			var paginationDiv = document.createElement('div');
				paginationDiv.setAttribute('class', 'pagination');

			// add pagination elements
			var prevButtonDiv = document.createElement('div');
				prevButtonDiv.setAttribute('class', 'previous');
			var pagesDiv = document.createElement('div');
				pagesDiv.setAttribute('class', 'pages');
			var nextButtonDiv = document.createElement('div');
				nextButtonDiv.setAttribute('class', 'next');
			paginationDiv.appendChild(prevButtonDiv);
			paginationDiv.appendChild(pagesDiv);
			paginationDiv.appendChild(nextButtonDiv);

			// append divs to uploadr element
			e.appendChild(badgeDiv);
			e.appendChild(filesDiv);
			e.appendChild(paginationDiv);

			// set workvars
			options.workvars.uploadrDiv = e;
			options.workvars.badgeDiv = $(badgeDiv);
			options.workvars.paginationDiv = $(paginationDiv);
			options.workvars.pagesDiv = $(pagesDiv);
			options.workvars.nextButton = $(nextButtonDiv);
			options.workvars.prevButton = $(prevButtonDiv);

			// hide divs
			options.workvars.badgeDiv.css({ opacity: 0 });
			options.workvars.paginationDiv.hide();

			// register event handlers
			filesDiv.addEventListener('dragover', methods['dragOver'], false);
			filesDiv.addEventListener('dragenter', function(event) { methods['dragEnter'](event, $(this), e, defaults.hoverClass, options); }, false);
			filesDiv.addEventListener('dragleave', function(event) { methods['dragLeave'](event, $(this), e, defaults.hoverClass, options); }, false);
			filesDiv.addEventListener('drop', function(event) { methods['drop'](event, $(this), e, defaults.hoverClass, options); }, false);

			// register pagination event handlers
			$(prevButtonDiv).bind('click', function() {
				options.workvars.viewing = options.workvars.viewing - options.maxVisible;
				methods.handlePagination(e,options);
			});
			$(nextButtonDiv).bind('click', function() {
				options.workvars.viewing = options.workvars.viewing + options.maxVisible;
				methods.handlePagination(e,options);
			});
			methods.handlePagination(e,options);

			// got initial files?
			if (options.files) {
				for (var iterator in options.files) {
					methods.addFile(e, options.files[iterator], options);
				}
			}

			// initialize notification sounds?
			if (options.notificationSound) notification = new Audio(options.notificationSound);
			if (options.errorSound) error = new Audio(options.errorSound);
		});
	};
})(jQuery);
