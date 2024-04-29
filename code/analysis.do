//----------------------------------------------------------------------------//
//
// project: 
//
// do.file: analysis
//
// author(s):
//
//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
clear programs
set more off
set varabbrev off
cap log close

if "`c(username)'" == "Work" global path "C:/Users/Work/Documents/Personal/Work/papers/GPT-Impact-GitHub"	// c(username) is your computer's username

cd "$path"

log using "output/analysis.log", replace

import delimited "output/data/data.csv", clear

drop if iso2_code == "HK"


//----------------------------------------------------------------------------//
// main
//----------------------------------------------------------------------------//

// tables
	do "code/sub/analysis_tables.do"

// figures
	do "code/sub/analysis_figures.do"

// regressions
	do "code/sub/analysis_regressions.do"

log close
