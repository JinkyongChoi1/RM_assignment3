* 1. Load the code 

cd "/Users/jc5901/Documents/GitHub/RM_assignment3"
insheet using sports-and-education.csv, clear

* 2. Balance tables 

global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch

esttab . using test.rtf, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

* 4. propensity score model 

reg alumnidonations2018 academicquality athleticquality nearbigmarket ranked2017 

logit ranked2017 academicquality athleticquality nearbigmarket 
predict propensity_score, pr

* 5. Use stacked histograms to show overlap in the between ranked and unranked schools. 
* From here, you could consider dropping all observations that lie within regions containing no-overlap. 

twoway (histogram propensity_score if ranked2017==1, color(green%30)) ///
       (histogram propensity_score if ranked2017==0, color(red%30)), ///
	   legend(order(1 "Treatment" 2 "Control" ))
drop if propensity_score < 0.2 
drop if propensity_score > 0.8 

* 6. Group your observations into ``blocks'' based on propensity score. 
sort propensity_score
gen block = floor(_n/5), replace 

* 7. Analyze the treatment effect of being ranked on alumni donations,
* while controlling for block-fixed effects as well as other covariates. Include this table in your writeup. . Do not forget to write code to label your variables and to write the table notes describing what is in the table.

reg alumnidonations2018 ranked2017 i.block academicquality athleticquality nearbigmarket i.collegeid 
