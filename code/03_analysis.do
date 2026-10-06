*==============================================================
* ECO372H5F -- Problem Set 1
* 03_analysis.do : Part 2 -- the experiment and its OLS shadow
*
* Uses data/nsw_experiment.dta and data/nsw_observational.dta
* (built by 01_build.do). Fill in the TODOs.
*==============================================================

clear all
set more off
version 15.1

* esttab writes your clean table (one-time install; safe to re-run)
capture which esttab
if _rc ssc install estout, replace

local ctrls age agesq education black hispanic married nodegree re74 re75

*--------------------------------------------------------------
* Q7. Balance. In the EXPERIMENT, compare trained vs controls on the
*     pre-treatment covariates. Are the groups alike? Why does that matter?
*--------------------------------------------------------------

use "data/nsw_experiment.dta", clear

estpost ttest age education black hispanic married nodegree re74 re75, by(treat)

esttab ., cells("mu_1 mu_2 b p")

* The two groups are mostly similar before training
* A few differences show up, but overall the groups look fairly similar
* This is what we would expect from random assignment

*--------------------------------------------------------------
* Q8. Experimental benchmark. Estimate the effect on re78, with and
*     without controls. This is your credible number.
*--------------------------------------------------------------

eststo clear

eststo exp_raw: regress re78 treat

eststo exp_ctrl: regress re78 treat `ctrls'

* The estimate changes slightly after adding controls
* This is sensible because treatment was random, so the groups were already similar before training

*--------------------------------------------------------------
* Q9. The observational trap. In data/nsw_observational.dta, estimate the
*     effect naively, then adding controls. Compare to the experiment.
*--------------------------------------------------------------

use "data/nsw_observational.dta", clear

eststo obs_raw: regress re78 treat

eststo obs_ctrl: regress re78 treat `ctrls'

* The raw observational estimate is very different from the experiment
* Adding controls changes the estimate a lot, but it is still lower than the experimental estimate

*--------------------------------------------------------------
* Q10. Build ONE table with all four estimates and write it to
*      output/results.tex (esttab ... using "output/results.tex").
*      Your memo will \input this file -- do not retype the numbers.
*--------------------------------------------------------------

esttab exp_raw exp_ctrl obs_raw obs_ctrl using "output/results.tex", ///
    replace se keep(treat)

*--------------------------------------------------------------
* Q11. The by-hand OVB decomposition, in the observational sample.
*      Short: re78 on treat. Long: add re75. Auxiliary: re75 on treat.
*      Show a1 = b1 + b2*d1. Which number is "where selection lives"?
*--------------------------------------------------------------

regress re78 treat
scalar a1 = _b[treat]

regress re78 treat re75
scalar b1 = _b[treat]
scalar b2 = _b[re75]

regress re75 treat
scalar d1 = _b[treat]

display a1
display b1 + b2*d1

* d1 shows how different the groups were before training
* The training group earned about $17,531 less in 1975 than the PSID group
* Once re75 is added, the treatment estimate changes from about -15,205 to -582
* This shows why the raw comparison was misleading

*--------------------------------------------------------------
* Q12. One figure to output/estimates.png (and .pdf) showing the four
*      estimates against the experimental benchmark.
*--------------------------------------------------------------

estimates restore exp_raw
local expraw = _b[treat]

estimates restore exp_ctrl
local expctrl = _b[treat]

estimates restore obs_raw
local obsraw = _b[treat]

estimates restore obs_ctrl
local obsctrl = _b[treat]

clear
set obs 4

generate model = _n
generate estimate = .

replace estimate = `expraw' in 1
replace estimate = `expctrl' in 2
replace estimate = `obsraw' in 3
replace estimate = `obsctrl' in 4

twoway scatter estimate model, ///
    yline(`expraw') ///
    xlabel(1 "Exp raw" 2 "Exp controls" 3 "Obs raw" 4 "Obs controls", angle(45)) ///
    ytitle("Estimated effect") ///
    xtitle("")

graph export "output/estimates.png", replace
graph export "output/estimates.pdf", replace

*--------------------------------------------------------------
* Q13. Diagnose the consultant's report
*--------------------------------------------------------------

* I would not use the $795 estimate as the true effect of training
* The experimental estimate is about $1,794 without controls and about $1,676 with controls
* These two estimates are close, which makes sense because treatment was randomly assigned
* The observational estimates are very different
* The raw observational estimate is about -$15,205, but it changes to about $795 after adding controls
* This large change suggests that the trainees and the PSID group were very different before training
* Q11 also shows this using earnings from 1975
* The training group earned about $17,531 less than the PSID group in 1975
* After re75 is added, the treatment estimate changes from about -$15,205 to -$582
* This shows that the raw estimate was heavily affected by differences between the two groups
* The main problem with the consultant's conclusion is that adding controls does not make the groups random
* Controls can adjust for differences we can measure, but there may still be other differences that are not in the data
* For that reason, I would not treat the $795 estimate as the true effect of the program
* I would tell the Ministry to rely more on the experimental results
* The experiment suggests an effect of around $1,700 and gives a more reliable comparison because treatment was random
* I would not recommend scaling back the program based only on the $795 observational estimate

di as result "03_analysis.do complete."
