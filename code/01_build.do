*==============================================================
* ECO372H5F -- Problem Set 1
* 01_build.do : turn the two raw files into clean analysis datasets
*
* Goal: from data/raw/, produce
*   data/nsw_experiment.dta       (185 trained + 260 experimental controls)
*   data/nsw_observational.dta    (the 185 trained + the PSID comparison group)
*
* The experimental file is tidy. The PSID file is NOT -- part of the
* job is cleaning it. Fill in the TODOs. Nothing here should require
* you to type a data value by hand.
*==============================================================
clear all
set more off
version 17

*--------------------------------------------------------------
* 1. Experimental sample (already tidy)
*--------------------------------------------------------------
import delimited "data/raw/nsw_experimental.csv", clear varnames(1) case(preserve)
tempfile experimental
save `experimental'

*--------------------------------------------------------------
* 2. PSID comparison group -- clean it
*    Open data/raw/psid_comparison_raw.csv first and look at it.
*    You will need to deal with, at least:
*      - a column that is not data                (TODO: drop it)
*      - an id with stray spaces / mixed case      (TODO: tidy it)
*      - columns with non-standard names           (TODO: rename to match the experimental file)
*      - earnings stored as text like "$12,345.67" (TODO: strip $ and , then destring)
*      - some exact duplicate rows                 (TODO: remove them)
*      - no treat column                           (TODO: everyone here is a control)
*--------------------------------------------------------------
import delimited "data/raw/psid_comparison_raw.csv", clear varnames(1) ///
    case(preserve) stringcols(_all)

* TODO: your cleaning steps here


tempfile psid
save `psid'

*--------------------------------------------------------------
* 3. Build the two analysis files
*--------------------------------------------------------------
* TODO: experiment = the full experimental file -> data/nsw_experiment.dta
* TODO: observational = trained from the experiment, appended with PSID
*        -> data/nsw_observational.dta

*--------------------------------------------------------------
* 4. Derived variables (do this for BOTH files)
*    u74 = 1 if 1974 earnings are zero; u75 likewise; agesq = age^2
*--------------------------------------------------------------
* TODO


di as result "01_build.do complete."
