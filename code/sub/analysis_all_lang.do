// cd "$path/output/figures" 

import delimited "output/csv/all_languages_panel.csv", clear

sort unique_id year quarter 
drop if iso2_code == "HK"
label var num_pushers_pc "Num pushers per 100k"
label var gpt_available_post1 "Chat GPT Available"


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


foreach lang of local high_level {

        local l`v' : variable label num_pushers_pc


eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	)   graph_export("$path/output/figures/`lang'_did_", .png )

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	)  graph_export("$path/output/figures/`lang'_sc_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	)  graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}





x

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






**********************
*
**********************

local shell_scripting "Shell Batchfile PowerShell"

foreach lang of local shell_scripting {

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

esttab  Shell_did ///
                Shell_sc ///
                Shell_sdid ///
                using "$path/output\tables/gpt_impact_github_shell.tex",                         ///
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
                        refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{Shell} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers
        
esttab  Batchfile_did ///
                Batchfile_sc ///
                Batchfile_sdid ///
                using "$path/output\tables/gpt_impact_github_shell.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Batchfile} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote


esttab  PowerShell_did ///
                PowerShell_sc ///
                PowerShell_sdid ///
                using "$path/output\tables/gpt_impact_github_shell.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{PowerShell} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 




**********************
*
**********************

local dsl "TSQL PLpgSQL HTML CSS MATLAB R"


foreach lang of local dsl {

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

esttab  TSQL_did ///
                TSQL_sc ///
                TSQL_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex",                         ///
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
                        refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{TSQL} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers
        
esttab  PLpgSQL_did ///
                PLpgSQL_sc ///
                PLpgSQL_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{PLpgSQL} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  HTML_did ///
                HTML_sc ///
                HTML_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{HTML} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote


esttab  CSS_did ///
                CSS_sc ///
                CSS_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel D. \textbf{ \textit{CSS} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  MATLAB_did ///
                MATLAB_sc ///
                MATLAB_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel E. \textbf{ \textit{MATLAB} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  R_did ///
                R_sc ///
                R_sdid ///
                using "$path/output\tables/gpt_impact_github_dsl.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel F. \textbf{ \textit{R} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 



******************************************************


local high_level "Python JavaScript Ruby PHP TypeScript"
// local statically "Java C# Go Swift"
local shell_scripting "Shell Batchfile PowerShell"
local dsl "TSQL PLpgSQL HTML CSS MATLAB R"
local low_level "C Rust Assembly"


foreach lang of local dsl{

        local l`v' : variable label num_pushers_pc

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}

eststo cpp_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "C++", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "C++"
        estadd scalar control_mean `r(mean)'




coefplot (JavaScript_sdid, label("JavaScript")) ///
(Python_sdid, label("Python")) ///
(TypeScript_sdid, label("TypeScript")) ///
(C_sdid, label("C")) ///
(Rust_sdid, label("Rust")) ///
(cpp_sdid, label("C++")) ///
(Assembly_sdid, label("Assembly")) ///
(Shell_sdid, label("Shell")) ///
(Batchfile_sdid, label("Batchfile")) ///
(PowerShell_sdid, label("PowerShell")) ///
(PLpgSQL_sdid, label("PLpgSQL")) ///
(HTML_sdid, label("HTML")) ///
(CSS_sdid, label("CSS")) ///
(MATLAB_sdid, label("MATLAB")) ///
, keep(gpt_available_post1) ///
sort ylab("") title("High-Level, General-Purpose Languages", orient(horiz)) xline(0) msymbol(S)  scheme(plotplainblind)


coefplot (JavaScript_sdid, label("JavaScript")) ///
(Python_sdid, label("Python")) ///
(TypeScript_sdid, label("TypeScript")) ///
, keep(gpt_available_post1) ///
sort ylab("") title("High-Level, General-Purpose Languages", orient(horiz)) xline(0) msymbol(S)  scheme(plotplainblind)

graph save "$path/output/figures/high_level_coefplot.gph", replace
graph export "$path/output/figures/high_level_coefplot.pdf", replace


coefplot (Rust_sdid, label("Rust")) ///
(C_sdid, label("C")) ///
(cpp_sdid, label("C++")) ///
(Assembly_sdid, label("Assembly")), keep(gpt_available_post1) ///
sort ylab("") title("Low-Level, Systems Programming Languages", orient(horiz)) xline(0) msymbol(S)  scheme(plotplainblind)

graph save "$path/output/figures/low_level_coefplot.gph", replace
graph export "$path/output/figures/low_level_coefplot.pdf", replace


coefplot (Shell_sdid, label("Shell")) ///
(Batchfile_sdid, label("Batchfile")) ///
(PowerShell_sdid, label("PowerShell")) ///
, keep(gpt_available_post1) ///
sort ylab("") title("Shell Scripting Languages", orient(horiz)) xline(0) msymbol(S)  scheme(plotplainblind)
graph save "$path/output/figures/shell_coefplot.gph", replace
graph export "$path/output/figures/shell_coefplot.pdf", replace

coefplot  ///
(HTML_sdid, label("HTML")) ///
(CSS_sdid, label("CSS")) ///
(R_sdid, label("R"))  ///
(MATLAB_sdid, label("MATLAB")) ///
(PLpgSQL_sdid, label("PLpgSQL")) , keep(gpt_available_post1) ///
sort ylab("") title("Domain-Specific Languages", orient(horiz)) xline(0) msymbol(S)  scheme(plotplainblind)
graph save "$path/output/figures/dsl_coefplot.gph", replace
graph export "$path/output/figures/dsl_coefplot.pdf", replace


* Gross amount + net + Side payments
	grc1leg2  "$path/output/figures/high_level_coefplot.gph"				///
		      "$path/output/figures/low_level_coefplot.gph" 		 	///
			  "$path/output/figures/shell_coefplot.gph" ///
			  "$path/output/figures/dsl_coefplot.gph", col(2)		
graph export "$path/output/figures/all_program_lang_coefplot.gph", replace



graph combine  "$path/output/figures/high_level_coefplot.gph"				///
		      "$path/output/figures/low_level_coefplot.gph" 		 	///
			  "$path/output/figures/shell_coefplot.gph" ///
			  "$path/output/figures/dsl_coefplot.gph", col(2) xcommon		
graph export "$path/output/figures/all_program_lang_coefplot.pdf", replace




coefplot JavaScript_sdid Python_sdid TypeScript_sdid ///
PHP_sdid, keep(gpt_available_post1) sort ylab("") ytitle("", orient(horiz)) xline(0) msymbol(S) ///
eqlabels("Equation 1" "Equation 2" "Equation 3")



coefplot (JavaScript_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
		(Python_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         (TypeScript_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         (PHP_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
			(Ruby_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         , drop(_cons) xline(0) msymbol(S)


coefplot (Python_sdid , msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
		(JavaScript_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         (TypeScript_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         (PHP_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
			(Ruby_sdid, msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) ///
         , keep(gpt_available_post1) sort drop(_cons) xline(0) msymbol(S)




(r13, label(Catering Food Services)) 
(r11, label(Confectioners Shops)) 
(r15, label(Pizza, Hamburger, Sandwich and Similar Food Services)) 
(r14, label(Chicken Shops)) 
(r6, label(Noodle Houses)) (r1, label(Other Lunch Counters n.e.c.)) (r9, label(General Amusement Drinking Places)) (r5, label(Dancing Amusement Drinking Places))
 (r4, label(Other Drinking Places)) (r7, label(Non-Alcoholic Beverages Places)) 
 , keep(logkorean)  xline(0) mlabel(cond(@pval<.001, "<0.001" + "***",cond(@pval<.01, string(@pval,"%9.3f") + "**", cond(@pval<.05, string(@pval,"%9.3f") + "*",string(@pval,"%9.3f"))))) scheme(s1color)



* 1. Total amount paid bribes 
	 local l`v' : variable label `var'
	 coefplot 																	///
	  	(es_`var', msym(O) mcol("97 156 255") msize(*1.2) 				///
	  	   ciopt(lcol("97 156 255") lw(*1.35))) 								///
	 	(dd_`var', recast(area) 											///
	 	   ciopt(recast(rbar) lcol(red) lw(*1.5) fcol(gs10%20))),				///	   
	 	   mlabel format(%9.2g) mlabposition(7) mlabgap(*1.3)					///
	 	    	 mlabcol(gs6)         											///
	 	   keep(treat_2  zero treat_4)  													///
	 	   vertical 											     			///
		   title("") 														///
	 	   yline(0 , lw(vthin)) 												///
	   		legend(order(2 "Event study, District FE + time FE + Province - time trend " /// 
	   				1 "Event study 95% CI"									///
	   				5 "DiD treatment effect" 								///
	   				3 "DiD 95% CI" ) 										///
	   		size(*.7) pos(6) row(2) region(lp(solid) lw(vthin) lc(gs4))) 	///
	 	   xtitle(Round Post Treatment) 										///
	 	   ylab(, nogrid) 			        									///
		   title("`l`v''") 												///
	 	   omitted nooffsets 													///
	addplot(pci `b_`var'' 2.5 `b_`var'' 3.5, col(black) lw(*1.5)) ///
			plotregion(lw(vthin) lc(black)) xsize(4) 							///
		note("Num Obs= `num_obs'" "Source:OPM Not balanced Panel 2014, 2016, 2019 and PP dataset." ///
			, size(small))	///
		   scale(*0.8)  
	  graph save "$graphs_results/event_study/ES_DD_`var'_nohbl_no2013.gph", replace
	  graph export "$graphs_results/event_study/ES_DD_`var'_nohbl_no2013.pdf", replace



































// local languages "Tex"


// foreach lang of local languages {

//         local l`v' : variable label num_pushers_pc


// // eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
// //         vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
// //         g1_opt(xtitle("") scheme(plotplainblind)) ///
// //         g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
// //         xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

// //         sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
// //         estadd scalar control_mean `r(mean)'

// // eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
// //         vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
// //         g1_opt(xtitle("") scheme(plotplainblind)) ///
// //         g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
// //         xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

// //         sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
// //         estadd scalar control_mean `r(mean)'

// eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
//         vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
//         g1_opt(xtitle("") scheme(plotplainblind)) ///
//         g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
//         xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

//         sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
//         estadd scalar control_mean `r(mean)'

// }

// x

// // bysort iso2_code : gen quarter_int = _n

// drop post_1 post_2
// * Generate post variable
// gen post_1 =  year_quarter_num >= 12
// gen post_2 =  year_quarter_num >= 13

// * gpt_available_post1
// gen gpt_treat = post_1 * gpt_available

// local outcomes 	pushes_p100k ///
// 				repositories_p100k ///
// 				developers_p100k

// foreach var of varlist `outcomes'{

// 	local l`v' : variable label `var'


// eststo `var'_did: sdid `var' iso2_code year_quarter_num gpt_treat, ///
// 	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
// 	g1_opt(xtitle("") scheme(plotplainblind)) ///
// 	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
// 	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_did_", .png )
// 	// graph save "$path/output/figures/`var'_did.gph"

// 	sum  `var'  if  gpt_available==0 & year_quarter_num<12
// 	estadd scalar control_mean `r(mean)'

// eststo `var'_sc: sdid `var' iso2_code year_quarter_num gpt_treat, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
// 	g1_opt(xtitle("") scheme(plotplainblind)) ///
// 	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
// 	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_sc_", .png)

// 	sum  `var'  if  gpt_available==0 & year_quarter_num<12
// 	estadd scalar control_mean `r(mean)'

// eststo `var'_sdid: sdid `var' iso2_code year_quarter_num gpt_treat, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
// 	g1_opt(xtitle("") scheme(plotplainblind)) ///
// 	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
// 	xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`var'_sdid_", .png)

// 	sum  `var'  if  gpt_available==0 & year_quarter_num<12
// 	estadd scalar control_mean `r(mean)'

// }


// * Gross amount + net + Side payments
// 	grc1leg2  "$path/output/figures/developers_p100k_sdid_trends12.eps"				///
// 		      "$path/output/figures/developers_p100k_sdid_trends12.eps" 		 	///
// 			  "$path/output/figures/developers_p100k_sdid_trends12.eps", col(2)		
// graph export "$path/output/figures/developers_p100k_sdid_trends12_2.eps", replace



// ****** Table with three panels 

// esttab	pushes_p100k_did ///
// 		pushes_p100k_sc ///
// 		pushes_p100k_sdid ///
//  		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex",			 ///
// 		replace label booktabs 				 					 ///
// 		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
// 		starlevels(* 0.10 ** 0.05 *** 0.01) ///		
// 		delim("&")  /// Type of column delimiter 
// 		nomtitle ///
// 		collabels(none) /// No column names within model
// 		keep( gpt_treat ///
// 			) ///
// 		order(gpt_treat) ///
// 		mgroups("\shortstack{DID}" ///
// 					"\shortstack{SC}" ///
// 					"\shortstack{SDID}",  ///
// 					pattern(1 1 1)  			 ///
// 					prefix(\multicolumn{@span}{c}{) suffix(}) span 			     ///
// 					erepeat(\cmidrule(lr){@span})) ///
// 	        		nomtitles			///
// 		scalars("control_mean Baseline Mean Outcome") ///
// 			refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{Num Pushes per 100k} } } }" , nolabel) ///
// 			prefoot("") posthead(\hline) postfoot("")  nonumbers
	
// esttab	repositories_p100k_did ///
// 		repositories_p100k_sc ///
// 		repositories_p100k_sdid ///
//  		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex", ///
// 		append label booktabs mlabel(,none)				 					 ///
// 		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
// 		starlevels(* 0.10 ** 0.05 *** 0.01) /// 
// 	keep( gpt_treat ///
// 		) ///
// 	order(gpt_treat) ///
// 		scalars("control_mean Baseline Mean Outcome") ///
// 		refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Num Repos per 100k} } } }" , nolabel) /// Subtitles
// 		prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote


// esttab 	developers_p100k_did ///
// 		developers_p100k_sc ///
// 		developers_p100k_sdid ///
//  		using "$path/output\tables/gpt_impact_github_push_dev_repo.tex", ///
//  		append label booktabs mlabel(,none) 				 					 ///
// 		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  		 ///
// 		starlevels(* 0.10 ** 0.05 *** 0.01) /// 
// 	keep( gpt_treat ///
// 		) ///
// 	order(gpt_treat) ///
// 		scalars("control_mean Baseline Mean Outcome") ///
// 		refcat( gpt_treat "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{Num developers per 100k} } } }" , nolabel) /// Subtitles
// 		prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 















// eststo pp100_did: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(pp100_did_, .png)

// eststo pp100_sc: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(pp100_sc_, .png)

// eststo pp100_sdid: sdid pushes_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(pp100_sdid_, .png)

// eststo dp100_did: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(dp100_did_, .png)

// eststo dp100_sc: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(dp100_sc_, .png)

// eststo dp100_sdid: sdid developers_p100k iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Developers per 100k inhabitants") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(dp100_sdid_, .png)


// eststo ppd_did: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Pushes per developer") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(ppd_did_, .png)

// eststo ppd_sc: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
// 	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
// 	g1_opt(xtitle("") scheme(sj)) ///
// 	g2_opt(ytitle("Pushes per developer") scheme(sj) ///
// 	xtitle("Quarters since 2020Q1")) graph_export(ppd_sc_, .png)

// 	eststo ppd_sdid: sdid pushes_perdev iso2_code year_quarter_num gpt_available_post1, ///
// 		vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
// 		g1_opt(xtitle("") scheme(sj)) ///
// 		g2_opt(ytitle("Pushes per developer") scheme(sj) ///
// 		xtitle("Quarters since 2020Q1")) graph_export(ppd_sdid_, .png)

// cd "$path/output/tables"

// esttab pp100_did using pp100_did.tex, replace
// esttab pp100_sc using pp100_sc.tex, replace
// esttab pp100_sdid using pp100_sdid.tex, replace
// esttab dp100_did using dp100_did.tex, replace
// esttab dp100_sc using dp100_sc.tex, replace
// esttab dp100_sdid using dp100_sdid.tex, replace
// esttab ppd_did using ppd_did.tex, replace
// esttab ppd_sc using ppd_sc.tex, replace
// esttab ppd_sdid using ppd_sdid.tex, replace
