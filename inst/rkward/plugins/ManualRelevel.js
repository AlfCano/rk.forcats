// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(forcats)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var factor_var = getValue("relevel_factor");
    var levels = getValue("relevel_levels");
    var save_name = getValue("relevel_save_obj.objectname");
    if (levels) {
      echo(save_name + " <- fct_relevel(" + factor_var + ", " + levels + ")\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("ManualRelevel results")).print();

    if(getValue("relevel_save_obj") == "1"){
        var save_name = getValue("relevel_save_obj.objectname");
        echo("rk.header(\"Factor releveled and saved as: " + save_name + "\");\n");
    }
  
	//// save result object
	// read in saveobject variables
	var relevelSaveObj = getValue("relevel_save_obj");
	var relevelSaveObjActive = getValue("relevel_save_obj.active");
	var relevelSaveObjParent = getValue("relevel_save_obj.parent");
	// assign object to chosen environment
	if(relevelSaveObjActive) {
		echo(".GlobalEnv$" + relevelSaveObj + " <- factor.releveled\n");
	}

}

