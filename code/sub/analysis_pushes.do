cd "$path/output/figures" 

import delimited "output/data/pushes.csv", clear

drop if iso2_code == "HK"


gen pushes_p100k = pushes_pc * 100000
gen developers_p100k = developers_pc * 100000

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
