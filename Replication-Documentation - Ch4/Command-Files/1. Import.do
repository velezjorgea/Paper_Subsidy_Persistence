********************************************************************************
**********             Building the Panel-data set                  ************ 
**********                 DO-file: 1. Import                       ************
********************************************************************************

clear
set more off 

********************************************************************************
***********               Building-up the Sample                   *************
********************************************************************************

//Loading 2005
global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global rawdata "${path}\Original-Data"
global Output "${path}\Output"

use   "${rawdata}\2005.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct  ///
	 invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim ///
	 invlim dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi /// 
	 fipsfl idbio gidbio nestr ngest norg nmark neste pidmej*  invm* ///
	 invejc* invmej* tint* pidm* pidejc* pidmej* pidmcaej becm ///
	 becejc becmejc impobeca redper calidad costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10

keep if incine== "LI"
tab muestra


***Saving the new data set.
save   "${Output}\2005_2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************

clear 
***Loading 2006**
use   "${rawdata}\2006.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio ///
gidbio nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint* ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2006_2.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************

clear

//Loading 2007**
use   "${rawdata}\2007.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct  ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio ///
gidbio nestr ngest norg nmark neste pidmej* invm* invejc* invmej* ///
tint* pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper ///
calidad costes satisfac inorg1 inorg2 inorg3 incom1 incom2

//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 9
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2007_2.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
clear 

//Loading 2008**
use   "${rawdata}\2008.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint*  ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2008_2.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
clear 
//Loading 2009**
use   "${rawdata}\2009.dta"

drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint* ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2009_2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************
clear 
//Loading 2010**
use   "${rawdata}\2010.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint*  ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2010_2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************
clear 
***Loading 2011**
use   "${rawdata}\2011.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej*  invm* invejc* invmej* tint* ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2


//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra


***Saving the new data set.
save   "${Output}\2011_2.dta", replace

********************************************************************************
********************************************************************************
********************************************************************************
clear 
***Loading 2012**
use   "${rawdata}\2012.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
 nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint*  ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2  consul nconsulejc costconsul ///
quien* coopnew* 

//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra


***Saving the new data set.
save   "${Output}\2012_2.dta", replace


********************************************************************************
********************************************************************************
********************************************************************************
***Loading 2013**
use   "${rawdata}\2013.dta"

drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej*  invm* invejc* invmej* tint*  ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2  consul nconsulejc costconsul ///
quien* coopnew* 

//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra

***Saving the new data set.
save   "${Output}\2013_2.dta", replace
clear 

***Loading 2014**
use   "${rawdata}\2014.dta"

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint* ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2  consul nconsulejc costconsul ///
quien* coopnew* 

//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra


***Saving the new data set.
save   "${Output}\2014_2.dta", replace
clear

***Loading 2015**
use   "${rawdata}\2015.dta", clear
gen year= 2015

//Dropping do not needed variables
drop mujeres bio innprodm innprodc innprodt desaproc innprocm innprocc innproct ///
invtm invtmej tectm tectmejc auxtm auxtmejc pidtm pidtmejc docm invdocm lim invlim ///
dim invdi invdim ot otm invot invotm tpm tinv pidmca invmca femp funi fipsfl idbio gidbio ///
nestr ngest norg nmark neste pidmej* invm* invejc* invmej* tint* ///
pidm* pidejc* pidmej* pidmcaej becm becejc becmejc impobeca redper calidad ///
costes satisfac inorg1 inorg2 inorg3 incom1 incom2  consul nconsulejc costconsul ///
quien* coopnew* 

//Filtering the incidence indicator: Sample of only those companies that have no ///
//incidence LI == 10
keep if incine== "LI"
tab muestra


***Saving the new data set.
save   "${Output}\2015_2.dta", replace


********************************************************************************
*********************        Building Up the Panel         *********************
********************************************************************************

//Option Append: combine datasets vertically and backward looking

**Loading initial year "Year=2015"
use "${Output}\2015_2.dta", clear

***Loading 2014**
append using "${Output}\2014_2.dta"

***Loading 2013**
append using "${Output}\2013_2.dta"

***Loading 2012**
/*The update of the PITEC data file corresponding to the year 2012 is due to the 
correction of data on the number of employees and turnover for the year 2012.*/

append using  "${Output}\2012_2.dta"

***Loading 2011**
append using  "${Output}\2011_2.dta"

***Loading 2010**
append using  "${Output}\2010_2.dta"

***Loading 2009**
append using  "${Output}\2009_2.dta"

***Loading 2008**
append using  "${Output}\2008_2.dta"

***Loading 2007**
append using  "${Output}\2007_2.dta"

***Loading 2006**
append using  "${Output}\2006_2.dta"

***Loading 2005**
append using  "${Output}\2005_2.dta"

**Long format

sort ident year

//Saving the final Panel 

save   "${Output}\PanelRaw.dta", replace

order ident year
xtset ident year
sort ident year

//Summarizing the Samples obtained
label define muestra1 1 "Only MEG" 2 "Only MID" 3 "MED & MID" 4 "MIDE" 5 "MEP" 
label values muestra muestra1
xttab muestra
sort year
by year: tab muestra, miss
