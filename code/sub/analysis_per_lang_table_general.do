import delimited "output/csv/all_languages_panel.csv", clear

sort unique_id year quarter 
drop if iso2_code == "HK"
label var num_pushers_pc "Num pushers per 100k"
label var gpt_available_post1 "Chat GPT Available"





**************************
// Se realizo un cambio de nombres de etiquetas
************************
replace language = "C_hashtag" if language == "C#"

replace language = "C_plus" if language == "C++"

*****************
// Aqui comienzo a editar // Tesis_DataScience_Global
*****************

gen language_of_interest = 0

* Usar varias condiciones para marcar los lenguajes de interés
replace language_of_interest = 1 if inlist(language, "C", "C_hashtag", "C_plus", "Go", "Java") ///
                                 | inlist(language, "JavaScript", "PHP", "Python", "Ruby", "TypeScript")

* Mantener solo las observaciones de los lenguajes de interés
keep if language_of_interest == 1

* Eliminar la variable auxiliar
drop language_of_interest



local DataScience "C C_hashtag C_plus Go Java JavaScript PHP Python Ruby TypeScript"

foreach lang of local DataScience {

    // Obtener la etiqueta de la variable `num_pushers_pc`
    local l`lang' : variable label num_pushers_pc
    
    // Ejecutar el modelo DID
    eststo `lang'_did: sdid num_pushers_pc iso2_code quarter gpt_available_post1, ///
        vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`lang''-`lang'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
        )   
    graph export "$path/output/figures/`lang'_did.png"

    // Resumir para obtener la media de control
    sum num_pushers_pc if gpt_available == 0 & quarter < 12 & language == "`lang'"
    estadd scalar control_mean `r(mean)'

    // Ejecutar el modelo SC
    eststo `lang'_sc: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`lang''-`lang'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
        )  
    graph export "$path/output/figures/`lang'_sc.png"

    // Resumir para obtener la media de control
    sum num_pushers_pc if gpt_available == 0 & quarter < 12 & language == "`lang'"
    estadd scalar control_mean `r(mean)'

    // Ejecutar el modelo SDID
    eststo `lang'_sdid: sdid num_pushers_pc iso2_code quarter gpt_available_post1 if language == "`lang'", ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
        g1_opt(xtitle("") scheme(plotplainblind)) ///
        g2_opt(ytitle("`l`lang''-`lang'") scheme(plotplainblind) ///
            xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4" ///
            5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
            9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
            13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
        )  
    graph export "$path/output/figures/`lang'_sdid.png"

    // Resumir para obtener la media de control
    sum num_pushers_pc if gpt_available == 0 & quarter < 12 & language == "`lang'"
    estadd scalar control_mean `r(mean)'

}



