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

if "`c(username)'" == "Work" {
	global path "C:/Users/Work/Documents/Personal/Work/papers/GPT-Impact-GitHub"
}

if "`c(username)'" == "Alexander" {
	global path "C:/Users/Alexander/Documents/GitHub/GPT-Impact-GitHub" 
}	

cd "$path"

log using "output/analysis.log", replace

x
import delimited "output/data/data_langs.csv", clear

drop if iso2_code == "HK"

C:\Users\Alexander\Documents\GitHub\GPT-Impact-GitHub\output\tables
//----------------------------------------------------------------------------//
// main
//----------------------------------------------------------------------------//

// regressions
do "code/sub/analysis_per_lang.do"

import delimited "output/data/pushes.csv", clear

drop if iso2_code == "HK"

do "code/sub/analysis_pushes.do"


log close
