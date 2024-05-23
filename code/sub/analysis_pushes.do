// cd "$path/output/figures" 

import delimited "output/data/pushes.csv", clear

sort iso2_code year quarter year_quarter_num

drop if iso2_code == "HK"


gen pushes_p100k = pushes_pc * 100000
gen developers_p100k = developers_pc * 100000
gen repositories_p100k = repositories_pc * 100000


label var pushes_p100k "Num. Pushes per 100k inhabitants"
label var repositories_p100k "Num. Repositories per 100k inhabitants"
label var developers_p100k "Num. Developers per 100k inhabitants"




// bysort iso2_code : gen quarter_int = _n

drop post_1 post_2
* Generate post variable
gen post_1 =  year_quarter_num >= 12
gen post_2 =  year_quarter_num >= 13

* Treatment
gen gpt_treat = post_1 * gpt_available
label var gpt_treat "Chat GPT Available"

local outcomes 	pushes_p100k ///
				repositories_p100k ///
						

foreach var of varlist `outcomes'{

	local l`v' : variable label `var'


eststo `var'_did: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(did) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	) graph_export("$path/output/figures/`var'_did_", .png )
	// graph save "$path/output/figures/`var'_did.gph"

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

eststo `var'_sc: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(sc) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''")scheme(plotplainblind) ///
	xtitle("Quarter")xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	) graph_export("$path/output/figures/`var'_sc_", .png)

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

eststo `var'_sdid: sdid `var' iso2_code year_quarter_num gpt_treat, ///
	vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on /// 
	g1_opt(xtitle("") scheme(plotplainblind)) ///
	g2_opt(ytitle("`l`v''") scheme(plotplainblind) ///
	xtitle("Quarter") xlabel(1 "2020-Q1" 2 "2020-Q2" 3 "2020-Q3" 4 "2020-Q4"  ///
        5 "2021-Q1" 6 "2021-Q2" 7 "2021-Q3" 8 "2021-Q4" ///
        9 "2022-Q1" 10 "2022-Q2" 11 "2022-Q3" 12 "2022-Q4" ///
        13 "2023-Q1" 14 "2023-Q2" 15 "2023-Q3" 16 "2023-Q4", labsize(small) angle(45) ) ///
	) graph_export("$path/output/figures/`var'_sdid_", .png)

	sum  `var'  if  gpt_available==0 & year_quarter_num<12
	estadd scalar control_mean `r(mean)'

}

x
* Gross amount + net + Side payments
	grc1leg2  "$path/output/figures/developers_p100k_sdid_trends12.eps"				///
		      "$path/output/figures/developers_p100k_sdid_trends12.eps" 		 	///
			  "$path/output/figures/developers_p100k_sdid_trends12.eps", col(2)		
graph export "$path/output/figures/developers_p100k_sdid_trends12_2.eps", replace

x



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



x











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
