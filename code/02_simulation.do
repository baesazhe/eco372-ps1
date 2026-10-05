*==============================================================
* ECO372H5F -- Problem Set 1
* 02_simulation.do : Part 1 -- selection, OVB, and randomization
*
* You build the data, so you KNOW the true treatment effect.
* The DGP below is given -- do not change it (except your seed).
* Your job is the estimation and the interpretation in the TODOs.
*==============================================================
clear all
set more off
version 17

*--- SET THIS TO YOUR STUDENT NUMBER -------------------------
local studentid 000000000
*-------------------------------------------------------------
set seed `studentid'
set obs 5000

*--------------------------------------------------------------
* The data-generating process (GIVEN -- do not change)
*--------------------------------------------------------------
gen M  = rnormal(0,1)               // 'motivation': unobserved in the real world
gen e  = rnormal(0,2000)
gen Y0 = 5000 + 2000*M + e          // untreated potential outcome

gen tau_c = 1500                    // constant treatment effect
gen Y1_c  = Y0 + tau_c
gen tau_h = 1500 + 1200*M           // heterogeneous treatment effect
gen Y1_h  = Y0 + tau_h

gen Dstar = -1.2*M + rnormal(0,1)   // the disadvantaged (low M) select into training
gen D     = (Dstar > 0.5)

gen Yobs_c = D*Y1_c + (1-D)*Y0      // what you observe (constant-effect world)
gen Yobs_h = D*Y1_h + (1-D)*Y0      // what you observe (heterogeneous world)

*--------------------------------------------------------------
* Q1. The truth. Report the true ATE (constant), and the ATE and
*     ATT (heterogeneous). Why do ATE and ATT differ here?
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q2. Naive observational estimate (constant world). Regress Yobs_c on D.
*     Is it above or below 1500? Explain the SIGN using the DGP.
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q3. The OVB identity. Run the short, long, and auxiliary regressions,
*     store a1, b1, b2, d1, and show a1 = b1 + b2*d1 by hand.
*     Which term is "where selection lives"? Why does controlling for M work here?
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q4. Randomize (Drand = runiform() < 0.5), form Yrand_c, and estimate.
*     Why does the same difference-in-means now recover 1500?
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q5. Heterogeneous world: estimate the experimental effect on Yrand_h.
*     Which does it match -- the ATE or the ATT? What does that tell you
*     about what an experiment estimates?
*--------------------------------------------------------------
* TODO

*--------------------------------------------------------------
* Q6. Bad control. Generate Z = Drand + M + rnormal(0,1) -- a variable
*     measured AFTER training. Add it to your randomized regression.
*     What happens, and why is "add more controls" the wrong instinct?
*--------------------------------------------------------------
* TODO

di as result "02_simulation.do complete."
