*==============================================================
* ECO372H5F -- Problem Set 1
* 03_analysis.do : Part 2 -- the experiment and its OLS shadow
*
* Uses data/nsw_experiment.dta and data/nsw_observational.dta
* (built by 01_build.do). Fill in the TODOs.
*==============================================================
clear all
set more off
version 17

* esttab writes your clean table (one-time install; safe to re-run)
capture which esttab
if _rc ssc install estout, replace

local ctrls age agesq education black hispanic married nodegree re74 re75

*--------------------------------------------------------------
* Q7. Balance. In the EXPERIMENT, compare trained vs controls on the
*     pre-treatment covariates. Are the groups alike? Why does that matter?
*--------------------------------------------------------------
use "data/nsw_experiment.dta", clear
* TODO (a balance table is welcome; estpost ttest ... , by(treat) then esttab)

*--------------------------------------------------------------
* Q8. Experimental benchmark. Estimate the effect on re78, with and
*     without controls. This is your credible number.
*--------------------------------------------------------------
* TODO  (eststo exp_raw: ... ; eststo exp_ctrl: ...)

*--------------------------------------------------------------
* Q9. The observational trap. In data/nsw_observational.dta, estimate the
*     effect naively, then adding controls. Compare to the experiment.
*--------------------------------------------------------------
* TODO  (eststo obs_raw: ... ; eststo obs_ctrl: ...)

*--------------------------------------------------------------
* Q10. Build ONE table with all four estimates and write it to
*      output/results.tex (esttab ... using "output/results.tex").
*      Your memo will \input this file -- do not retype the numbers.
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q11. The by-hand OVB decomposition, in the observational sample.
*      Short: re78 on treat. Long: add re75. Auxiliary: re75 on treat.
*      Show a1 = b1 + b2*d1. Which number is "where selection lives"?
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q12. One figure to output/estimates.png (and .pdf) showing the four
*      estimates against the experimental benchmark.
*--------------------------------------------------------------
* TODO

di as result "03_analysis.do complete."
