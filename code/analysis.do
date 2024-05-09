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

if "`c(username)'" == "ronco" global path "C:\Users\ronco\Desktop\Tesis_Nicho_Janampa\GPT-Impact-GitHub"	// c(username) is your computer's username

cd "C:\Users\ronco\Desktop\Tesis_Nicho_Janampa\GPT-Impact-GitHub"

log using "output/analysis.log", replace

import delimited "output/data.csv", clear

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
