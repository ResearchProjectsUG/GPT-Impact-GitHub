//----------------------------------------------------------------------------//
//
// project:
//
// do.file: analysis_regressions
//
// author(s):
//
//----------------------------------------------------------------------------//

local languages "Python Java R Julia Swift"

foreach lang of local languages {

        preserve

        cd "$path/output/figures"

        keep if language == "`lang'"

        eststo est_sdid: sdid num_pushers_pc iso2_code quarter treatment, ///
                vce(bootstrap) reps(100) seed(1234) method(sdid) graph g1on ///
                g1_opt(xtitle("") scheme(sj)) ///
                g2_opt(ytitle("Pushes per 100k inhabitants") scheme(sj) ///
                xtitle("Quarters since 2020Q1")) graph_export(`lang'_sdid_, .png)

        cd "$path/output/tables"

        esttab est_sdid using `lang'_sdid.tex, replace

        restore
}

cd "$path"