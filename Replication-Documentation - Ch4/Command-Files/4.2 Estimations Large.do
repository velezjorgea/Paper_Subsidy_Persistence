********************************************************************************
*********                      4.2. ESTIMATIONS                       **********
*********   				DO FILE: Estimations: large     			  **********
********************************************************************************

clear all
capture log close

set mem 500m
set matsize 500
set more off
cd "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
log using survival.log, replace


clear
//Globals

global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global Output "${path}\Output"

use  "$Output\Panel_filtered_large.dta", replace

//Generating Spell Variables
by ident: gen byte begin= (bsupport==1) & (bsupport != bsupport[_n-1])
by ident: gen spell= cond(bsupport==1, sum(begin), 0)
by ident spell (year), sort: gen seq = cond(spell, _n, 0)
sort ident year


tsspell bsupport
drop if seq==0

//Generating Identificators for each spell
ge id = _n if seq==1
sort id
by id: gen newid = 1 if _n==1
replace newid = sum(newid)
replace newid = . if missing(id)
sort ident year
replace newid = newid[_n-1] if begin==0
replace id = newid
sort ident year

//Generating Censoring variables
by ident, sort: egen spellnum = max(spell)
bysort ident: ge died = _end==1 & spell>0
by ident: egen maxrun= sum(bsupport)
gen max= (maxrun==11)
by ident, sort: egen lastspellend = max(cond(died, year, .))
by ident, sort: egen firstspell = min(cond(bsupport,year,.))
gen rightcensored= (lastspellend== 2015)
gen leftcensored= (firstspell==2005)
sort ident
by ident: gen completed = (rightcensored==0 & leftcensored==0 & spellnum>0)
by ident: gen leftright = (rightcensored==1 & leftcensored==1 & spellnum>0)


tab leftright
gen sample= (completed==1 | rightcensored==1)

//Generating
gen seqvar= seq
lab var seqvar "spell year identifier, by subsidy"
sort id
quietly by id: ge dead = bsupport & _n==_N
lab var dead "binary depvar for discrete hazard model"


stset seqvar, f(dead) id(id)
stsum
ge logt = ln(seqvar)
lab var logt "ln(t)"

xttab spellnum //number of spells

tab seqvar, generate(dt)

// Variables
gen young= (age<10)

global XTLIST1 ln_gintidt_1 bidcont innova_techt_1 researchers_ptt_1 higher_educationt_1 ///
		bipt_1 cooperationt_1 ln_sizet_1 young evolcifra investt_1 financial_constraintst_1 ///
		dominated_barriert_1 uncertainty_barriert_1 ///
		group bextranj exporter ManufAT ManufTM ServAT ServRest bsupport_ue ///
		yearly2 yearly3 yearly4 yearly5 yearly6 yearly7 yearly8 yearly9 
		

********************************************************************************		
***Part 1: Survival Models
********************************************************************************		

		
//Fit complementary log-log model with robust variance estimates
display "Started at $S_TIME"
cloglog dead logt $XTLIST1 leftcensored if year>2005, vce(cluster id) 
*estimates store a1
predict h, p
cloglog, eform
display "Finished at $S_TIME"
bysort id (seqvar): ge s= exp(sum(ln(1-h))) //Survival rate
estat ic

//Normal Distributed frailty
display "Started at $S_TIME"
xtcloglog dead logt  $XTLIST1 leftcensored if year>2005
estimates store a2
estat ic
display "Started at $S_TIME"

//Gamma distributed frailty
display "Started at $S_TIME"
pgmhaz8 logt $XTLIST1 leftcensored if year>2005, id(id) seq(seqvar) dead(dead) iter(200) tech(dfp) difficult
estimates store a3 
display "Finished at $S_TIME"
estat ic


//Log-logit with mass point frailty
display "Started at $S_TIME"
hshaz logt $XTLIST1 leftcensored if year>2005, id(id) seq(seqvar) dead(dead) iter(200) tech(dfp) difficult
estimates store a4
display "Finished at $S_TIME"
estat ic
mat b = e(b)
mat list b
scalar n = colsof(b) - 1
scalar list n
mat b = b[1,2..n]
mat list b
mat score xb = b
*sum xb if seqvar == 1
ge z0 = xb + _b[logt]*logt
sort id seqvar
by id: gen p0 = 1 - exp(-exp(z0))
lab var p0 "Predicted h(t)"
by id: ge s0 = exp(sum(ln(1-p0)))
lab var s0 "Predicted S(t)"


//Random Effects model

display "Started at $S_TIME"
xtprobit dead logt $XTLIST1 leftcensored if year>2005
estimates store a5
display "Finished at $S_TIME"
estat ic


//Tables 

esttab a* using "$Output/table1_large.csv", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: Survival large}) ////
		wrap legend nogaps label ///
		addnotes("Source: The author")

esttab a* using "$Output/table1_large.tex", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: Survival large}) ////
		wrap legend nogaps label ///
		addnotes("Source: The author")

		
********************************************************************************		
***Part 2: Innovation Outcomes and survival
********************************************************************************		
		

sort ident year
quietly by ident year:  gen dup = cond(_N==1,0,_n)
drop if dup>1

global XTLIST2 ln_gintidt_1 researchers_ptt_1 higher_educationt_1 ///
				bipt_1 ln_sizet_1 young evolcifra group bextranj ///
				exportert_1 ManufAT ManufTM ServAT ServRest

sort ident year
xtset ident year

global vars ln_size ln_age ln_gintidpt higher_education
by ident: gen innova_tech0=innova_tech[1]
by ident: gen novelty0 = novelty[1]
by ident: gen novelty_emp0 = novelty_emp[1]
by ident: gen novelty_mark0 = novelty_mark[1] 
by ident: gen newmer0=newmer[1]
by ident: gen newemp0=newemp[1]


reg  innova_tech l.innova_tech $XTLIST2 
global mundlak1 " "

foreach x in $vars {
	by ident: egen `x'mean1=mean(`x') if e(sample) 
	global mundlak1 "$mundlak1 `x'mean1"
}

reg  newmer l.newmer $XTLIST2 
global mundlak2 " "

foreach x in $vars {
	by ident: egen `x'mean2=mean(`x') if e(sample) 
	global mundlak2 "$mundlak2 `x'mean2"
}

reg  newemp l.newemp $XTLIST2 
global mundlak3 " "
foreach x in $vars {
	by ident: egen `x'mean3=mean(`x') if e(sample) 
	global mundlak3 "$mundlak3 `x'mean3"
}

reg  novelty l.novelty $XTLIST2 
global mundlak4 " "
foreach x in $vars {
	by ident: egen `x'mean4=mean(`x') if e(sample) 
	global mundlak4 "$mundlak4 `x'mean4"
}

reg  novelty_emp l.novelty_emp $XTLIST2 
global mundlak5 " "
foreach x in $vars {
	by ident: egen `x'mean5=mean(`x') if e(sample) 
	global mundlak5 "$mundlak5 `x'mean5"
}

reg  novelty_mark l.novelty_mark $XTLIST2 
global mundlak6 " "
foreach x in $vars {
	by ident: egen `x'mean6=mean(`x') if e(sample) 
	global mundlak6 "$mundlak6 `x'mean6"
}

global X l1.ln_gintid l1.researchers_pt l1.higher_education l1.bip ///
			l1.cooperation depth breadth l1.ln_size young evolcifra group bextranj l1.exporter ///
			ManufAT ManufTM ServAT ServRest 

display "Started at $S_TIME"
xtprobit innova_tech s l.innova_tech $X innova_tech0 $mundlak1 if year>2005
estimates store b1 
display "Finished at $S_TIME"

display "Started at $S_TIME"
xttobit newmer  s l.newmer $X newmer0 $mundlak2 if year>2005, ul(100)  
estimates store b2 
display "Finished at $S_TIME"

display "Started at $S_TIME"
xttobit newemp s l.newemp  $X newemp0 $mundlak3 if year>2005, ul(100) 
estimates store b3
display "Finished at $S_TIME"

display "Started at $S_TIME"
xttobit novelty s l.novelty  $X novelty0 $mundlak4 if year>2005, ul(100) 
*estimates store b4
display "Finished at $S_TIME"

display "Started at $S_TIME"
xtprobit novelty_emp s l.novelty_emp  $X novelty_emp0 $mundlak5 if year>2005
*estimates store b5
display "Finished at $S_TIME"

display "Started at $S_TIME"
xtprobit novelty_mark s l.novelty_mark $X novelty_mark0 $mundlak6 if year>2005
*estimates store b6
display "Finished at $S_TIME"


//Tables
esttab b* using "$Output/table2_large.csv", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: Innovation Outcomes large}) ////
		wrap legend nogaps label ///
		addnotes("Source: The author")


esttab b* using "$Output/table2_large.tex", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: Innovation Outcomes large}) ////
		wrap legend nogaps label ///
		addnotes("Source: The author")

********************************************************************************		
***Part 3: Stop of Innovation projects and Survival
********************************************************************************		

global XTLIST31 ln_gintidt_1 researchers_ptt_1 higher_educationt_1 bipt_1 ///
				cooperationt_1 ln_sizet_1 young evolcifra financial_constraintst_1 ///
				knowledge_barrierst_1 dominated_barriert_1 uncertainty_barriert_1  ///
				group bextranj exportert_1  ManufAT ManufTM ServAT ServRest i.year 
		
global XTLIST32 z_cost ln_gintidt_1 researchers_ptt_1 higher_educationt_1 bipt_1 ///
				cooperationt_1 ln_sizet_1 young  evolcifra knowledge_barrierst_1 ///
				dominated_barriert_1 uncertainty_barriert_1 group bextranj exportert_1 ///
				ManufAT ManufTM ServAT ServRest i.year 


sort ident year
global vars ln_size ln_age ln_gintidpt higher_education financial_constraints ///
			knowledge_barriers dominated_barrier uncertainty_barrier
gen lagfailure=L.failure
gen lagconsin1=L.consin1
gen lagconsin2=L.consin2

by ident: gen bsupport0=bsupport[1] 
by ident: gen bfailure0=failure[1] 
by ident: gen costbarriers0=financial_constraints[1] 


reg failure lagfailure $XTLIST31 
global mundlak " "

foreach x in $vars {
	by ident: egen `x'mean=mean(`x') if e(sample) 
	global mundlak "$mundlak `x'mean"
}


rangestat (mean) z_cost = financial_constraints, interval( year -1 1) by(act) excludeself
label var z_cost "Averaged Cost Barriers"



cmp (consin1= lagconsin1 s $XTLIST31 $mundlak costbarriers0 bfailure0 ) ///
		(financial_constraints= s $XTLIST32 $mundlak costbarriers0  ) if year>2005 ///
	, ind($cmp_probit $cmp_probit) cluster(ident) nolr 
estimates store cmpdyn1
margins, dydx (*) predict (eq(#1) pr) post
estimates store cmpmdyn1


cmp (consin2= lagconsin2 s $XTLIST31 $mundlak costbarriers0 bfailure0) ///
		(financial_constraints= s $XTLIST32  $mundlak costbarriers0  ) if year>2005 ///
	, ind($cmp_probit $cmp_probit) cluster(ident) nolr 
estimates store cmpdyn2
margins, dydx (*) predict (eq(#1) pr) post
estimates store cmpmdyn2

cmp (failure= lagfailure s $XTLIST31 $mundlak costbarriers0 bfailure0 ) ///
		(financial_constraints= s $XTLIST32 $mundlak costbarriers0  ) if year>2005 ///
	, ind($cmp_probit $cmp_probit) cluster(ident) nolr 
estimates store cmpdyn3
margins, dydx (*) predict (eq(#1) pr) post
estimates store cmpmdyn3

//TABLES
//Simultaneous Estimation: Marginal effects
esttab cmpmdyn* using "$Output/table3_large_ME.csv", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: CDM-Dynamic: marginal effects large}) ////
		mtitles("Failure conception" "Failure Implementation" "Failure overall" "Failure conception" "Failure Implementation" "Failure overall" "Failure conception" "Failure Implementation" "Failure overall") wrap legend nogaps label ///
		addnotes("Source: Own Collaboration, given data")

esttab cmpdyn* using "$Output/table3_large_coeff.csv", starlevels(* 0.10 ** 0.05 *** 0.01) ///
		replace b(3) se(3) stat(N N_clust df_m r2_a widstat j jp, fmt(0 0 0 2 3 3 3)) ///
		num title({Table: CDM-Dynamic: Coefficients large}) ///
		mtitles("Failure conception" "Failure Implementation" "Failure overall" "Failure conception" "Failure Implementation" "Failure overall" "Failure conception" "Failure Implementation" "Failure overall") wrap legend nogaps label ///
		addnotes("Source: Own Collaboration, given data")
********************************************************************************
** END
********************************************************************************
