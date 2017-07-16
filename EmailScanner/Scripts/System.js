var System;
if (!System) {
    System = {};

    System.getThemeColor = function () {
        var widgetColor = $('.ui-widget-header').css('backgroundColor');
        var themeColor = typeof widgetColor === 'undefined' ? '#deedf7' : rgb2hex(widgetColor);

        return themeColor;

        function rgb2hex(rgb) {
            if (rgb.search("rgb") === -1) {
                return rgb;
            } else if (rgb === 'rgba(0, 0, 0, 0)') {
                return 'transparent';
            } else {
                rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);

                return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
            }

            function hex(x) {
                return ("0" + parseInt(x).toString(16)).slice(-2);
            }
        }
    };

    //----------------------------------------------------------------
    // Overwrite default options of jqGrid
    if (typeof $.jgrid !== "undefined") {
        $.extend($.jgrid.del, {
            beforeShowForm: function ($form) {
                positionForm($form);
            }
        });

        $.extend($.jgrid.add, {
            closeOnEscape: true,
            closeAfterAdd: true,
            beforeShowForm: function ($form) {
                hookNavigationButtonsToKeys($form);
                positionForm($form);
            }
        });

        $.extend($.jgrid.edit, {
            closeOnEscape: true,
            closeAfterEdit: true,
            afterShowForm: function ($form) {
                hookNavigationButtonsToKeys($form);
                positionForm($form);
            }
        });

        $.extend($.jgrid.view, {
            recreateForm: true,
            beforeShowForm: function ($form) {
                $form.find("td.DataTD").each(function () {
                    var $this = $(this);

                    $this.children("span").css({
                        overflow: "auto",
                        "text-align": "inherit",
                        display: "inline-block",
                        "max-height": "600px"
                    });
                });

                hookNavigationButtonsToKeys($form);
                positionForm($form, 894);
            }
        });

        // add an extended function to jqgrid object
        $.extend($.jgrid, {
            placeSearchDialogAboveGrid: function (parameters) {
                var gridSelector = $.jgrid.jqID($(parameters.tableid)[0].id), // 'list'
                    $searchDialog = $("#searchmodfbox_" + gridSelector),
                    $gbox = $("#gbox_" + gridSelector),
                    $gview = $("#gview_" + gridSelector);
                var displaySearchDialogCloseButton = typeof (parameters.displaySearchDialogCloseButton)
                    !== 'undefined' ? parameters.displaySearchDialogCloseButton : false;

                if (!displaySearchDialogCloseButton) {
                    // hide 'close' button of the searching dialog
                    $searchDialog.find("a.ui-jqdialog-titlebar-close").hide();
                }

                // place the searching dialog above the grid
                $searchDialog.insertBefore($gbox);
                $searchDialog.css({
                    width: "100%",
                    "font-size": $gview.css("font-size"),
                    position: "relative",
                    zIndex: "auto",
                    cssFloat: "left"
                });
                $gbox.css({ clear: "left" });

                // search on enter
                if (parameters.searchOnEnter === true) {
                    $searchDialog.keypress(function (event) {
                        if (event.which === 13) {
                            $(this).focus();
                            $("#fbox_" + gridSelector + "_search").click();
                        }
                    });
                }

                return {
                    gridSelector: gridSelector,
                    gbox: $gbox,
                    searchDialog: $searchDialog
                };
            },
            resizeOnWindowResizeEvent: function ($grid) {
                // resize the grid when window's resize event triggers
                $(window).resize(function () {
                    // Note: checking the $grid only may not be enough
                    // to determine whether we should do the resize or not
                    // because the $grid is wrapped inside a #gbox div tag.
                    // So, it is best to check the $gbox to do the resize.
                    // skip if the grid is not visible on the screen

                    var gridSelector = $.jgrid.jqID($grid[0].id),
                        $gbox = $("#gbox_" + gridSelector);

                    if ($gbox.is(':visible')) {
                        var new_width = $gbox.parent().width();

                        if ($grid.data('resize-width') != new_width) {
                            $grid.jqGrid('setGridWidth', new_width);
                            // remember the width so that it will not
                            // request the resize change again if the
                            // width has not been changed
                            $grid.data('resize-width', new_width);
                        }
                    }
                });
            },
            exportToCSV: function (parameters) {
                var filename = typeof (parameters.filename) === 'undefined' ? "export.csv" : parameters.filename;
                var $table = parameters.table;

                var $rows = $table.jqGrid('getGridParam', 'data');

                // use the getRowData method if the data from
                // the getGridParam method is not available
                if ($rows.length === 0) {
                    $rows = $table.jqGrid('getRowData');
                }

                // skip if there is no data
                if ($rows.length === 0) {
                    alert("There is no data!");
                    return;
                }

                // Temporary delimiter characters unlikely to be typed by keyboard
                // This is to avoid accidentally splitting the actual contents
                var tmpColDelim = String.fromCharCode(11), // vertical tab character
                tmpRowDelim = String.fromCharCode(0), // null character

                // actual delimiter characters for CSV format
                colDelim = '","',
                rowDelim = '"\r\n"',

                // Grab text from table into CSV formatted string
                csv = arrayToCSV(getHeaders()) + "\r\n" + arrayToCSV($rows.map(rowMapper)),

                // Data URI
                csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

                if (window.navigator.msSaveBlob) { // IE 10+
                    window.navigator.msSaveOrOpenBlob(new Blob([csv], {
                        type: "text/plain;charset=utf-8;"
                    }), filename);
                } else {
                    var link = document.createElement('a');
                    link.href = csvData;
                    link.download = filename;
                    link.target = '_blank';
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                }

                function getHeaders() {
                    var row = $rows[0];
                    var headers = [];

                    for (var key in row) {
                        if (row.hasOwnProperty(key)) {
                            headers.push(key);
                        }
                    };

                    return $.makeArray(arrayToString(headers));
                }

                function rowMapper(row, i) {
                    var cols = [];

                    for (var key in row) {
                        if (row.hasOwnProperty(key)) {
                            cols.push(row[key]);
                        }
                    };

                    return arrayToString(cols);
                };

                function arrayToString(array) {
                    return array.map(function (col, j) {
                        if (typeof col === 'string') {
                            // escape double quotes
                            return col.replace(/"/g, '""');
                        } else {
                            return col;
                        }
                    }).join(tmpColDelim);
                }

                function arrayToCSV(array) {
                    return '"' + array.join(tmpRowDelim)
                    .split(tmpRowDelim).join(rowDelim)
                    .split(tmpColDelim).join(colDelim) + '"';
                }
            },
            addExportToCSVButton: function ($grid) {
                if (!$grid) {
                    return;
                }

                var gridParameters = $grid.jqGrid('getGridParam');

                if (!gridParameters) {
                    return;
                }

                if (gridParameters.pager) {
                    $grid.jqGrid('navButtonAdd', {
                        caption: "",
                        title: "Export the list to an CSV file",
                        buttonicon: "fa-save",
                        onClickButton: function () {
                            $.jgrid.exportToCSV({ table: $grid });
                        },
                        position: "last"
                    });
                }
            }
        });

        $.extend($.jgrid.defaults, {
            iconSet: "fontAwesome",
            searching: {
                searchOperators: true,
                defaultSearch: "cn"
            }
        });

        function positionForm(formid, minWidth) {
            setTimeout(function () {
                var $dialog = $(formid).closest('div.ui-jqdialog');

                if (typeof (minWidth) !== "undefined") {
                    $dialog.css({
                        "min-width": minWidth
                    });
                }

                $dialog
                .position({
                    my: "top",
                    at: "top",
                    of: window
                });
            }, 0);
        }

        // hook up the navigation buttons to the keys
        function hookNavigationButtonsToKeys($form) {
            setTimeout(function () {
                var $dialog = $form.closest('div.ui-jqdialog');
                var prevButton = $dialog.find("#pData");
                var nextButton = $dialog.find("#nData");

                // hook up the previous button to the left key
                $dialog.keypress(function (event) {
                    if (event.keyCode == 37) { // left
                        prevButton.click();
                    }
                });

                // hook up the next button to the right key
                $dialog.keypress(function (event) {
                    if (event.keyCode == 39) { // right
                        nextButton.click();
                    }
                });
            }, 0);
        }
    }
    //----------------------------------------------------------------

    //----------------------------------------------------------------
    // Define global AngularJS custom directives
    if (typeof (angular) !== 'undefined') {
        System.angular = angular.module('app', ['ng'])
        .directive('fileSize', ['$timeout', function ($timeout) {
            return {
                restrict: 'A',
                link: function (scope, element, attr) {
                    var $element = $(element);

                    $timeout(function () {
                        var fileSize = $element.text();
                        $element.html(System.formatBytes(fileSize, 1));
                    });
                }
            };
        }])
        .directive('autosize', ['$timeout', function ($timeout) {
            return {
                restrict: 'A',
                link: function (scope, element, attr) {
                    var $element = $(element);
                    var $options = $.extend({}, scope.$eval(attr.autosize));

                    $timeout(function () {
                        // source: github.com/jackmoore/autosize
                        autosize($element);
                    });
                }
            };
        }])
        .directive('timeAgo', function () {
            return {
                restrict: 'AEC',
                link: function (scope, element, attributes) {
                    var options = scope.$eval(attributes.timeAgo);

                    if ($.isFunction($.timeago)) {
                        // Display original dates older than 24 hours
                        jQuery.timeago.settings.cutoff = 1000 * 60 * 60 * 24;

                        $(element).timeago(options);
                    }
                }
            };
        })
        .directive('ckeditor', function () {
            return {
                restrict: 'A',
                require: '?ngModel',
                link: function (scope, element, attr, ngModel) {
                    var options = scope.$eval(attr.ckeditor);
                    var $element = $(element);
                    var $formTextId = 'editor-' + System.nextUniqueID();
                    var ckeditorOptions = $.extend({}, System.CKEDITOR_DEFAULT_CONFIG, options);

                    // assign a unique ID to the textarea if not having one
                    // because the CKEDITOR requires an ID
                    if (!$element[0].id) {
                        $element.attr('ID', $formTextId);
                    } else {
                        $formTextId = $element[0].id;
                    }

                    // remove the toolbar when in read-only mode
                    if (options.readOnly === true) {
                        $.extend(ckeditorOptions, {
                            allowedContent: true,
                            startupShowBorders: false,
                            toolbar: [
                                { name: 'tools', items: ['Maximize', 'ShowBlocks', 'Print', 'Copy'] },
                                { name: 'document', groups: ['mode', 'document', 'doctools'], items: ['Source'] }
                            ]
                        });
                    }

                    // setup the editor for the notes
                    var editor = CKEDITOR.replace($formTextId, ckeditorOptions);

                    if (options.linkClickable === true) {
                        editor.on('instanceReady', function (event) {
                            //catch clicks on <a>'s to open hrefs in a new tab/window
                            $('iframe').contents().click(function (e) {
                                if (typeof e.target.href !== 'undefined') {
                                    window.open(e.target.href, e.target.href.indexOf("http") === 0 ? '_blank' : '_top');
                                }
                            });
                        });
                    }

                    //---------------------------------------------
                    // setup as an angularJS model for editing
                    if (!ngModel) {
                        return;
                    }

                    editor.on('instanceReady', function () {
                        editor.setData(ngModel.$viewValue);
                    });

                    editor.on('change', function () {
                        scope.$apply(function () {
                            ngModel.$setViewValue(editor.getData());
                        });
                    });

                    ngModel.$render = function (value) {
                        editor.setData(ngModel.$modelValue);
                    };
                    //---------------------------------------------
                }
            };
        })
        .directive('submitAjax', ['$compile', function ($compile) {
            return {
                restrict: 'A',
                link: function (scope, element, attributes) {
                    var $form = $(element);
                    var $options = scope.$eval(attributes.submitAjax);

                    if (typeof ($options) === 'undefined') {
                        $options = { replaceContent: false };
                    }

                    $form.submit(function (event) {
                        /* stop form from submitting normally */
                        event.preventDefault();

                        /* get some values from elements on the page: */
                        var url = $form.attr('action');
                        var messageHolder = getMessageHolder();
                        var successMessage = $('<span style="margin-left:5px" class="ui-state-highlight">Saved</span>');
                        var loadingMessage = $('<i style="margin-left:5px" class="fa fa-spinner fa-spin fa-lg"></i>');

                        // skip submitting if the form is not valid
                        if (!$form.valid()) {
                            return;
                        }

                        /* Send the data using post */
                        var posting = $.post(url, $form.serialize());

                        /* print the success message */
                        posting.done(function (data) {
                            if ($options.replaceContent === true) {
                                $form.html(data);
                                $compile($form.contents())(scope);
                            }

                            messageHolder.parent().append(successMessage);

                            // remove after 3 seconds
                            setTimeout(function () { successMessage.remove(); }, 3000);

                            var formTitle = $form.attr('title');

                            if (typeof formTitle === 'undefined') {
                                formTitle = 'Success';
                            }

                            System.notify("Saved!", formTitle, "success");
                        });

                        /* print the error message */
                        posting.fail(function (data) {
                            $form[0].reset();

                            System.notify("Failed to save the data!", "Error", "error");
                        });

                        /* display a loading message */
                        messageHolder.parent().append(loadingMessage);

                        /* disable the holder or submit button */
                        messageHolder.prop("disabled", true);

                        /* remove the loading mesage */
                        posting.always(function (data) {
                            loadingMessage.remove();

                            messageHolder.prop("disabled", false);
                        });

                        function getMessageHolder() {
                            var messageHolder = $form.find('input[type=submit]');

                            if (messageHolder.length === 0) {
                                messageHolder = $form.find('button[type=submit]');
                            }

                            // if there is no submit button, then use
                            // the form to display the message.
                            if (messageHolder.length === 0) {
                                messageHolder = $form;
                            }

                            return messageHolder;
                        }
                    });
                }
            };
        }])
        .directive('iframeResizer', ['$compile', function ($compile) {
            return {
                restrict: 'A',
                link: function (scope, element, attr) {
                    var $element = $(element);
                    var $options = $.extend({}, scope.$eval(attr.iframeResizer));

                    $element.iFrameResize($options);
                }
            };
        }])
        .directive('grandchildIframeResizer', ['$compile', function ($compile) {
            return {
                restrict: 'A',
                link: function (scope, element, attr) {
                    var $element = $(element);
                    var $options = $.extend({}, scope.$eval(attr.grandchildIframeResizer));

                    $('> * > iframe', element).iFrameResize($options);
                }
            };
        }])
        .directive('accordion', ['$compile', '$timeout', function ($compile, $timeout) {
            return {
                restrict: 'A',
                link: function (scope, element, attributes) {
                    var options = scope.$eval(attributes.accordion);

                    // turn element into accordions
                    $(element).accordion($.extend(options, {
                        beforeActivate: function (event, ui) {
                            var panel = ui.newPanel;
                            var url = panel.data('url');

                            if (panel.html() === '' && typeof url !== 'undefined') {
                                var panelType = panel.data('type');
                                var panelStyle = panel.data('style');

                                if (panelType === 'iframe') {
                                    var element = [];

                                    element.push('<iframe seamless');
                                    if (typeof panelStyle !== 'undefined') {
                                        element.push(' style="');
                                        element.push(panelStyle);
                                        element.push('"');
                                    }
                                    element.push(' src="');
                                    element.push(url);
                                    element.push('" />');

                                    panel.append(element.join(''));
                                }
                                else {
                                    panel.load(url, function () {
                                        $timeout(function () {
                                            $compile($(panel).contents())(scope);
                                        });
                                    });
                                }
                            }
                        },
                        activate: function (event, ui) {
                            // help to correct the size of the elements
                            $(window).trigger('resize');
                        }
                    }));
                }
            };
        }])
        .directive('jqTabs', ['$compile', '$timeout', function ($compile, $timeout) {
            return {
                restrict: 'A',
                link: function (scope, element, attributes) {
                    var options = scope.$eval(attributes.jqTabs);

                    options = $.extend({
                        active: false,
                        collapsible: true, // required for the active to be false
                        beforeLoad: function (event, ui) {
                            //------------------------------------------------------
                            // Prevent ajax tabs from reload
                            if (ui.tab.data("loaded")) {
                                event.preventDefault();
                                return;
                            }

                            // support iframe panel
                            if (ui.tab.data('panel') === 'iframe') {
                                var iframe = [];
                                iframe.push('<iframe seamless src="');
                                iframe.push(ui.tab.find('a').attr('href'));
                                iframe.push('" />');
                                ui.panel.html(iframe.join(''));
                                event.preventDefault();
                                ui.tab.data("loaded", true);
                                return;
                            }

                            ui.jqXHR.done(function () {
                                ui.tab.data("loaded", true);
                            });
                            //------------------------------------------------------
                        },
                        load: function (event, ui) {
                            $timeout(function () {
                                $compile($(ui.panel).contents())(scope);
                            });
                        },
                        beforeActivate: function (event, ui) {
                            // support goto link
                            if (ui.newTab.data('panel') === 'href') {
                                location.href = $('a', ui.newTab).data('href');
                                return false;
                            }

                            var parent_path = ui.newTab.closest('.ui-tabs-panel').data('href');
                            var path = (typeof parent_path === 'undefined' ? "#" : parent_path) + '/' + ui.newTab.index();

                            location.href = path;

                            // store the tab selection as an attribute of the tab
                            // so that child tabs can use it to reconstruct its selection.
                            ui.newPanel.data("href", path);

                            return true;
                        },
                        activate: function (event, ui) {
                            // trigger resize to make sure the jqGrids
                            // are expanded to full width when switch tabs
                            $(window).trigger('resize');

                            var $panel = ui.newPanel;

                            if ($panel.is(":empty")) {
                                $panel.append('<i class="fa fa-spinner fa-spin fa-lg"></i>');
                            } else {
                                // show the tab if the panel contains a tab
                                var tabs = ui.newPanel.children().first();

                                // activate the first tab only if the tabs element is not active
                                if (tabs.hasClass('ui-tabs') && !tabs.tabs("option", "active")) {
                                    tabs.tabs("option", "active", 0);
                                }
                            }
                        }
                    }, options);

                    // turn the element into a jQuery tab
                    element.tabs(options)
                    // make the tab not collapsible after activation
                    .tabs("option", "collapsible", false);
                }
            };
        }]);
    }
    //----------------------------------------------------------------

    // setup default CKeditor's config
    //----------------------------------------------------------------
    if (typeof CKEDITOR !== "undefined") {
        System.CKEDITOR_DEFAULT_CONFIG = {
            uiColor: System.getThemeColor(),
            toolbarCanCollapse: false,
            toolbar: [
                { name: 'file', items: ['Save'] },
                { name: 'clipboard', items: ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo'] },
                { name: 'paragraph', items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl', 'Language'] },
                { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat'] },
                { name: 'links', items: ['Link', 'Unlink', 'Anchor'] },
                { name: 'insert', items: ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe'] },
                { name: 'colors', items: ['TextColor', 'BGColor'] },
                { name: 'editing', items: ['Find', 'Replace', '-', 'SelectAll', '-', 'Scayt'] },
                { name: 'forms', items: ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'] },
                { name: 'styles', items: ['Styles', 'Format', 'Font', 'FontSize'] },
                { name: 'tools', items: ['Maximize', 'ShowBlocks'] },
                { name: 'document', items: ['Source', '-', 'NewPage', 'Preview', 'Print', '-', 'Templates'] }
            ],
            height: 400,
            autoGrow_minHeight: 400,
            autoGrow_onStartup: true,
            enterMode: CKEDITOR.ENTER_DIV,
            extraPlugins: 'autogrow',
            customConfig: '' // avoid loading an external configuration file
        };

        // load extra plugins not available by default

        // modify the save plugin of the ckeditor to allow Ajax submit
        CKEDITOR.plugins.registered.save = {
            icons: 'save',
            hidpi: true,
            init: function (editor) {
                var pluginName = 'save';

                // Save plugin is for replace mode only.
                if (editor.elementMode !== CKEDITOR.ELEMENT_MODE_REPLACE)
                    return;

                var command = editor.addCommand(pluginName, {
                    modes: { wysiwyg: !!(editor.element.$.form) },
                    exec: function (editor) {
                        if (editor.fire(pluginName)) {
                            editor.updateElement();
                            jQuery(editor.element.$.form).submit();
                        }
                    }
                });

                editor.ui.addButton && editor.ui.addButton('Save', {
                    //label: editor.lang.save.toolbar,
                    label: 'Save',
                    command: pluginName,
                    toolbar: 'document,10'
                });
            }
        };
    }
    //----------------------------------------------------------------

    System.jqGridDefaultColumnChooserOptions = {
        caption: "",
        title: "Show/Hide Columns",
        buttonicon: "fa-table",
        onClickButton: function () {
            jQuery(this).jqGrid('columnChooser', {
                width: 550,
                height: $(window).height(),
                msel_opts: { dividerLocation: 0.5 },
                dialog_opts: {
                    maxHeight: $(window).height(),
                    open: function () {
                        $(this).dialog('option', 'maxHeight', $(window).height());
                    }
                },
                modal: true
            });

            var actions = $("#colchooser_" + $.jgrid.jqID(this.id) + ' div.available>div.actions');
            actions.prepend('<label style="float:left;position:relative;margin-left:0.6em;top:0.6em">Search:</label>');
            actions.find('input').css({ 'margin-top': '0.6em' });
        },
        position: "last"
    };

    System.getJqGridDefaultDatePicker = function (element, options) {
        if (typeof options === 'undefined') {
            options = {};
        }

        return $(element).datepicker($.extend({
            // note: the date parser looks for '-' format
            dateFormat: "yy-mm-dd",
            constrainInput: false, // allows to embed extra text information
            autoSize: false,
            changeYear: true,
            changeMonth: true,
            showButtonPanel: true,
            showWeek: true
        }, options)).attr('type', 'text'); // change type to 'text' to disable native datepicker in Google Chrome
    };

    // make sure that you have the element compiled with angularJS, or else it will not work
    System.jqGridCellAttrAddTimeago = function (rowId, tv, rowObject, cm, rdata, cellvalue) {
        // stop processing if there is no date/time given
        if (typeof (cellvalue) === 'undefined') {
            return '';
        }

        var attributes = [];

        // The subtraction returns the difference between the two dates in milliseconds
        // 36e5 is the scientific notation for 60*60*1000
        // Note: the date string should be in this format 'yyyy/mm/dd hh:mm:ss',
        // and to make a yyyy-mm-dd hh:mm:ss formatted date string fully browser
        // compatible you would have to replace dashes with slashes
        var hours = Math.abs(new Date() - new Date(cellvalue)) / 36e5;

        // add timeago only if it is less than 24 hours
        if (hours < 24 || true) {
            attributes.push('class="time-ago" title="');
            attributes.push(typeof (cellvalue) !== 'undefined' ? cellvalue : tv);
            attributes.push('"');
        }

        return attributes.join('');
    };

    System.compileWithAngujarJs = function (element, scope) {
        // compile the raw html with AngularJs using the root scope, if defined
        angular.injector(['app']).invoke(['$rootScope', '$compile', function ($rootScope, $compile) {
            if (typeof scope !== 'undefined') {
                $compile(element)(scope);
            } else {
                $compile(element)($rootScope);
            }
        }]);
    };

    System.jqGridEnableAutoRefresh = function (parameters) {
        if (typeof parameters === 'undefined') {
            return;
        }

        if (typeof parameters.grid === 'undefined') {
            return;
        }

        if (parameters.grid.data('jqGridAutoRefresh') === true) {
            return;
        }

        parameters.grid.data('jqGridAutoRefresh', true);

        schedule();

        function schedule() {
            setTimeout(function () {
                var isGridStateVisible = parameters.grid
                    .jqGrid("getGridParam", "gridstate") === 'visible';

                if (parameters.grid.is(":visible") && isGridStateVisible) {
                    parameters.grid.trigger("reloadGrid", [{ page: 1 }]);
                }

                // schedule the next timeout
                schedule();
            }, parameters.timeout);
        }
    };

    System.notify = function (message, title, type) {
        console.log(message);

        // do nothing if there is no PNotify loaded
        if (typeof PNotify === 'undefined') {
            return;
        }

        if (typeof title === 'undefined') {
            title = "Notice";
        }

        new PNotify({
            title: title,
            text: message,
            type: type
        });
    };

    System.formatBytes = function (bytes, decimals) {
        if (bytes == 0) {
            return '0 Byte';
        }

        var k = 1024; // 1024 for binary
        var dm = decimals + 1 || 3;
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
        var i = Math.floor(Math.log(bytes) / Math.log(k));

        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    };

    // returns a unique number for this session
    System._nextUniqueID = 0;
    System.nextUniqueID = function () {
        return ++System._nextUniqueID;
    };
}

(function () {
    "use strict";

    System.angular.controller('SystemController',
    ['$scope', '$http', '$timeout', function ($scope, $http, $timeout) {

    }])
    .directive('importMailsList', function () {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                var tableName = "import-mails-list-" + System.nextUniqueID();
                var options = scope.$eval(attr.importMailsList);
                var $table = $(element);

                $table.attr('ID', tableName);

                $table.jqGrid($.extend({
                    caption: '<i class="fa fa-envelope-o"></i>&nbsp;Mail Sources',
                    url: $table.data('url'),
                    editurl: $table.data('url'),
                    datatype: "json",
                    colNames: [
                        'ID', 'Contact ID', 'Type', 'Repeat', 'Hostname', 'Username', 'Password',
                        'Port', 'SSL', 'Skip SSL Validation', 'Mailbox', 'Start Date Scan', 'End Date Scan',
                        'PageSize', 'OffSet', 'Status', '# Message', 'Processed', 'Last Processed Id', 'Last Processed Date'
                    ],
                    colModel: [
                        { name: 'ID', width: 20, editable: false, key: true, hidden: true },
                        { name: 'ContactID', width: 20, editable: false, hidden: true },
                        { name: 'Type', width: 40, editable: true, maxlength: 50, sortable: true, editrules: { required: true, edithidden: true }, edittype: "select", editoptions: { value: ':;IMAP:IMAP;POP3:POP3;Exchange:Exchange;Exchange Journal:Exchange Journal' } },
                        { name: 'Recursive', width: 30, search: true, searchoptions: { searchhidden: true }, sortable: true, align: 'center', formatter: 'checkbox', editable: true, edittype: "checkbox", editrules: { edithidden: true }, editoptions: { value: "true:false", defaultValue: "true" } },
                        { name: 'Hostname', width: 80, editable: true, maxlength: 50, sortable: true, editrules: { required: true, edithidden: true } },
                        { name: 'Username', width: 80, editable: true, maxlength: 50, sortable: true, editrules: { required: true, edithidden: true } },
                        { name: 'Password', width: 80, editable: true, maxlength: 50, sortable: true, editrules: { required: true, edithidden: true }, edittype: "password" },
                        { name: 'Port', width: 30, editable: true, sorttype: "int", searchtype: 'integer', searchoptions: { sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] } },
                        { name: 'SSL', width: 30, formatter: 'checkbox', sortable: true, align: 'center', editable: true, edittype: "checkbox", editoptions: { value: "true:false" } },
                        { name: 'SkipSslValidation', width: 30, formatter: 'checkbox', sortable: true, align: 'center', editable: true, edittype: "checkbox", editoptions: { value: "true:false" } },
                        { name: 'MailboxName', width: 80, hidden: true, editable: true, sortable: true },
                        { name: 'ScanFromDate', width: 20, hidden: true, sortable: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'], dataInit: System.getJqGridDefaultDatePicker }, editable: true, editrules: { edithidden: true }, editoptions: { dataInit: System.getJqGridDefaultDateTimePicker } },
                        { name: 'ScanToDate', width: 20, hidden: true, sortable: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'], dataInit: System.getJqGridDefaultDatePicker }, editable: true, editrules: { edithidden: true }, editoptions: { dataInit: System.getJqGridDefaultDateTimePicker } },
                        { name: 'PageSize', width: 50, hidden: true, editable: true, sorttype: "int", searchtype: 'integer', searchoptions: { sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] } },
                        { name: 'OffSet', width: 50, editable: false, sorttype: "int", searchtype: 'integer', searchoptions: { sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] } },
                        { name: 'Status', width: 80, hidden: true, editable: false, sortable: false },
                        { name: 'MessageCount', width: 50, editable: false, sorttype: "int", searchtype: 'integer', searchoptions: { sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] } },
                        { name: 'LastSeenId', width: 30, hidden: true, editable: false, sorttype: "int", searchtype: 'integer', searchoptions: { sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] } },
                        { name: 'LastSeenMessageId', width: 30, hidden: true, editable: false, sortable: true, search: true, searchoptions: { searchhidden: true } },
                        { name: 'LastSeenMessageDate', width: 30, hidden: true, editable: false, sortable: true, search: true, searchoptions: { searchhidden: true } }
                    ],
                    rowNum: 10,
                    rowList: [10, 20, 30, 50, 100, 200, 500, 1000],
                    pager: true,
                    sortname: 'Type',
                    sortorder: "asc",
                    viewrecords: true,
                    autowidth: true,
                    gridview: false, // required for afterInsertRow event
                    height: 'auto',
                    mtype: 'GET',
                    jsonReader: {
                        root: "rows",
                        page: "page",
                        total: "total",
                        records: "records",
                        repeatitems: false,
                        userdata: "userdata"
                    },
                    gridComplete: function () {
                        // resize the grid when window's resize event triggers
                        $.jgrid.resizeOnWindowResizeEvent($(this));

                        // refresh every 10 minutes
                        System.jqGridEnableAutoRefresh({ grid: $(this), timeout: 10 * 60000 });

                        // trigger resize to make sure the grids
                        // are expanded to full width when switch tabs
                        $(window).trigger('resize');
                    }
                }, options)).jqGrid('navGrid',
                   { search: false, view: false, del: true, add: false, edit: false },
                   {}, // default settings for edit
                   {}, // default settings for add
                   {}, // delete instead that del:false we need this
                   {}, // search options
                   {} /* view parameters*/
                ).jqGrid('inlineNav', {
                    addParams: {
                        rowID: '00000000-0000-0000-0000-000000000000',
                        addRowParams: {
                            extraparam: {},
                            aftersavefunc: function () {
                                $table.trigger("reloadGrid");
                            }
                        }
                    },
                    editParams: {
                        aftersavefunc: function () {
                            $table.trigger("reloadGrid");
                        }
                    }
                }).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions);
            }
        };
    });

    System.angular.controller('EmailMessageController',
    ['$scope', '$element', '$http', '$timeout',
    function ($scope, $element, $http, $timeout) {
        $.extend($scope, $element.data('view-model'));
    }]);

    System.angular.controller('ContactDetailController',
    ['$scope', '$element', '$http', '$timeout',
        function ($scope, $element, $http, $timeout) {
            $.extend($scope, $element.data('view-model'));
        }
    ])
    .directive('contactEmailsList', function () {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                var tableName = "contact-emails-list-" + System.nextUniqueID();
                var options = scope.$eval(attr.contactEmailsList);
                var $table = $(element);

                $table.attr('ID', tableName);

                $table.jqGrid($.extend({
                    caption: '<i class="fa fa-envelope-o"></i>&nbsp;E-mail Addresses',
                    url: $table.data('url'),
                    editurl: $table.data('url'),
                    datatype: "json",
                    colNames: [
                        'ID', 'Contact ID', 'E-mail Address'
                    ],
                    colModel: [
                        { name: 'ID', width: 10, editable: false, key: true, hidden: true },
                        { name: 'ContactID', width: 10, editable: false, hidden: true },
                        { name: 'E_mail_Address', width: 30, editable: true, sortable: true, search: true, searchoptions: { searchhidden: true } }
                    ],
                    rowNum: 10,
                    rowList: [10, 20, 30, 50, 100, 200, 500, 1000],
                    pager: true,
                    sortname: 'E_mail_Address',
                    sortorder: "asc",
                    viewrecords: true,
                    autowidth: true,
                    gridview: false, // required for afterInsertRow event
                    height: 'auto',
                    mtype: 'GET',
                    jsonReader: {
                        root: "rows",
                        page: "page",
                        total: "total",
                        records: "records",
                        repeatitems: false,
                        userdata: "userdata"
                    },
                    gridComplete: function () {
                        // resize the grid when window's resize event triggers
                        $.jgrid.resizeOnWindowResizeEvent($(this));
                    }
                }, options)).jqGrid('navGrid',
                    { search: false, view: false, del: true, add: false, edit: false },
                    {}, // default settings for edit
                    {}, // default settings for add
                    {}, // delete instead that del:false we need this
                    {}, // search options
                    {} /* view parameters*/
                    ).jqGrid('inlineNav', {
                        addParams: {
                            rowID: 0,
                            addRowParams: {
                                extraparam: {},
                                aftersavefunc: function () {
                                    $table.trigger("reloadGrid");
                                }
                            }
                        },
                        editParams: {
                            aftersavefunc: function () {
                                $table.trigger("reloadGrid");
                            }
                        }
                    }).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions);
            }
        };
    });

    System.angular.directive('systemLogs',
    ['$compile', '$timeout', function ($compile, $timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attributes) {
                var parameters = $.extend({
                    tableid: '#' + element[0].id,
                }, scope.$eval(attributes.systemLogs));
                var pause = false;
                var $caption = typeof parameters.caption === 'undefined'
                    ? 'System Logs' : parameters.caption;
                var rowid = 0; // row counter
                var rowsLimit = 100;

                $timeout(function () {
                    var $table = $(parameters.tableid);

                    // construct the row limit selector
                    var rowLimitSelector = $('select', $table.next());

                    $table.jqGrid({
                        caption: $caption,
                        datatype: 'local',
                        colNames: [
                            'Row ID', 'Date', 'Level', 'Hostname', 'Logger', 'Thread',
                            'Identity', 'Domain', 'User', 'Message', 'Exception'
                        ],
                        colModel: [
                            { name: 'RowID', width: 60, fixed: true, sortable: true, key: true, hidden: true },
                            { name: 'TimeStamp', width: 120, fixed: true, sortable: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'], dataInit: System.getJqGridDefaultDatePicker }, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'D M d Y h:i:s A' }, cellattr: function (rowId, tv, rowObject, cm, rdata) { return System.jqGridCellAttrAddTimeago(rowId, tv, rowObject, cm, rdata, rowObject.TimeStamp); } },
                            { name: 'Level', width: 60, fixed: true, sortable: true, search: true, stype: "select", searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'nu', 'nn'], value: ":;Off:Off;Fatal:Fatal;Error:Error;Warn:Warn;Info:Info;Debug:Debug;All:All" } },
                            { name: 'Hostname', width: 30, sortable: false },
                            { name: 'LoggerName', width: 30, sortable: true },
                            { name: 'ThreadName', width: 30, sortable: true, hidden: true, search: true, searchoptions: { searchhidden: true } },
                            { name: 'Identity', width: 30, sortable: true, hidden: true, search: true, searchoptions: { searchhidden: true } },
                            { name: 'Domain', width: 30, sortable: true, hidden: true, search: true, searchoptions: { searchhidden: true } },
                            { name: 'UserName', width: 30, sortable: true, hidden: true, search: true, searchoptions: { searchhidden: true } },
                            { name: 'Message', width: 180, sortable: false, formatter: function (v) { return '<div>' + $.jgrid.htmlEncode(v) + '</div>'; } },
                            { name: 'ExceptionString', width: 180, sortable: false, hidden: true, search: true, searchoptions: { searchhidden: true }, formatter: function (v) { return '<div>' + $.jgrid.htmlEncode(v) + '</div>'; } }
                        ],
                        pager: true,
                        rowList: [], // disable page size dropdown
                        pgbuttons: false, // disable page control like next, back button
                        pgtext: null, // disable pager text like 'Page 0 of 10'
                        sortname: 'RowID',
                        viewrecords: true,
                        sortorder: "asc",
                        autowidth: true,
                        height: 'auto',
                        multiselect: false,
                        afterAddRow: function (add) {
                            var params = $table[0].p;

                            // starting 1.4.9, event afterInsertRow is not called after addRowData
                            // must manually call the function using this new afterAddRow event
                            if ($.isFunction(params.afterInsertRow)) {
                                params.afterInsertRow(add.inputData[0].RowID, add.inputData[0]);
                            }
                        },
                        afterInsertRow: function (rowid, loggedEvent, rowelem) {
                            var htmlRow = $($table.jqGrid('getInd', rowid, true));
                            var level = loggedEvent.Level.toLowerCase();

                            // format level for the row
                            switch (level) {
                                case "error":
                                case "fatal":
                                    htmlRow.addClass('danger');
                                    break;
                                case "warn":
                                    htmlRow.addClass('warning');
                                    break;
                                case "debug":
                                    htmlRow.addClass('info');
                                    break;
                                default:
                                    break;
                            }

                            // compile the raw HTML with AngularJs using the root scope
                            System.compileWithAngujarJs(htmlRow);
                        },
                        loadComplete: function (data) {

                        },
                        gridComplete: function () {
                            var tid = parameters.tableid.substring(1); // table id

                            // move the rows limit select to the center of the grid's bottom bar
                            $($table[0].p.pager + '_center').append(
                                rowLimitSelector.on('change', function () {
                                    $table.jqGrid("clearGridData");
                                    // reset the row limit value
                                    rowid = 0;
                                    rowsLimit = this.value;
                                }).parent()
                            ).css('white-space', 'initial'); /* correct the pager height */

                            // allow grid to show Bootstrap's contextual classes
                            $table.addClass('table');

                            // resize the grid when window's resize event triggers
                            $.jgrid.resizeOnWindowResizeEvent($(this));

                            var log4net = $.connection.signalrAppenderHub;

                            log4net.client.onLoggedEvent = function (loggedEvent) {
                                // skip processing if in pause state
                                if (pause) { return; }

                                rowid = ++rowid % rowsLimit; // increase the row counter

                                // delete the old row to keep them within the limit
                                $table.jqGrid('delRowData', rowid);

                                // insert the new data to the top of the grid
                                $table.jqGrid('addRowData', rowid, $.extend(
                                    loggedEvent, { RowID: rowid }), "last");

                                // keep scrolling to the end
                                var $scroll_table = $('#gview_' + tid).find('.ui-jqgrid-bdiv');
                                $scroll_table.scrollTop($scroll_table[0].scrollHeight);
                            };

                            //$.connection.hub.logging = true; // turn signalr console logging on/off

                            $.connection.hub.start({ transport: ['longPolling', 'webSockets'] });
                        }
                    }).jqGrid('navGrid',
                        { search: true, view: true, del: false, add: false, edit: false },
                        {}, // default settings for edit
                        {}, // default settings for add
                        {}, // delete instead that del:false we need this
                        { // create the searching dialog
                            multipleSearch: true,
                            multipleGroup: true,
                            recreateFilter: true,
                            sopt: [
                                'cn', 'nc', 'eq', 'ne', 'lt', 'le', 'gt', 'ge',
                                'bw', 'bn', 'in', 'ni', 'ew', 'en', 'nu', 'nn'
                            ],
                            showQuery: true,
                            overlay: false,
                            drag: false,
                            resize: false,
                            afterShowSearch: function () {
                                var tid = parameters.tableid.substring(1);

                                var $searchDialog = $.jgrid.placeSearchDialogAboveGrid({
                                    tableid: parameters.tableid,
                                    searchOnEnter: true,
                                    displaySearchDialogCloseButton: true
                                }).searchDialog;
                            }
                        }, // search options
                        {} /* view parameters*/
                    ).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions)
                    .jqGrid('navButtonAdd', {
                        caption: "",
                        title: "Clear the whole list",
                        buttonicon: "fa-trash",
                        onClickButton: function () {
                            $table.jqGrid('clearGridData');
                        },
                        position: "first"
                    })
                    .jqGrid('navButtonAdd', {
                        caption: "",
                        title: "Pause the log",
                        buttonicon: "fa-pause",
                        onClickButton: function (parameters, event) {
                            togglePause(event);
                        },
                        position: "first"
                    })
                    .jqGrid('filterToolbar', {
                        stringResult: true,
                        searchOnEnter: false,
                        defaultSearch: 'cn'
                    });
                });

                $('span.number').number(true);

                function togglePause(event) {
                    pause = !pause;

                    var $target = $(event.target);

                    // change the play/pause icon of the button
                    if (pause) {
                        $target
                            .removeClass('fa-pause')
                            .addClass('fa-play');
                    } else {
                        $target
                            .removeClass('fa-play')
                            .addClass('fa-pause');
                    }

                    showCaption(pause ? "<b class='ui-state-highlight'>PAUSING</b>" : "");
                }

                function showCaption(msg) {
                    var caption = [];
                    var holder = $('.ui-jqgrid-title',
                        '#gview_' + $.jgrid.jqID(element[0].id));

                    caption.push($caption);
                    caption.push('&nbsp;');
                    caption.push(msg);

                    holder.html(caption.join(''));
                }
            }
        };
    }]);

    System.angular.directive('mailsList',
    ['$sce', '$compile', '$timeout', function ($sce, $compile, $timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                var tableName = "mails-list-" + System.nextUniqueID();
                var options = scope.$eval(attr.mailsList);
                var $table = $(element);

                var moveToBoxes = $table.data('move-to-boxes');
                var moveToUrl = $table.data('move-to-url');
                var requestSpamCheckUrl = $table.data('request-spam-check-url');

                $table.attr('ID', tableName);

                $table.jqGrid($.extend({
                    caption: '<i class="fa fa-envelope-o"></i>&nbsp;Mailbox',
                    url: $table.data('url'),
                    datatype: "json",
                    colNames: [
                        'ID', 'Date/Time', 'Message ID', 'From Address', 'From', 'To Addresses',
                        'To', 'CC', 'Subject', 'Body Type', 'Body', 'Attachments'
                    ],
                    colModel: [
                        { name: 'ID', width: 50, fixed: true, editable: false, key: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] }, formatter: emailDetailFormatter },
                        { name: 'date_time', width: 120, fixed: true, sortable: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'], dataInit: System.getJqGridDefaultDatePicker }, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'D M d Y h:i:s A' }, cellattr: function (rowId, tv, rowObject, cm, rdata) { return System.jqGridCellAttrAddTimeago(rowId, tv, rowObject, cm, rdata, rowObject.date_time); } },
                        { name: 'message_id', width: 10, editable: false, hidden: true, search: true, searchoptions: { searchhidden: true } },
                        { name: 'sender_address', width: 10, editable: false, hidden: true, search: true, searchoptions: { searchhidden: true } },
                        { name: 'sender_name', width: 10, editable: false },
                        { name: 'recipient_address', width: 10, editable: false, hidden: true, search: true, searchoptions: { searchhidden: true } },
                        { name: 'display_to', width: 10, editable: false },
                        { name: 'display_cc', width: 10, editable: false, hidden: true, viewable: true, editrules: { edithidden: true }, search: true, searchoptions: { searchhidden: true } },
                        { name: 'message_subject', width: 80, editable: false, cellattr: cellattrBody, formatter: subjectFormatter },
                        { name: 'message_body_type', width: 5, editable: false, hidden: true, viewable: true, editrules: { edithidden: true }, search: true, searchoptions: { searchhidden: true } },
                        { name: 'message_body_text', width: 40, editable: false, hidden: true, viewable: true, editrules: { edithidden: true }, search: true, searchoptions: { searchhidden: true }, cellattr: cellattrBody, formatter: bodyFormatter },
                        { name: 'attachments', width: 10, editable: false, hidden: true, viewable: true, editrules: { edithidden: true }, search: true, searchoptions: { searchhidden: true } }
                    ],
                    rowNum: 20,
                    rowList: [5, 10, 20, 30, 50, 100, 200, 500, 1000, 5000, 10000],
                    pager: true,
                    sortname: 'date_time',
                    sortorder: 'desc',
                    viewrecords: true,
                    multiselect: true,
                    autowidth: true,
                    gridview: false, // required for afterInsertRow event
                    height: 'auto',
                    mtype: 'GET',
                    jsonReader: {
                        root: "rows",
                        page: "page",
                        total: "total",
                        records: "records",
                        repeatitems: false,
                        userdata: "userdata"
                    },
                    beforeRequest: function () {
                        $timeout(function () {
                            // show a loading icon
                            scope[$table.data('counter-name') + 'Loading'] = true;

                            // reset the record counters
                            scope[$table.data('counter-name')] = null;
                        });
                    },
                    loadComplete: function (data) {
                        $timeout(function () {
                            // hide the loading icon
                            scope[$table.data('counter-name') + 'Loading'] = false;

                            // update the record counters
                            scope[$table.data('counter-name')] = data.records;
                        });
                    },
                    gridComplete: function () {
                        // resize the grid when window's resize event triggers
                        $.jgrid.resizeOnWindowResizeEvent($(this));

                        // refresh every 10 minutes
                        System.jqGridEnableAutoRefresh({ grid: $(this), timeout: 10 * 60000 });

                        // trigger resize to make sure the grids
                        // are expanded to full width when switch tabs
                        $(window).trigger('resize');
                    }
                }, options))
                .jqGrid('navGrid',
                   { search: true, view: true, del: false, add: false, edit: false },
                   {}, // default settings for edit
                   {}, // default settings for add
                   {}, // delete instead that del:false we need this
                   { // create the searching dialog
                       multipleSearch: true,
                       multipleGroup: true,
                       recreateFilter: true,
                       sopt: [
                           'cn', 'nc', 'eq', 'ne', 'lt', 'le', 'gt', 'ge',
                           'bw', 'bn', 'in', 'ni', 'ew', 'en', 'nu', 'nn'
                       ],
                       showQuery: true,
                       overlay: false,
                       drag: false,
                       resize: false,
                       afterShowSearch: function () {
                           var $searchDialog = $.jgrid.placeSearchDialogAboveGrid({
                               tableid: '#' + tableName,
                               searchOnEnter: true,
                               displaySearchDialogCloseButton: true
                           }).searchDialog;
                       }
                   }, // search options
                   {} /* view parameters*/
                ).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions);

                $.jgrid.addExportToCSVButton($table);

                if (typeof moveToBoxes !== 'undefined' && typeof moveToUrl !== 'undefined') {
                    $.each(moveToBoxes.split(","), function (index, mailBox) {
                        var button_id = 'move-to-box-button-' + System.nextUniqueID();

                        mailBox = mailBox.trim();

                        var buttonicon = "fa-comments";
                        if (mailBox === 'Junk') {
                            buttonicon = "fa-trash";
                        } else if (mailBox === 'Promotion') {
                            buttonicon = "fa-bullhorn";
                        }

                        $table.jqGrid('navButtonAdd', {
                            id: button_id,
                            caption: "",
                            title: "Move selected to " + mailBox + " box",
                            buttonicon: buttonicon,
                            onClickButton: function () {
                                var selectedRows = $table.jqGrid('getGridParam', 'selarrrow');

                                var button_icon = $('.fa', $('#' + button_id)).removeClass(buttonicon)
                                    .addClass('fa-spinner').addClass('fa-spin');

                                var posting = $.post(moveToUrl, {
                                    selectedRows: selectedRows,
                                    mailBox: mailBox
                                }, function () {
                                    $table.trigger("reloadGrid");
                                });

                                posting.always(function () {
                                    button_icon.addClass(buttonicon)
                                        .removeClass('fa-spin')
                                        .removeClass('fa-spinner');
                                });
                            },
                            position: "last"
                        });
                    });

                }

                if (typeof requestSpamCheckUrl !== 'undefined') {
                    var button_id = 'request-spam-check-button-' + System.nextUniqueID();
                    var buttonicon = "fa-balance-scale";

                    $table.jqGrid('navButtonAdd', {
                        id: button_id,
                        caption: "",
                        title: "Schedule spam check for selected messages",
                        buttonicon: buttonicon,
                        onClickButton: function () {
                            var selectedRows = $table.jqGrid('getGridParam', 'selarrrow');

                            var button_icon = $('.fa', $('#' + button_id)).removeClass(buttonicon)
                                .addClass('fa-spinner').addClass('fa-spin');

                            var posting = $.post(requestSpamCheckUrl, {
                                selectedRows: selectedRows
                            }, function () {
                                $table.trigger("reloadGrid");
                            });

                            posting.always(function () {
                                button_icon.addClass(buttonicon)
                                    .removeClass('fa-spin')
                                    .removeClass('fa-spinner');
                            });
                        },
                        position: "last"
                    });
                }

                function cellattrBody(rowId, tv, rowObject, cm, rdata) {
                    return 'ng-non-bindable="" class="mail-body"';
                }

                function bodyFormatter(cellvalue, formatoptions, rowObject) {
                    var result = [];

                    result.push('<pre>');
                    result.push($.jgrid.htmlEncode(cellvalue));
                    result.push('</pre>');

                    return result.join('');
                }

                function subjectFormatter(cellvalue, formatoptions, rowObject) {
                    var result = [];

                    result.push(cellvalue);

                    if (rowObject.message_body_text !== null) {
                        var bodyText = $.jgrid.htmlEncode(rowObject.message_body_text);
                        bodyText = bodyText.replace(/\"/g, "'");

                        result.push('&nbsp;-&nbsp;<pre title="');
                        result.push(bodyText);
                        result.push('">');
                        result.push(bodyText);
                        result.push('</pre>');
                    }

                    return result.join('');
                }

                function emailDetailFormatter(cellvalue, formatoptions, rowObject) {
                    var result = [];

                    result.push('<a target="_blank" title="Click to view the email" href="/Email/View/');
                    result.push(cellvalue);
                    result.push('">');
                    result.push(cellvalue);
                    result.push('</a>');

                    return result.join('');
                }
            }
        };
        }]);

    System.angular.directive('contactsList',
    ['$sce', '$compile', '$timeout', function ($sce, $compile, $timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                var tableName = "contacts-list-" + System.nextUniqueID();
                var options = scope.$eval(attr.contactsList);
                var $table = $(element);

                $table.attr('ID', tableName);

                $table.jqGrid($.extend({
                    caption: '',
                    url: $table.data('url'),
                    editurl: $table.data('url'),
                    datatype: "json",
                    colNames: [
                        'ID', 'Name', 'First Name', 'Last Name', 'Notes'
                    ],
                    colModel: [
                        { name: 'ID', width: 50, fixed: true, editable: false, key: true, search: true, searchoptions: { searchhidden: true, sopt: ['eq', 'ne', 'lt', 'le', 'gt', 'ge'] }, formatter: contactDetailFormatter },
                        { name: 'Name', width: 10, editable: false, hidden: true, search: true, searchoptions: { searchhidden: true } },
                        { name: 'First_Name', width: 10, editable: true },
                        { name: 'Last_Name', width: 10, editable: true },
                        { name: 'Notes', width: 30, editable: true, editrules: { edithidden: true }, edittype: "textarea", editoptions: { rows: "2", cols: "40" } }
                    ],
                    rowNum: 20,
                    rowList: [5, 10, 20, 30, 50, 100, 200, 500, 1000, 5000, 10000],
                    pager: true,
                    sortname: 'Last_Name',
                    sortorder: 'asc',
                    viewrecords: true,
                    autowidth: true,
                    gridview: false, // required for afterInsertRow event
                    height: 'auto',
                    mtype: 'GET',
                    jsonReader: {
                        root: "rows",
                        page: "page",
                        total: "total",
                        records: "records",
                        repeatitems: false,
                        userdata: "userdata"
                    },
                    beforeRequest: function () {

                    },
                    loadComplete: function (data) {

                    },
                    gridComplete: function () {
                        // resize the grid when window's resize event triggers
                        $.jgrid.resizeOnWindowResizeEvent($(this));

                        // trigger resize to make sure the grids
                        // are expanded to full width when switch tabs
                        $(window).trigger('resize');
                    }
                }, options))
                    .jqGrid('navGrid',
                    { search: true, view: false, del: true, add: false, edit: false },
                    {}, // default settings for edit
                    {}, // default settings for add
                    {}, // delete instead that del:false we need this
                    { // create the searching dialog
                        multipleSearch: true,
                        multipleGroup: true,
                        recreateFilter: true,
                        sopt: [
                            'cn', 'nc', 'eq', 'ne', 'lt', 'le', 'gt', 'ge',
                            'bw', 'bn', 'in', 'ni', 'ew', 'en', 'nu', 'nn'
                        ],
                        showQuery: true,
                        overlay: false,
                        drag: false,
                        resize: false,
                        afterShowSearch: function () {
                            var $searchDialog = $.jgrid.placeSearchDialogAboveGrid({
                                tableid: '#' + tableName,
                                searchOnEnter: true,
                                displaySearchDialogCloseButton: true
                            }).searchDialog;
                        }
                    }, // search options
                    {} /* view parameters*/
                ).jqGrid('inlineNav', {
                    addParams: {
                        rowID: 0,
                        addRowParams: {
                            extraparam: {},
                            aftersavefunc: function () {
                                $table.trigger("reloadGrid");
                            }
                        }
                    },
                    editParams: {
                        aftersavefunc: function () {
                            $table.trigger("reloadGrid");
                        }
                    }
                }).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions);

                $.jgrid.addExportToCSVButton($table);

                function contactDetailFormatter(cellvalue, formatoptions, rowObject) {
                    var result = [];

                    result.push('<a target="_blank" title="Click to view the contact detail" href="/Contact/Detail/');
                    result.push(cellvalue);
                    result.push('">');
                    result.push(cellvalue);
                    result.push('</a>');

                    return result.join('');
                }
            }
        };
        }]);

    System.angular.directive('spamScoreList',
    ['$sce', '$compile', '$timeout', function ($sce, $compile, $timeout) {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                var tableName = "spam-score-list-" + System.nextUniqueID();
                var options = scope.$eval(attr.spamScoreList);
                var $table = $(element);
                var url = $table.data('url');

                $table.attr('ID', tableName);

                $timeout(function () {
                    // show a loading icon
                    scope[$table.data('counter-name') + 'Loading'] = true;

                    // reset the record counters
                    scope[$table.data('counter-name')] = null;
                });

                $.getJSON(url, function (data) {
                    $table.jqGrid($.extend({
                        caption: '',
                        data: data,
                        datatype: "local",
                        colNames: [
                            'Rule', 'Score', 'Description'
                        ],
                        colModel: [
                            { name: 'Rule', width: 20, key: true },
                            { name: 'Score', width: 10, template: "number" },
                            { name: 'Description', width: 30 }
                        ],
                        rowNum: 20,
                        rowList: [5, 10, 20, 30, 50, 100, 200, 500, 1000, 5000, 10000],
                        pager: true,
                        sortname: 'Score',
                        sortorder: 'desc',
                        viewrecords: true,
                        autowidth: true,
                        gridview: false, // required for afterInsertRow event
                        height: 'auto',
                        footerrow: true,
                        beforeRequest: function () {

                        },
                        loadComplete: function (data) {
                            var scoreSum = $table.jqGrid('getCol', 'Score', false, 'sum');
                            $table.jqGrid('footerData', 'set', { 'Rule': 'Total', 'Score': scoreSum });

                            $timeout(function () {
                                // hide the loading icon
                                scope[$table.data('counter-name') + 'Loading'] = false;

                                // update the record counters
                                scope[$table.data('counter-name')] = scoreSum;
                            });
                        },
                        gridComplete: function () {
                            // resize the grid when window's resize event triggers
                            $.jgrid.resizeOnWindowResizeEvent($(this));

                            // trigger resize to make sure the grids
                            // are expanded to full width when switch tabs
                            $(window).trigger('resize');
                        }
                    }, options))
                        .jqGrid('navGrid',
                        { search: true, view: true, del: false, add: false, edit: false },
                        {}, // default settings for edit
                        {}, // default settings for add
                        {}, // delete instead that del:false we need this
                        { // create the searching dialog
                            multipleSearch: true,
                            multipleGroup: true,
                            recreateFilter: true,
                            sopt: [
                                'cn', 'nc', 'eq', 'ne', 'lt', 'le', 'gt', 'ge',
                                'bw', 'bn', 'in', 'ni', 'ew', 'en', 'nu', 'nn'
                            ],
                            showQuery: true,
                            overlay: false,
                            drag: false,
                            resize: false,
                            afterShowSearch: function () {
                                var $searchDialog = $.jgrid.placeSearchDialogAboveGrid({
                                    tableid: '#' + tableName,
                                    searchOnEnter: true,
                                    displaySearchDialogCloseButton: true
                                }).searchDialog;
                            }
                        }, // search options
                        {} /* view parameters*/
                        ).jqGrid('navButtonAdd', System.jqGridDefaultColumnChooserOptions);

                    $.jgrid.addExportToCSVButton($table);
                });
            }
        };
    }]);
}());