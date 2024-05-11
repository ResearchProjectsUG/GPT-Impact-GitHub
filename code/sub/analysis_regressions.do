//----------------------------------------------------------------------------//
//
// project:
//
// do.file: analysis_regressions
//
// author(s):
//
//----------------------------------------------------------------------------//


/*
eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment, ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) 

graph export sd_id_analysis.png, as(png) replace
*/

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

*************************************
* LO DE ABAJO NO SE DEBE CORRER
*************************************



 local languages "Python Java R Julia Swift " // Eliminar esta linea

foreach lang of local languages {

        preserve

        cd "$path/output/figures"

        keep if language == "`lang'"

        eststo est_sdid: sdid repositories iso2_code quarter treatment, ///
                vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
                g1_opt(xtitle("") scheme(sj)) ///
                g2_opt(ytitle("`lang' pushers per 100k inhabitants") scheme(sj) ///
                xtitle("Quarters since 2020Q1")) graph_export(`lang'_sdid_, .png)

        cd "$path/output/tables"

        esttab est_sdid using `lang'_sdid.tex, replace

        restore
}

cd "$path"

preserve

cd "$path/output/figures"

keep if language == "`lang'"

eststo est_sdid: sdid repositories id quarter treatment, ///
                vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
			    g1_opt(xtitle("") scheme(sj)) ///
                g2_opt(ytitle("`lang' pushers per 100k inhabitants") scheme(sj) ///
                xtitle("Quarters since 2020Q1")) graph_export(`lang'_sdid_, .png)

        cd "$path/output/tables"

        esttab est_sdid using `lang'_sdid.tex, replace
		
restore














eststo est_sdid: sdid num_pushers_pc unique_id quarter treatment, ///
        vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
        g1_opt(xtitle("") scheme(sj)) ///
        g2_opt(ytitle("Pushers per 100k inhabitants") scheme(sj) ///
        xtitle("Quarters since 2020Q1")) graph_export(sd_id_analysis.png)

