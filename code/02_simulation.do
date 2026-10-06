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
version 15.1

*--- SET THIS TO YOUR STUDENT NUMBER -------------------------
local studentid 1009412244
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
summarize tau_c
summarize tau_h
summarize tau_h if D==1

* The ATE and ATT are different because the training group is not random
* People with lower M are more likely to train, and they also get smaller effects

*--------------------------------------------------------------
* Q2. Naive observational estimate (constant world). Regress Yobs_c on D.
*     Is it above or below 1500? Explain the SIGN using the DGP.
*--------------------------------------------------------------

regress Yobs_c D

* The estimate is below 1500 because people with lower M are more likely to enter training
* M also increases earnings, so the training group would have lower earnings even without the training

*--------------------------------------------------------------
* Q3. The OVB identity. Run the short, long, and auxiliary regressions,
*     store a1, b1, b2, d1, and show a1 = b1 + b2*d1 by hand.
*     Which term is "where selection lives"? Why does controlling for M work here?
*--------------------------------------------------------------

regress Yobs_c D
scalar a1 = _b[D]

regress Yobs_c D M
scalar b1 = _b[D]
scalar b2 = _b[M]

regress M D
scalar d1 = _b[D]

display a1
display b1 + b2*d1

* d1 is the selection part
* It is negative because people with lower M are more likely to enter training
* Controlling for M works here because we can measure M in the simulation
* In real data, something like motivation may be hard to measure or observe

*--------------------------------------------------------------
* Q4. Randomize (Drand = runiform() < 0.5), form Yrand_c, and estimate.
*     Why does the same difference-in-means now recover 1500?
*--------------------------------------------------------------

gen Drand = (runiform() < 0.5)
gen Yrand_c = Drand*Y1_c + (1-Drand)*Y0

regress Yrand_c Drand

* Since training is random, the two groups should be similar before training
* The estimate is now much closer to 1500 because the selection problem is removed

*--------------------------------------------------------------
* Q5. Heterogeneous world: estimate the experimental effect on Yrand_h.
*     Which does it match -- the ATE or the ATT? What does that tell you
*     about what an experiment estimates?
*--------------------------------------------------------------

gen Yrand_h = Drand*Y1_h + (1-Drand)*Y0

regress Yrand_h Drand

* The estimate is much closer to the ATE than the ATT
* Since training is random, people are not selected into training based on M
* This means the experiment estimates the average treatment effect

*--------------------------------------------------------------
* Q6. Bad control. Generate Z = Drand + M + rnormal(0,1) -- a variable
*     measured AFTER training. Add it to your randomized regression.
*     What happens, and why is "add more controls" the wrong instinct?
*--------------------------------------------------------------

gen Z = Drand + M + rnormal(0,1)

regress Yrand_c Drand Z

* The estimate changes a lot after adding Z
* Z is measured after training and is partly affected by Drand
* Controlling for Z takes away part of what training changes
* This shows that adding more controls is not always better

di as result "02_simulation.do complete."
