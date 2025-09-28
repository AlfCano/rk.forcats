# rk.forcats: forcats Tools for RKWard

![Version](https://img.shields.io/badge/Version-0.1.7-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)
![R Version](https://img.shields.io/badge/R-%3E%3D%203.0.0-lightgrey.svg)

This package provides a suite of RKWard plugins that create a graphical user interface for common and powerful functions from the popular `forcats` R package. It is designed to make factor manipulation—a common but often tedious task in R—more accessible and intuitive for RKWard users.

The plugins are designed to seamlessly handle factors that are standalone vectors, columns in a data frame, or even columns inside complex list objects (like those from the `survey` package).

## Features / Included Plugins

This package installs a new submenu in RKWard: **Data > Factor Tools (forcats)**, which contains the following five plugins:

*   **Reorder by Property:** Provides a simple interface for the most common reordering functions.
    *   `fct_infreq()`: Reorder by the frequency of each level.
    *   `fct_inorder()`: Reorder by the order in which levels first appear.
    *   `fct_inseq()`: Reorder by the numeric value of the levels.
    *   `fct_rev()`: Reverse the order of the levels.

*   **Reorder by Other Variable:** Reorders a factor based on the values of another variable.
    *   `fct_reorder()`: Reorder a factor by one other variable.
    *   `fct_reorder2()`: Reorder a factor by two other variables.

*   **Manually Relevel:** Provides an input field to specify exactly which levels should be moved to the front.
    *   `fct_relevel()`

*   **Shift or Shuffle Levels:** Provides tools for non-sorted reordering.
    *   `fct_shift()`: Cycle the order of levels by a set number of positions.
    *   `fct_shuffle()`: Randomize the order of the levels.

*   **Drop Unused Levels:** A utility to remove factor levels that are not present in the data.
    *   `fct_drop()`

## Requirements

1.  A working installation of **RKWard**.
2.  The R package **`forcats`**. If you do not have it, install it from the R console:
    ```R
    install.packages("forcats")
    ```
3.  The R package **`devtools`** is required for installation from the source code.
    ```R
    install.packages("devtools")
    ```

## Installation

To install the `rk.forcats` plugin package, you need the source code (e.g., by downloading it from GitHub).

1.  Open R in RKWard.
2.  Run the following commands in the R console:

```R
local({
## Preparar
require(devtools)
## Computar
  install_github(
    repo="AlfCano/rk.forcats"
  )
## Imprimir el resultado
rk.header ("Resultados de Instalar desde git")
})
```
    
3.  Restart RKWard to ensure the new menu items appear correctly.

## Usage

Once installed, all plugins can be found under the **Data > Factor Tools (forcats)** menu in RKWard.

### Example: Reordering by Frequency

1.  Load the `forcats` library and its example dataset into your R workspace:
    ```R
    library(forcats)
    data(gss_cat)
    ```
2.  Navigate to **Data > Factor Tools (forcats) > Reorder by Property**.
3.  The RKWard dialog will open. In the object browser on the left, you will see the `gss_cat` data frame.
4.  Drag the `gss_cat` object to the "Factor vector to reorder" slot on the right. The plugin will automatically detect that `gss_cat` is a data frame and show you its columns.
5.  Select the `race` column.
6.  In the "Reordering Method" dropdown, ensure **"By frequency"** is selected.
7.  In the "Save new factor as" field, you can change the name of the output object if you wish (e.g., `race.reordered`).
8.  Click **Submit**.

A new object (`race.reordered` by default) will be created in your workspace. If you inspect its levels with `levels(race.reordered)`, you will see that "White", "Black", and "Other" are now ordered by their frequency in the data, not alphabetically.

## Author

Alfonso Cano Robles (alfonso.cano@correo.buap.mx)

Assisted by Gemini, a large language model from Google.
