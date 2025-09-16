// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(forcats)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function getColumnName(fullName) {
        if (!fullName) return "";
        var lastBracketPos = fullName.lastIndexOf("[[");
        if (lastBracketPos > -1) {
            var lastPart = fullName.substring(lastBracketPos);
            return lastPart.match(/\[\[\"(.*?)\"\]\]/)[1];
        } else if (fullName.indexOf("$") > -1) {
            return fullName.substring(fullName.lastIndexOf("$") + 1);
        } else {
            return fullName;
        }
    }
    var factor_var = getValue("reorder_factor");
    var x_var = getValue("reorder_x");
    var y_var = getValue("reorder_y");
    var use_reorder2 = getValue("reorder_func_cbox");
    var save_name = getValue("reorder_save_obj.objectname");

    var command;
    if (use_reorder2 == "1" && y_var) {
        command = "factor.reordered.byvar <- fct_reorder2(" + factor_var + ", " + x_var + ", " + y_var + ")";
    } else {
        command = "factor.reordered.byvar <- fct_reorder(" + factor_var + ", " + x_var + ")";
    }
    echo(command + "\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("ReorderByVar results")).print();
{
        var save_name = getValue("reorder_save_obj.objectname");
        echo("rk.header(\"Factor reordered and saved as: " + save_name + "\", level=3);\n");
    }
  
	//// save result object
	// read in saveobject variables
	var reorderSaveObj = getValue("reorder_save_obj");
	var reorderSaveObjActive = getValue("reorder_save_obj.active");
	var reorderSaveObjParent = getValue("reorder_save_obj.parent");
	// assign object to chosen environment
	if(reorderSaveObjActive) {
		echo(".GlobalEnv$" + reorderSaveObj + " <- factor.reordered.byvar\n");
	}

}

