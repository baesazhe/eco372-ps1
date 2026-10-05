*==============================================================
* ECO372H5F -- Problem Set 1 -- master.do
* Runs the whole analysis from raw data to tables and figures.
*
* HOW TO RUN:
*   1. Open Stata in this repository's root folder, or set it:
*        cd "REPLACE/WITH/PATH/TO/ECO372_PS1"
*   2. Type:  do master.do
* Everything in output/ is regenerated from scratch.
*==============================================================
version 17
clear all
set more off

capture log close
log using "output/ps1_log.txt", replace text

do "code/01_build.do"          // raw -> clean analysis datasets
do "code/02_simulation.do"     // Part 1: simulation
do "code/03_analysis.do"       // Part 2: experiment vs OLS

log close
di as result "== master.do finished: see output/ =="
