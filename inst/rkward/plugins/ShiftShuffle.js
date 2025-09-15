// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(forcats)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var factor_var = getValue("shift_factor");
    var func = getValue("shift_func");
    var n = getValue("shift_n");
    var save_name = getValue("shift_save_obj.objectname");
    var command;
    if (func == "fct_shift") {
        command = save_name + " <- fct_shift(" + factor_var + ", n=" + n + ")";
    } else {
        command = save_name + " <- fct_shuffle(" + factor_var + ")";
    }
    echo(command + "\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("ShiftShuffle results")).print();

    if(getValue("shift_save_obj") == "1"){
        var save_name = getValue("shift_save_obj.objectname");
        echo("rk.header(\"Factor modified and saved as: " + save_name + "\");\n");
    }
  
	//// save result object
	// read in saveobject variables
	var shiftSaveObj = getValue("shift_save_obj");
	var shiftSaveObjActive = getValue("shift_save_obj.active");
	var shiftSaveObjParent = getValue("shift_save_obj.parent");
	// assign object to chosen environment
	if(shiftSaveObjActive) {
		echo(".GlobalEnv$" + shiftSaveObj + " <- factor.shifted\n");
	}

}

