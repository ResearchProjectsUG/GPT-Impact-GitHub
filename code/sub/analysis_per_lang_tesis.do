//----------------------------------------------------------------------------//
//
// project:
//
// do.file: analysis_regressions
//
// author(s):
//
//----------------------------------------------------------------------------//

// local languages "Python Java R Julia Swift"

// foreach lang of local languages {

//         preserve

//         cd "$path/output/figures"

//         keep if language == "`lang'"

//         eststo est_sdid: sdid num_pushers_pc iso2_code quarter treatment, ///
//                 vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
//                 g1_opt(xtitle("") scheme(sj)) ///
//                 g2_opt(ytitle("`lang' pushers per 100k inhabitants") scheme(sj) ///
//                 xtitle("Quarters since 2020Q1")) graph_export(`lang'_sdid_, .png)

//         cd "$path/output/tables"

//         esttab est_sdid using `lang'_sdid.tex, replace

//         restore
// }


import delimited "output/csv/all_languages_panel.csv", clear

sort unique_id year quarter 
drop if iso2_code == "HK"
label var num_pushers_pc "Num pushers per 100k"
label var gpt_available_post1 "Chat GPT Available"

drop quarter

rename quarter_int quarter

**************************
// Se realizo un cambio de nombres de etiquetas
************************
replace language = "C_hashtag" if language == "C#"

replace language = "C_plus" if language == "C++"

*****************
// Aqui comienzo a editar // Tesis_DataScience 
*****************
local DataScience "C C_hashtag C_plus Go Java JavaScript PHP Python Ruby TypeScript"

foreach lang of local DataScience {

        local l`v' : variable label num_pushers_pc


eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	)   graph_export("$path/output/figures/`lang'did", .png )

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
	)  graph_export("$path/output/figures/`lang'sc", .png)

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
	)  graph_export("$path/output/figures/`lang'sdid", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}

** Table with three panels 
						
esttab C_did ///
                C_sc ///
                C_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex",                         ///
                replace label booktabs                                                                   ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) ///         
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
        

esttab  Java_did ///
                Java_sc ///
                Java_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Java} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  JavaScript_did ///
                JavaScript_sc ///
                JavaScript_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{JavaScript} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Kotlin_did ///
                Kotlin_sc ///
                Kotlin_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel D. \textbf{ \textit{Kotlin} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 
				
esttab  PHP_did ///
                PHP_sc ///
                PHP_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel E. \textbf{ \textit{PHP} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 

esttab  Python_did ///
                Python_sc ///
                Python_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel F. \textbf{ \textit{Python} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 
				
esttab  Ruby_did ///
                Ruby_sc ///
                Ruby_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel G. \textbf{ \textit{Ruby} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 
				
esttab  Swift_did ///
                Swift_sc ///
                Swift_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel H. \textbf{ \textit{Swift} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 
				
esttab  TypeScript_did ///
                TypeScript_sc ///
                TypeScript_sdid ///
                using "$path/output\tables/gpt_impact_github_DataScience.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 * 0.05 ** 0.01) /// 
        keep( gpt_available_post1 ///
                ) ///
        order(gpt_available_post1) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{Panel I. \textbf{ \textit{TypeScript} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 				
				
*****************
// Aqui termino de editar // Tesis_DataScience 
*****************





cd "$path"
