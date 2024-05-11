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

import delimited "output/data/data_langs.csv", clear

drop if iso2_code == "HK"


//----------------------------------------------------------------------------//
// main
//----------------------------------------------------------------------------//

// regressions
do "code/sub/analysis_per_lang.do"

import delimited "output/data/pushes.csv", clear

drop if iso2_code == "HK"

do "code/sub/analysis_pushes.do"


log close
