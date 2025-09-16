// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(forcats)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var factor_var = getValue("drop_factor");
    echo("factor.dropped <- fct_drop(" + factor_var + ")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("DropLevels results")).print();
{
    var save_name = getValue("drop_save_obj.objectname");
      echo("rk.header(\"Factor modified and saved as: " + save_name + "\", level=3);\n");
    }
  
	//// save result object
	// read in saveobject variables
	var dropSaveObj = getValue("drop_save_obj");
	var dropSaveObjActive = getValue("drop_save_obj.active");
	var dropSaveObjParent = getValue("drop_save_obj.parent");
	// assign object to chosen environment
	if(dropSaveObjActive) {
		echo(".GlobalEnv$" + dropSaveObj + " <- factor.dropped\n");
	}

}

