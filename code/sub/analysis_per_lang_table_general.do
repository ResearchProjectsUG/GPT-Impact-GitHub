import delimited "output/csv/Prueba.csv", clear

sort unique_id year quarter
drop if iso2_code == "HK"
label var num_pushers_pc "Num pushers per 100k"
label var gpt_available_post1 "Chat GPT Available"


*****************
// Aqui comienzo a editar // Tesis_DataScience_Global
*****************


// Local para las variables de resultado
local outcomes num_pushers_pc 

foreach var of varlist `outcomes' {
    local l`var' : variable label `var'
    
    // Ejecutar el modelo DID
    eststo `var'_did: sdid `var' iso2_code quarter_int gpt_available_post1, ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`var''-`var'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45)))   
    graph export "$path/output/figures/`var'_did.png"

    // Resumir para obtener la media de control
    sum `var' if gpt_available == 0 & quarter_int < 12 
    estadd scalar control_mean `r(mean)'

    // Ejecutar el modelo SC
    eststo `var'_sc: sdid `var' iso2_code quarter_int gpt_available_post1, ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`var''-`var'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45)))  
    graph export "$path/output/figures/`var'_sc.png"

    // Resumir para obtener la media de control
    sum `var' if gpt_available == 0 & quarter_int < 12 
    estadd scalar control_mean `r(mean)'

    // Ejecutar el modelo SDID
    eststo `var'_sdid: sdid `var' iso2_code quarter_int gpt_available_post1, ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`var''-`var'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45)))  
    graph export "$path/output/figures/`var'_sdid.png"

    // Resumir para obtener la media de control
    sum `var' if gpt_available == 0 & quarter_int < 12 
    estadd scalar control_mean `r(mean)'
}

esttab num_pushers_pc_did ///
                num_pushers_pc_sc ///
                num_pushers_pc_sdid ///
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
                        refcat( gpt_available_post1 "\Gape[0.25cm][0.25cm]{ \underline{\textbf{ \textit{Pushers_pc_global} } } }" , nolabel) ///
                        prefoot("") posthead(\hline) postfoot("")  nonumbers


