local({
  # =========================================================================================
  # Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.08-1")

  package_about <- rk.XML.about(
    name = "rk.forcats",
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin package for factor manipulation using the 'forcats' library.",
      version = "0.1.6",
      url = "https://github.com/AlfCano/rk.forcats",
      license = "GPL (>= 3)"
    )
  )

  # =========================================================================================
  # Main Plugin: Reorder Factor Levels (Simple)
  # =========================================================================================

  help_main <- rk.rkh.doc(
    title = rk.rkh.title(text = "Reorder Factor Levels by Property"),
    summary = rk.rkh.summary(text = "Reorders factor levels based on their properties, such as frequency or order of appearance."),
    usage = rk.rkh.usage(text = "Select a factor vector from any object, choose a reordering method, and specify a name for the new factor object.")
  )

  main_selector <- rk.XML.varselector(id.name = "main_selector")
  main_factor_slot <- rk.XML.varslot(label = "Factor vector to reorder", source = "main_selector", required = TRUE, id.name = "main_factor")
  attr(main_factor_slot, "source_property") <- "variables"

  main_dropdown <- rk.XML.dropdown(label="Reordering Method", options=list(
    "By frequency" = list(val="fct_infreq", chk=TRUE),
    "By order of appearance" = list(val="fct_inorder"),
    "By numeric value of levels" = list(val="fct_inseq"),
    "Reverse order" = list(val="fct_rev")
  ), id.name="main_func_dropdown")

  main_save_object <- rk.XML.saveobj(label = "Save new factor as", chk = TRUE, initial = "factor.reordered", id.name = "main_save_obj")

  main_dialog_content <- rk.XML.dialog(
    label = "Reorder Factor Levels by Property",
    child = rk.XML.row(
        main_selector,
        rk.XML.col(main_factor_slot, main_dropdown, main_save_object)
    )
  )

  js_calc_main <- "
    function getColumnName(fullName) {
        if (!fullName) return \"\";
        var lastBracketPos = fullName.lastIndexOf('[[');
        if (lastBracketPos > -1) {
            var lastPart = fullName.substring(lastBracketPos);
            return lastPart.match(/\\[\\[\\\"(.*?)\\\"\\]\\]/)[1];
        } else if (fullName.indexOf('$') > -1) {
            return fullName.substring(fullName.lastIndexOf('$') + 1);
        } else {
            return fullName;
        }
    }
    var factor_var = getValue(\"main_factor\");
    var func = getValue(\"main_func_dropdown\");
    var save_name = getValue(\"main_save_obj.objectname\");

    echo('factor.reordered <- ' + func + '(' + factor_var + ')\\n');
  "
  js_print_main <- '{
        var save_name = getValue("main_save_obj.objectname");
        var header_cmd = "rk.header(\\"Factor reordered and saved as: " + save_name + "\\", level=3);\\n";
        echo(header_cmd);
    }
  '

  # =========================================================================================
  # Component 1: Reorder by Another Variable (fct_reorder/fct_reorder2)
  # =========================================================================================
  reorder_selector <- rk.XML.varselector(id.name = "reorder_selector")
  reorder_factor_slot <- rk.XML.varslot(label = "Factor to reorder (f)", source = "reorder_selector", required = TRUE, id.name = "reorder_factor")
  attr(reorder_factor_slot, "source_property") <- "variables"
  reorder_x_slot <- rk.XML.varslot(label = "Variable to order by (.x)", source = "reorder_selector", required = TRUE, id.name = "reorder_x")
  attr(reorder_x_slot, "source_property") <- "variables"
  reorder_y_slot <- rk.XML.varslot(label = "Second variable (.y, for fct_reorder2)", source = "reorder_selector", id.name = "reorder_y")
  attr(reorder_y_slot, "source_property") <- "variables"
  reorder_func_cbox <- rk.XML.cbox(label="Use two variables (fct_reorder2)", value="1", id.name="reorder_func_cbox")
  reorder_save_object <- rk.XML.saveobj(label = "Save new factor as", chk = TRUE, initial = "factor.reordered.byvar", id.name = "reorder_save_obj")

  reorder_dialog <- rk.XML.dialog(
    label = "Reorder Factor by Other Variables",
    child = rk.XML.row(
        reorder_selector,
        rk.XML.col(reorder_factor_slot, reorder_x_slot, reorder_y_slot, reorder_func_cbox, reorder_save_object)
    )
  )

  js_calc_reorder <- '
    function getColumnName(fullName) {
        if (!fullName) return "";
        var lastBracketPos = fullName.lastIndexOf("[[");
        if (lastBracketPos > -1) {
            var lastPart = fullName.substring(lastBracketPos);
            return lastPart.match(/\\[\\[\\"(.*?)\\"\\]\\]/)[1];
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
    echo(command + "\\n");
  '
  js_print_reorder <- '{
        var save_name = getValue("reorder_save_obj.objectname");
        echo("rk.header(\\"Factor reordered and saved as: " + save_name + "\\", level=3);\\n");
    }
  '

  reorder_component <- rk.plugin.component(
      "ReorderByVar",
      xml = list(dialog = reorder_dialog),
      js = list(require="forcats", calculate = js_calc_reorder, printout = js_print_reorder),
      # CORRECTED: "Data" -> "data"
      hierarchy = list("data", "Factor Tools (forcats)", "Reorder by Other Variable")
  )

  # =========================================================================================
  # Component 2: Manually Relevel (fct_relevel)
  # =========================================================================================
  relevel_selector <- rk.XML.varselector(id.name = "relevel_selector")
  relevel_factor_slot <- rk.XML.varslot(label = "Factor vector to relevel", source = "relevel_selector", required = TRUE, id.name = "relevel_factor")
  attr(relevel_factor_slot, "source_property") <- "variables"
  relevel_input <- rk.XML.input(label = "Levels to move to front (e.g., c('b', 'c'))", id.name="relevel_levels")
  relevel_save_object <- rk.XML.saveobj(label = "Save new factor as", chk = TRUE, initial = "factor.releveled", id.name = "relevel_save_obj")

  relevel_dialog <- rk.XML.dialog(
      label = "Manually Relevel Factor",
      child = rk.XML.row(
          relevel_selector,
          rk.XML.col(relevel_factor_slot, relevel_input, relevel_save_object)
      )
  )

  js_calc_relevel <- '
    var factor_var = getValue("relevel_factor");
    var levels = getValue("relevel_levels");
    var save_name = getValue("relevel_save_obj.objectname");
    if (levels) {
      echo("factor.releveled <- fct_relevel(" + factor_var + ", " + levels + ")\\n");
    }
  '
  js_print_relevel <- '{
        var save_name = getValue("relevel_save_obj.objectname");
        echo("rk.header(\\"Factor releveled and saved as: " + save_name + "\\", level=3);\\n");
    }
  '

  relevel_component <- rk.plugin.component(
      "ManualRelevel",
      xml = list(dialog = relevel_dialog),
      js = list(require="forcats", calculate = js_calc_relevel, printout = js_print_relevel),
      # CORRECTED: "Data" -> "data"
      hierarchy = list("data", "Factor Tools (forcats)", "Manually Relevel")
  )

  # =========================================================================================
  # Component 3: Shift and Shuffle
  # =========================================================================================
  shift_selector <- rk.XML.varselector(id.name = "shift_selector")
  shift_factor_slot <- rk.XML.varslot(label = "Factor vector", source = "shift_selector", required = TRUE, id.name = "shift_factor")
  attr(shift_factor_slot, "source_property") <- "variables"
  shift_func_dropdown <- rk.XML.dropdown(label="Function", options=list("Cycle levels (fct_shift)"=list(val="fct_shift", chk=TRUE), "Randomly shuffle levels (fct_shuffle)"=list(val="fct_shuffle")), id.name="shift_func")
  shift_n_spinbox <- rk.XML.spinbox(label="Number of positions to shift (n)", initial=1, id.name="shift_n")
  shift_save_object <- rk.XML.saveobj(label = "Save new factor as", chk = TRUE, initial = "factor.shifted", id.name = "shift_save_obj")

  shift_dialog <- rk.XML.dialog(
      label = "Shift or Shuffle Factor Levels",
      child = rk.XML.row(
          shift_selector,
          rk.XML.col(shift_factor_slot, shift_func_dropdown, shift_n_spinbox, shift_save_object)
      )
  )

  js_calc_shift <- '
    var factor_var = getValue("shift_factor");
    var func = getValue("shift_func");
    var n = getValue("shift_n");
    var save_name = getValue("shift_save_obj.objectname");
    var command;
    if (func == "fct_shift") {
        command = "factor.shifted <- fct_shift(" + factor_var + ", n=" + n + ")";
    } else {
        command = "factor.shifted <- fct_shuffle(" + factor_var + ")";
    }
    echo(command + "\\n");
  '
  js_print_shift <- '{
          var save_name = getValue("shift_save_obj.objectname");
        echo("rk.header(\\"Factor modified and saved as: " + save_name + "\\", level=3);\\n");
    }
  '

  shift_component <- rk.plugin.component(
      "ShiftShuffle",
      xml = list(dialog = shift_dialog),
      js = list(require="forcats", calculate = js_calc_shift, printout = js_print_shift),
      # CORRECTED: "Data" -> "data"
      hierarchy = list("data", "Factor Tools (forcats)", "Shift or Shuffle Levels")
  )

  # =========================================================================================
  # Component 4: Drop Unused Levels (fct_drop)
  # =========================================================================================
  drop_selector <- rk.XML.varselector(id.name = "drop_selector")
  drop_factor_slot <- rk.XML.varslot(label = "Factor vector to modify", source = "drop_selector", required = TRUE, id.name = "drop_factor")
  attr(drop_factor_slot, "source_property") <- "variables"
  drop_save_object <- rk.XML.saveobj(label = "Save new factor as", chk = TRUE, initial = "factor.dropped", id.name = "drop_save_obj")

  drop_dialog <- rk.XML.dialog(
      label = "Drop Unused Factor Levels",
      child = rk.XML.row(
          drop_selector,
          rk.XML.col(drop_factor_slot, drop_save_object)
      )
  )

  js_calc_drop <- '
    var factor_var = getValue("drop_factor");
    echo("factor.dropped <- fct_drop(" + factor_var + ")\\n");
  '
  js_print_drop <- '{
    var save_name = getValue("drop_save_obj.objectname");
      echo("rk.header(\\"Factor modified and saved as: " + save_name + "\\", level=3);\\n");
    }
  '

  drop_component <- rk.plugin.component(
      "DropLevels",
      xml = list(dialog = drop_dialog),
      js = list(require="forcats", calculate = js_calc_drop, printout = js_print_drop),
      # CORRECTED: "Data" -> "data"
      hierarchy = list("data", "Factor Tools (forcats)", "Drop Unused Levels")
  )

  # =========================================================================================
  # Final Plugin Skeleton Call
  # =========================================================================================
  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = main_dialog_content),
    js = list(
      require = "forcats",
      calculate = js_calc_main,
      printout = js_print_main
    ),
    rkh = list(help = help_main),
    components = list(reorder_component, relevel_component, shift_component, drop_component),
    pluginmap = list(
        name = "ReorderByProperty",
        # CORRECTED: "Data" -> "data"
        hierarchy = list("data", "Factor Tools (forcats)", "Reorder by Property")
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.forcats' with 5 plugins generated.\n\nTo complete installation:\n\n")
  cat("  rk.updatePluginMessages(plugin.dir=\"rk.forcats\")\n\n")
  cat("  devtools::install(\"rk.forcats\")\n")
})
