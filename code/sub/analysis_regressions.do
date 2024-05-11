//----------------------------------------------------------------------------//
//
// project:
//
// do.file: analysis_regressions
//
// author(s):
//
//----------------------------------------------------------------------------//


/* ESTIMACIÓN SDID GENERAL
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment, ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 

graph export sd_id_analysis.png, as(png) replace
*/



/* VERSIÓN DESAGREGADA * 
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="JavaScript",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-JavaScript") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 

eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="Python",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-Python") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="PHP",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-PHP") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 		
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="Java",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-Java") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="TypeScript",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-TypeScript") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 

eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="Ruby",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-Ruby") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="C#",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-C#") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="C++",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-C++") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
graph export sd_id_analysis.png, as(png) replace
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="Kotlin",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-Kotlin") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 
		
graph export sd_id_analysis.png, as(png) replace
		
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment if language=="Swift",	 ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants-Swift") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 

graph export sd_id_analysis.png, as(png) replace

*/




**VERSIÓN FINAL**

 local languages "JavaScript Python PHP Java TypeScript Ruby C# C++ Kotlin Swift" // Eliminar esta linea

foreach lang of local languages {

        preserve

        cd "$path/output/figures"

        keep if language == "`lang'"

        eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment, ///
                vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
                g1_opt(xtitle("") scheme(sj)) ///
                g2_opt(ytitle("`lang' pushers per 100k inhabitants") scheme(sj) ///
                xtitle("Quarters since 2020Q1")) graph_export(`lang'_sdid_, .png)

        cd "$path/output/tables"

        esttab est_sdid using `lang'_sdid.tex, replace

        restore
}




