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
        var lastBracketPos = fullName.lastIndexOf('[[');
        if (lastBracketPos > -1) {
            var lastPart = fullName.substring(lastBracketPos);
            return lastPart.match(/\[\[\"(.*?)\"\]\]/)[1];
        } else if (fullName.indexOf('$') > -1) {
            return fullName.substring(fullName.lastIndexOf('$') + 1);
        } else {
            return fullName;
        }
    }
    var factor_var = getValue("main_factor");
    var func = getValue("main_func_dropdown");
    var save_name = getValue("main_save_obj.objectname");

    echo(save_name + ' <- ' + func + '(' + factor_var + ')\n');
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Reorder Factor by Property results")).print();

    if(getValue("main_save_obj") == "1"){
        var save_name = getValue("main_save_obj.objectname");
        var header_cmd = "rk.header(\"Factor reordered and saved as: " + save_name + "\");\n";
        echo(header_cmd);
    }
  
	//// save result object
	// read in saveobject variables
	var mainSaveObj = getValue("main_save_obj");
	var mainSaveObjActive = getValue("main_save_obj.active");
	var mainSaveObjParent = getValue("main_save_obj.parent");
	// assign object to chosen environment
	if(mainSaveObjActive) {
		echo(".GlobalEnv$" + mainSaveObj + " <- factor.reordered\n");
	}

}

