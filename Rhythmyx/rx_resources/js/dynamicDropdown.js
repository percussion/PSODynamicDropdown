
if (!perc) {
    var perc = {};
}
if (!perc.controls) perc.controls = {};
if (!perc.controls.psoOptionUpdater) perc.controls.psoOptionUpdater = {};

perc.controls.psoOptionUpdater = function(wargs) {
    this.selectUpdateGroups = [];
    this.fieldUpdateUrl = [];

    // this function is private
    function init() {
        //$([name='EditForm']).ajaxForm();
    }

    this.addSelectToUpdateGroup = function(groupname, fieldname, url) {
        var group = this.selectUpdateGroups[groupname];
        if (!group) {
            var groupArray = [];
            this.selectUpdateGroups[groupname] = groupArray;
            group = this.selectUpdateGroups[groupname];
        }
        this.fieldUpdateUrl[fieldname] = url;
        group.push(fieldname);
    };

    this.updateAllGroups = function() {
        for (i in this.selectUpdateGroups) {
            this.updateGroup(i);
        }
    };

    this.updateGroup = function(groupname) {
        var group = this.selectUpdateGroups[groupname];
        for (i in group) {
            this.selectUpdate(document.forms[0], group[i], this.fieldUpdateUrl[group[i]]);
        }
    };
    this.selectUpdate = function(form, fieldName, url) {
		var sysfields = "[name^='sys_']";
		var qstring = jQuery(form).find('select, ' + sysfields).fieldSerialize();		 
        jQuery.ajax({
            url: url + '?' + qstring, 
            success: function(data, status) {
                psoOptionUpdater.updateField(form.elements[fieldName], data);
            },
            type: "get",
			dataType: "xml"
            //formNode: form
        });

    };

    this.updateField = function(select, data) {
        var items = jQuery(data).find("PSXEntry").get();
        var oldOpts = select.options;
        var selectedValue = select.options[select.selectedIndex].value;
        var emptyValue;
        for (i = select.length - 1; i >= 0; i--) {
            if (select.options[i].value !== "") {
                select.remove(i);
            }
        }

        //alert("selected="+selectedValue);
		
        for (i = 0; i < items.length; i++) {
            var value = items[i].getElementsByTagName("Value")[0].childNodes[0].nodeValue;
            var displayText = items[i].getElementsByTagName("PSXDisplayText")[0].childNodes[0].nodeValue;
            var elOptNew = document.createElement('option');
            elOptNew.text = displayText;
            elOptNew.value = value;
            if (value == selectedValue) {
                elOptNew.selected = true;
            }

            try {
                select.add(elOptNew, null); // standards compliant; doesn't work in IE
            } catch(ex) {
                select.add(elOptNew); // IE only
            }

        }

    };

    // initialize an instance
    init();

};

var psoOptionUpdater = new perc.controls.psoOptionUpdater();
