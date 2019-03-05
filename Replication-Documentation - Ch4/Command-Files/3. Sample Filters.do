********************************************************************************
********************          3. SAMPLE FILTERS      		  ******************
********************************************************************************
clear
global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global Output "${path}\Output"

use  "$Output\Panel_sample.dta"
set more off

********************************************************************************
********************************************************************************
********************************************************************************

//Filter 0: all

//Sample Filters: Firms with innovation expenditures
keep if innovative==1


* Balanced Panel- Restriction
bysort ident: gen nyear=[_N]
browse ident year nyear
tab nyear 
keep if nyear==11

sort year
by year: tab muestra 
by year: tab tam200 
by year: tab tech

//Sample Analysis****
label define muestra1 1 "Only MEG" 2 "Only MID" 3 "MED & MID" 4 "MIDE" 5 "MEP" 
label values muestra muestra1
xttab muestra
sort year
by year: tab muestra
//Setting the panel data
sort ident year
xtset ident year
xtdes

**Saving Completed panel
*sort ident year
save   "$Output\Panel_filtered_all.dta", replace

********************************************************************************
********************************************************************************
//Filter 1: SME

clear
global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global Output "${path}\Output"

use  "$Output\Panel_sample.dta"
set more off

//Sample Filters: Firms with innovation expenditures
keep if innovative==1
keep if tam200==0

* Balanced Panel- Restriction
bysort ident: gen nyear=[_N]
browse ident year nyear
tab nyear 
keep if nyear==11

sort year
by year: tab muestra 
by year: tab tam200 
by year: tab tech

//Sample Analysis****
label define muestra1 1 "Only MEG" 2 "Only MID" 3 "MED & MID" 4 "MIDE" 5 "MEP" 
label values muestra muestra1
xttab muestra
sort year
by year: tab muestra
//Setting the panel data
sort ident year
xtset ident year
xtdes

**Saving Completed panel
*sort ident year
save   "$Output\Panel_filtered_SMEs.dta", replace

********************************************************************************
********************************************************************************
//Filter 2: Large

clear
global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global Output "${path}\Output"

use  "$Output\Panel_sample.dta"
set more off

//Sample Filters: Firms with innovation expenditures
keep if tam200==1
keep if innovative==1

* Balanced Panel- Restriction
bysort ident: gen nyear=[_N]
browse ident year nyear
tab nyear 
keep if nyear==11

sort year
by year: tab muestra 
by year: tab tam200 
by year: tab tech

//Sample Analysis****
label define muestra1 1 "Only MEG" 2 "Only MID" 3 "MED & MID" 4 "MIDE" 5 "MEP" 
label values muestra muestra1
xttab muestra
sort year
by year: tab muestra
//Setting the panel data
sort ident year
xtset ident year
xtdes

**Saving Completed panel
*sort ident year
save "$Output\Panel_filtered_large.dta", replace
clear
global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
global Output "${path}\Output"

use  "$Output\Panel_sample.dta"
set more off

//Sample Filters: Firms with innovation expenditures
keep if tam200==1
save "$Output\Panel_filtered_large_all.dta", replace
********************************************************************************
