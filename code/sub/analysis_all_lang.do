// cd "$path/output/figures" 

import delimited "output/csv/all_languages_panel.csv", clear

sort unique_id year quarter 
drop if iso2_code == "HK"
label var num_pushers_pc "Num pushers per 100k"


drop quarter 
rename quarter_int quarter


// categories = {
//     'High-Level, General-Purpose Languages': [
//         'Python', 'JavaScript', 'Ruby', 'PHP', 'TypeScript'
//     ],
//     'Low-Level and Systems Programming Languages': [
//         'C', 'C++', 'Rust', 'Assembly'
//     ],
//     'Statically Typed, Compiled Languages': [
//         'Java', 'C#', 'Go', 'Swift'
//     ],
//     'Functional Programming Languages': [
//         'Haskell', 'Scala', 'F#', 'Elixir'
//     ],
//     'Domain-Specific Languages (DSLs)': [
//         'SQL', 'HTML', 'CSS', 'MATLAB', 'TeX', 'Gnuplot'
//     ],
//     'Emerging and Niche Languages': [
//         'Julia', 'Kotlin', 'Dart', 'Crystal', 'Rust', 'Haskell', 'Lua', 'Racket', 'Vim Script', 'Scala', 'Elixir'
//     ],
//     'Shell Scripting Languages': [
//         'Bash', 'Zsh', 'Ksh', 'Tcsh'
//     ],
//     'Other Scripting and Automation Languages': [
//         'Perl', 'PowerShell', 'Groovy', 'Lua', 'Ruby', 'Node.js'
//     ]
// }


local high_level "Python JavaScript Ruby PHP TypeScript"
local statically "Java C# Go Swift"
local dsl "TSQL PLpgSQL HTML CSS MATLAB R"
local shell_scripting "Shell Batchfile PowerShell"


foreach lang of local high_level {

        local l`v' : variable label num_pushers_pc


eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}


****** Table with three panels 

esttab  Python_did ///
                Python_sc ///
                Python_sdid ///
                using "$path/output\tables/gpt_impact_github_high_level.tex",                         ///
                replace label booktabs                                                                   ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) ///         
                delim("&")  /// Type of column delimiter 
                nomtitle ///
                collabels(none) /// No column names within model
                keep( gpt_available_post1 ///
                        ) ///
                order(gpt_available_post1) ///
                mgroups("\shortstack{DID}" ///
                                        "\shortstack{SC}" ///
                                        "\shortstack{SDID}",  ///
                                        pattern(1 1 1)                           ///
                                        prefix(\multicolumn{@span}{c}{) suffix(}) span                       ///
                                        erepeat(\cmidrule(lr){@span})) ///
                                nomtitles                       ///
                scalars("control_mean Baseline Mean Outcome") ///
                        refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{Python} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers
        
esttab  JavaScript_did ///
                JavaScript_sc ///
                JavaScript_sdid ///
                using "$path/output\tables/gpt_impact_github_high_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{JavaScript} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Ruby_did ///
                Ruby_sc ///
                Ruby_sdid ///
                using "$path/output\tables/gpt_impact_github_high_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{Ruby} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  PHP_did ///
                PHP_sc ///
                PHP_sdid ///
                using "$path/output\tables/gpt_impact_github_high_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel D. \textbf{ \textit{PHP} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  TypeScript_did ///
                TypeScript_sc ///
                TypeScript_sdid ///
                using "$path/output\tables/gpt_impact_github_high_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel E. \textbf{ \textit{TypeScript} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 


**********************
*
**********************

local low_level "C Rust Assembly"

foreach lang of local low_level {

        local l`v' : variable label num_pushers_pc


eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}

eststo cpp_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "C++", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "C++"
        estadd scalar control_mean `r(mean)'

eststo cpp_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "C++", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "C++"
        estadd scalar control_mean `r(mean)'

eststo cpp_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "C++", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "C++"
        estadd scalar control_mean `r(mean)'

****** Table with three panels 

esttab  C_did ///
                C_sc ///
                C_sdid ///
                using "$path/output\tables/gpt_impact_github_low_level.tex",                         ///
                replace label booktabs                                                                   ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) ///         
                delim("&")  /// Type of column delimiter 
                nomtitle ///
                collabels(none) /// No column names within model
                keep( gpt_available_post1 ///
                        ) ///
                order(gpt_available_post1) ///
                mgroups("\shortstack{DID}" ///
                                        "\shortstack{SC}" ///
                                        "\shortstack{SDID}",  ///
                                        pattern(1 1 1)                           ///
                                        prefix(\multicolumn{@span}{c}{) suffix(}) span                       ///
                                        erepeat(\cmidrule(lr){@span})) ///
                                nomtitles                       ///
                scalars("control_mean Baseline Mean Outcome") ///
                        refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{C} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers
        
esttab  cpp_did ///
                cpp_sc ///
                cpp_sdid ///
                using "$path/output\tables/gpt_impact_github_low_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{C++} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Rust_did ///
                Rust_sc ///
                Rust_sdid ///
                using "$path/output\tables/gpt_impact_github_low_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{Rust} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Assembly_did ///
                Assembly_sc ///
                Assembly_sdid ///
                using "$path/output\tables/gpt_impact_github_low_level.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel D. \textbf{ \textit{Assembly} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 










local languages "Tex"


foreach lang of local languages {

        local l`v' : variable label num_pushers_pc


// eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
//         vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
//         g1_opt(xtitle("") scheme(plotplainblind)) ///
//         g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
//         xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

//         sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
//         estadd scalar control_mean `r(mean)'

// eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
//         vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
//         g1_opt(xtitle("") scheme(plotplainblind)) ///
//         g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
//         xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

//         sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
//         estadd scalar control_mean `r(mean)'

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}

x

// bysort iso2_code : gen quarter_int = _n

drop post_1 post_2
* Generate post variable
gen post_1 =  year_quarter_num >= 12
gen post_2 =  year_quarter_num >= 13

* gpt_available_post1
gen gpt_treat = post_1 * gpt_available

local outcomes 	pushes_p100k ///
				repositories_p100k ///
				developers_p100k

foreach var of varlist `outcomes'{

	local l`v' : variable label `var'


eststo `var'_did: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_did_", .png )
	// graph save "$path/output/figures/`var'_did.gph"

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

eststo `var'_sc: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_sc_", .png)

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

eststo `var'_sdid: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_sdid_", .png)

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

}


* Gross amount + net + Side payments
	grc1leg2  "$path/output/figures/developers_p100k_sdid_trends12.eps"				///
		      "$path/output/figures/developers_p100k_sdid_trends12.eps" 		 	///
			  "$path/output/figures/developers_p100k_sdid_trends12.eps", col(2)		
graph export "$path/output/figures/developers_p100k_sdid_trends12_2.eps", replace



****** Table with three panels 

esttab	pushes_p100k_did ///
		pushes_p100k_sc ///
		pushes_p100k_sdid ///
 		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex",			 ///
		replace label booktabs 				 					 ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
		starlevels(* 0.10 ** 0.05 *** 0.01) ///		
		delim("&")  /// Type of column delimiter 
		nomtitle ///
		collabels(none) /// No column names within model
		keep( gpt_treat ///
			) ///
		order(gpt_treat) ///
		mgroups("\shortstack{DID}" ///
					"\shortstack{SC}" ///
					"\shortstack{SDID}",  ///
					pattern(1 1 1)  			 ///
					prefix(\multicolumn{@span}{c}{) suffix(}) span 			     ///
					erepeat(\cmidrule(lr){@span})) ///
	        		nomtitles			///
		scalars("control_mean Baseline Mean Outcome") ///
			refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{Num Pushes per 100k} } } }" , nolabel) ///
			prefoot("") posthead(\hline) postfoot("")  nonumbers
	
esttab	repositories_p100k_did ///
		repositories_p100k_sc ///
		repositories_p100k_sdid ///
 		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex", ///
		append label booktabs mlabel(,none)				 					 ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
		starlevels(* 0.10 ** 0.05 *** 0.01) /// 
	keep( gpt_treat ///
		) ///
	order(gpt_treat) ///
		scalars("control_mean Baseline Mean Outcome") ///
		refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Num Repos per 100k} } } }" , nolabel) /// Subtitles
		prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote


esttab 	developers_p100k_did ///
		developers_p100k_sc ///
		developers_p100k_sdid ///
 		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex", ///
 		append label booktabs mlabel(,none) 				 					 ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
		starlevels(* 0.10 ** 0.05 *** 0.01) /// 
	keep( gpt_treat ///
		) ///
	order(gpt_treat) ///
		scalars("control_mean Baseline Mean Outcome") ///
		refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{Num developers per 100k} } } }" , nolabel) /// Subtitles
		prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 















eststo pp100_did: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(pp100_did_, .png)

eststo pp100_sc: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(pp100_sc_, .png)

eststo pp100_sdid: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(pp100_sdid_, .png)

eststo dp100_did: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(dp100_did_, .png)

eststo dp100_sc: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(dp100_sc_, .png)

eststo dp100_sdid: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(dp100_sdid_, .png)


eststo ppd_did: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Pushes per developer") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(ppd_did_, .png)

eststo ppd_sc: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
	g1_opt(xtitle("") scheme(sj)) ///
	g2_opt(ytitle("Pushes per developer") scheme(sj) ///
	xtitle("Quarters since 2020Q1")) graph_export(ppd_sc_, .png)

	eststo ppd_sdid: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
		vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
		g1_opt(xtitle("") scheme(sj)) ///
		g2_opt(ytitle("Pushes per developer") scheme(sj) ///
		xtitle("Quarters since 2020Q1")) graph_export(ppd_sdid_, .png)

cd "$path/output/tables"

esttab pp100_did using pp100_did.tex, replace
esttab pp100_sc using pp100_sc.tex, replace
esttab pp100_sdid using pp100_sdid.tex, replace
esttab dp100_did using dp100_did.tex, replace
esttab dp100_sc using dp100_sc.tex, replace
esttab dp100_sdid using dp100_sdid.tex, replace
esttab ppd_did using ppd_did.tex, replace
esttab ppd_sc using ppd_sc.tex, replace
esttab ppd_sdid using ppd_sdid.tex, replace
