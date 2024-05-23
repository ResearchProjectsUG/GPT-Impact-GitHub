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
import delimited "output/data/data_langs.csv", clear
drop if iso2_code == "HK"


local languages "Python Java R Julia Swift"
label var num_pushers_pc "Num pushers per 100k"

foreach lang of local languages {

        local l`v' : variable label num_pushers_pc


eststo `lang'_did: sdid num_pushers_pc iso2_code quarter treatment if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_did_", .png )

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sc:  sdid num_pushers_pc iso2_code quarter treatment if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sc_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

eststo `lang'_sdid:  sdid num_pushers_pc iso2_code quarter treatment if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`v''-`lang'")scheme(plotplainblind) ///
        xtitle("Quarters since 2020Q1")) graph_export("$path/output/figures/`lang'_sdid_", .png)

        sum  num_pushers_pc  if  gpt_available==0 & quarter<12 & language == "`lang'"
        estadd scalar control_mean `r(mean)'

}
x


****** Table with three panels 

esttab  Python_did ///
                Python_sc ///
                Python_sdid ///
                using "$path/output\tables/gpt_impact_github_langugages.tex",                         ///
                replace label booktabs                                                                   ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) ///         
                delim("&")  /// Type of column delimiter 
                nomtitle ///
                collabels(none) /// No column names within model
                keep( treatment ///
                        ) ///
                order(treatment) ///
                mgroups("\shortstack{DID}" ///
                                        "\shortstack{SC}" ///
                                        "\shortstack{SDID}",  ///
                                        pattern(1 1 1)                           ///
                                        prefix(\multicolumn{@span}{c}{) suffix(}) span                       ///
                                        erepeat(\cmidrule(lr){@span})) ///
                                nomtitles                       ///
                scalars("control_mean Baseline Mean Outcome") ///
                        refcat( treatment "\Gape[0.25cm][0.25cm]{ \underline{Panel A. \textbf{ \textit{Python} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers
        
esttab  Java_did ///
                Java_sc ///
                Java_sdid ///
                using "$path/output\tables/gpt_impact_github_langugages.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( treatment ///
                ) ///
        order(treatment) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( treatment "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Java} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  R_did ///
                R_sc ///
                R_sdid ///
                using "$path/output\tables/gpt_impact_github_langugages.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( treatment ///
                ) ///
        order(treatment) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( treatment "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{R} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Julia_did ///
                Julia_sc ///
                Julia_sdid ///
                using "$path/output\tables/gpt_impact_github_langugages.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( treatment ///
                ) ///
        order(treatment) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( treatment "\Gape[0.25cm][0.25cm]{ \underline{Panel B. \textbf{ \textit{Julia} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline") postfoot("") delim("&") collabels(none) nonumbers nogaps nonote

esttab  Swift_did ///
                Swift_sc ///
                Swift_sdid ///
                using "$path/output\tables/gpt_impact_github_langugages.tex", ///
                append label booktabs mlabel(,none)                                                                      ///
                cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))             ///
                starlevels(* 0.10 ** 0.05 *** 0.01) /// 
        keep( treatment ///
                ) ///
        order(treatment) ///
                scalars("control_mean Baseline Mean Outcome") ///
                refcat( treatment "\Gape[0.25cm][0.25cm]{ \underline{Panel C. \textbf{ \textit{Swift} } } }" , nolabel) /// Subtitles
                prehead("") prefoot("") posthead("\hline")  delim("&") collabels(none) nonumbers nogaps nonote 






cd "$path"
