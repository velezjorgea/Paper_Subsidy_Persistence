********************************************************************************
*********                      2. CLEANING                            **********
*********   DO FILE: Cleaning and definition of variables needed      **********
********************************************************************************
 
clear

//Globals

global path "C:\Users\velez\Desktop\Paper 4.2\Replication-Documentation - Ch4"
**Data Analysis  folder******

global analysis "${path}\Analysis-Data"

**Codes  folder******

global dofiles "${path}\Command-Files"

**Original Data folder ******

global rawdata "${path}\Original-Data"

**Transformed Data folder ******

global Output "${path}\Output"


**Documents folder ******

global document "${path}\Documents"


global Output "${path}\Output"


// PanelRaw must be loaded

use  "$Output\PanelRaw.dta"
set more off 

**Codificating string values****

encode pais, gen(pais2)
encode incine, gen(incine2)
label var incine2 "Incidence Indicator"
label var pais2 "Country of the firm"

//dummies for each year
tab year, gen(yearly)

//1. Proxies for exports
//labelling market variables
label var mdoue "Market UE"
label var otropais "Market other non EU countries"

gen exporter= (mdoue==1 | otropais==1)
label var exporter "Firm has exported either UE or Other third party countries"

//2. Techology-related activity
/* Generating new variable of Industrial Activity ACTI + ACTIN 93-2008 leaving 
as industrial activity in the years 2005, 2006, 2007 the industrial activity of 
NACE 2008 */

gen act=actin if !missing(actin)
	replace act= actin[_n+3] if missing(act) & year==2005
	replace act= actin[_n+2] if missing(act) & year==2006 
	replace act= actin[_n+1] if missing(act) & year==2007
	
/*This creates act for companies that are before 2008 but still in 2008
 On the other hand, for those that cease to be from 2008, it is necessary to 
 assign them manually the act code.*/
replace act= 0 if acti==0 & missing(act)
replace act= 1 if acti==1 & missing(act)
replace act= 3 if acti==2 & missing(act)
replace act= 3 if acti==3 & missing(act)
replace act= 4 if acti==4 & missing(act)
replace act= 5 if acti==5 & missing(act)
replace act= 6 if acti==6 & missing(act)
replace act= 7 if acti==7 & missing(act)
replace act= 8 if acti==8 & missing(act)
replace act= 9 if acti==9 & missing(act)
replace act= 2 if acti==10 & missing(act)
replace act= 10 if acti==11 & missing(act)
replace act= 11 if acti==12 & missing(act)
replace act= 12 if acti==13 & missing(act)
replace act= 13 if acti==14 & missing(act)
replace act= 13 if acti==15 & missing(act)
replace act= 14 if acti==16 & missing(act)
replace act= 14 if acti==17 & missing(act)
replace act= 15 if acti==18 & missing(act)
replace act= 18 if acti==19 & missing(act)
replace act= 16 if acti==20 & missing(act)
replace act= 17 if acti==21 & missing(act)
replace act= 16 if acti==22 & missing(act)
replace act= 16 if acti==23 & missing(act)
replace act= 16 if acti==24 & missing(act)
replace act= 19 if acti==25 & missing(act)
replace act= 20 if acti==26 & missing(act)
replace act= 21 if acti==27 & missing(act)
replace act= 22 if acti==28 & missing(act)
replace act= 23 if acti==29 & missing(act)
replace act= 24 if acti==30 & missing(act)
replace act= 24 if acti==31 & missing(act)
replace act= 27 if acti==32 & missing(act)
replace act= 26 if acti==33 & missing(act)
replace act= 28 if acti==34 & missing(act)
replace act= 29 if acti==35 & missing(act)
replace act= 29 if acti==36 & missing(act)
replace act= 29 if acti==37 & missing(act)
replace act= 31 if acti==38 & missing(act)
replace act= 30 if acti==39 & missing(act)
replace act= 30 if acti==40 & missing(act)
replace act= 16 if acti==41 & missing(act)
replace act= 32 if acti==42 & missing(act)
replace act= 35 if acti==43 & missing(act)
replace act= 28 if acti==44 & missing(act)
replace act= 39 if acti==45 & missing(act)
replace act= 33 if acti==46 & missing(act)
replace act= 33 if acti==47 & missing(act)
replace act= 37 if acti==48 & missing(act)
replace act= 38 if acti==49 & missing(act)
replace act= 38	if acti==50 & missing(act)
replace act= 39 if acti==51 & missing(act)
replace act= 40 if acti==52 & missing(act)
replace act= 34 if acti==53 & missing(act)
replace act= 34 if acti==54 & missing(act)
replace act= 41 if acti==55 & missing(act)

label var act "Firm's activity"
*	please veriry you do not have missing data for this variable
tab act, missing 


//3. Industries according to their technology level.

/*

Generating dummies for different sectors:

- tech=1 "High-tech manufacturing"
- tech=2 "Medium-tech manufacturing"
- tech=3 "Rest of Manufacturing" 
- tech=4 "High-tech services"
- tech=5 "Rest of services"
- tech=6 "Energy, sanitation and construction"
*/

gen tech= 1 if act== 11 | act==16 | act==21
replace tech= 2 if act==10 | act==17 | act==18 | act==19 |  act==20 
*
replace tech= 3 if act>=3 & act<=9
replace tech= 3 if act>=12 & act<=15
replace tech= 3 if act==22 | act==23 | act==24 
* services
replace tech= 4 if act==32 | act==33 | act==34 | act==37
replace tech= 5 if act==25 | act==29 | act==30 | act==31 
replace tech= 5 if act==35 | act==36
replace tech= 5 if act>=38 & act<=43
*
replace tech= 6 if act==26 | act==27 | act==28

label define tech1 1 "high-tech manufacturing" 2 "medium-tech manufacturing" ///
3 "Rest of Manufacturing" 4 "High tech services" 5 "Rest of Services" /// 
6 "Energy, sanitation, and construction" 

label values tech tech1
tab tech, missing
table year tech

* Dummies for each sector
gen ManufAT=tech==1
gen ManufTM=tech==2
gen ManufRest=tech==3
gen ServAT=tech==4
gen ServRest=tech==5

label var ManufAT "high-tech manufacturing"
label var ManufTM "medium-tech manufacturing"
label var ManufRest "Rest of Manufacturing"
label var ServAT "High tech services"
label var ServRest "Rest of Services"


//4: Age
/*Imputing year of creation of the company: Variable creation anio2 with 
verification that it is done correctly.*/
generate anio2 = aniocrea
sort ident anio2
*browse ident year aniocrea anio2
by ident: replace anio2 = anio2[1] if anio2==.
*browse ident year aniocrea anio2
label var anio2 "year of creation with imputation"
inspect anio2
inspect anio2 if year<2009
/*You will see that there are only 3641 missing, which correspond to companies 
that were in the panel before 2009 but afterwards no longer.*/

sort ident year
//Generating age of the company
gen age = year-anio2
label var age "Age"
sum age, detail

//Logarithm of Age
gen ln_age= ln(age)
label var ln_age "Logarithm of Age"
inspect ln_age

gen age2= age^2
gen ln_age2= ln(age2)
label var ln_age2 "Age square"

// 5. type of firm
gen bpublica=clase==1
 replace bpublica=1 if clasen==1
gen bprivnac=clase==2
 replace bprivnac=1 if (clasen==2 | clasen==3 |clasen==4)
gen bextranj=clase==3 
 replace bextranj=1 if clasen==5 
gen basociac=clase==4
 replace basociac=1 if clasen==6 
 
label var bpublica "Binary: Public firm"
label var bprivnac "Binary: national private sector, includes companies with foreign capital participation of less than 50%"
label var bextranj "Binary: Foreign" //includes multinational companies, and with participation of foreign capital greater than 50%" 
label var basociac "Binary: Includes research associations & other entities"

tab bpublica, missing
tab bprivnac, missing
tab bextranj, missing
tab basociac, missing

table year bpublica
 

// 6. Dummies related to R&D
inspect gintid
gen bgintid=(gintid>0) 
label var bgintid "With internal R&D"
inspect bgintid

inspect gextid
gen bgextid=gextid>0 
label var bgextid "With external R&D"
inspect bgextid

// 7. Expenditures on innovation
inspect gtinn
gen bgtinn=gtinn>0
label var bgtinn "With expenditures on innovation"
inspect bgtinn


// 8. Source of information
/*Breadth takes values from 0 to 10, based on the number of sources of information 
for innovation used by the firm in the period considered. Depth also ranges 
from 0 to 10, based on the number of information sources the firm rated as highly 
important in the the period considered.
*/

global vars "fuente1 fuente2 fuente3 fuente4 fuente5 fuente6 fuente7 fuente8 fuente9 fuente10 fuente11"
foreach x in $vars {
	gen s`x'= `x'<4
	}

gen breadth= sfuente2 + sfuente3 + sfuente4 + sfuente5 + sfuente6 + sfuente7 + sfuente8 + sfuente9 + sfuente10 + sfuente11
label var breadth "breadth 0-10"
tab breadth, miss


global vars "fuente1 fuente2 fuente3 fuente4 fuente5 fuente6 fuente7 fuente8 fuente9 fuente10 fuente11"
foreach x in $vars {
	gen si`x'= (`x'==1)
	}
	
gen depth = sifuente2 + sifuente3 + sifuente4 + sifuente5 + sifuente6 + sifuente7 + sifuente8 + sifuente9 + sifuente10 + sifuente11
label var depth "depth 0-10"
tab depth, miss


// 9. Innovation Outputs
* Innovative Firm (Binary)
gen binnovadora=(innprod==1 | innobien==1 | innoserv==1 | innproc==1)
label var binnovadora "Binary if the company made some kind of innovation"
inspect binnovadora

gen innova_tech= (innprod==1 | innproc==1)
label var innova_tech "Binary if the firm has introduced innovations during the period"
tab innova_tech, miss

//10. Type of Innovation

gen bidcont=tipoid==1
label var bidcont "Binary: Continous R&D"
inspect bidcont

gen bidocasio=tipoid==2
label var bidocasio "Binary: Exporadic R&D"
inspect bidocasio


// 11.Organizational innovation

tab innprod, miss
tab innproc, miss
tab inorgn1, miss
tab inorgn2, miss
tab inorgn3, miss

gen binnorg= (inorgn1==1 | inorgn2==1 | inorgn3==1)
label var binnorg "Organizational innovation"

gen internal_id= (idintern==1)
label var internal_id "Internal R\&D"


// 12. Personnel

gen researchers= (invtejc*pidt)/100
gen ln_researchers= ln(1 + researchers)
gen researchers_ratio= invtejc/100

gen researchers_pt= researchers/tamano
label var researchers_pt "R&D researchers over total size"
// 13. Public Support for Innovation
/* It is generated from fap in 2006 and fonpubli in 2005 and for years after 2006 */

inspect fap
inspect fonpubli

gen bsupport= .
replace bsupport= (fap>0) if year==2006
replace bsupport= (fonpubli>0) if year==2005
replace bsupport= (fonpubli>0) if year>2006
label var bsupport "Binary: Public support"
inspect bsupport

gen bsupport_ace= (fina2>0)
gen bsupport_local= (fina1>0)
*gen bsupport_ue= (fina3>0)

//Other public support

gen bsupport_ue= (fonextr>0) if year==2005
replace bsupport_ue= (fue>0) if year==2006 
replace bsupport_ue= (fonextr>0) if year>2006
inspect bsupport_ue
label var bsupport_ue "Support from UE"

/* 14. OBSTACLES: Creation of obstacle dummies: Obstacles: Importance of the factors
  Category: 1 = High, 2 = intermediate, 3 = reduced 4 = not relevant, White.
  first see originals to see if there are missings and distribution of the answers */

inspect face1-otrofac4
* check we do not have missings
	
//Generating dummies for each obstacle. 
gen  bfinin=(face1==1)
gen  bfinex=(face2==1)
gen  bcost=(face3==1)
gen  bpers=(faci1==1)
gen  binftec=(faci2==1)
gen  binfmer=(faci3==1)
gen  bsocio=(faci4==1)
gen  bdomin=(otrofac1==1)
gen  bddrisk=(otrofac2==1)
gen  binprev=(otrofac3==1)
gen  bnodem=(otrofac4==1)

label var  bfinin "Binaria obstacle high: Internal funding"
label var  bfinex "O. extenal funding"
label var  bcost "Binary obstacle high: high-cost of innovation"
label var  bpers "Binary obstacle high: lack of qualified personnel"
label var  binftec "Binary obstacle high: lack of information on technology"
label var  binfmer "Binary obstacle high: lack of information on markets"
label var  bsocio "Binary obstacle high: difficulty in finding partners for innovation cooperation"
label var  bdomin "Binary obstacle high: Market dominated by established companies"
label var  bddrisk "Binary obstacle high: uncertain demand for innovative goods and services"
label var  binprev "Binary obstacle high: No needed becauses"
label var  bnodem "Dummy:  High lack of demand for innovations"


// 15. Dummy for internal and external obstacles

inspect bfinin
inspect bfinex
gen bfinancia=0
replace bfinancia=1 if bfinin==1 | bfinex==1
label var bfinancia "Dummy high internal and external financial obstacles"
inspect bfinancia

//Obstacles
gen financial_constraints= (face1==1 | face2==1)
label var financial_constraints "Financial constraints"
tab financial_constraints, miss

gen knowledge_barriers= (faci1== 1 | faci2==1 | faci3==1 | faci4==1)
label var knowledge_barriers "Knowledge barriers"
tab knowledge_barriers, miss

gen dominated_barrier= (otrofac1==1)
label var dominated_barrier "markets perceived as being dominated"
tab dominated_barrier, miss

gen uncertainty_barrier= (otrofac2==1)
label var uncertainty_barrier "uncertain demand"
tab uncertainty_barrier, miss

// 16. Non-innovative

gen noninnovative= (otrofac3== 1 | otrofac3==1)
tab noninnovative, miss

// 17. SIZE: Generating Size of the firm. 

rename tamano size
inspect size

gen size20= 0
replace size20= 1 if size<=20
label var size20 "Size x<20 emp."

gen size50= 0
replace size50=1 if size>20 & size<=50
label var size50 "Size 20<x<50 emp."

gen size100=0
replace size100=1 if size>50 & size<=100
label var size100 "Size 50<x<100 emp."

gen size200=0
replace size200=1 if size>100 & size<=200
label var size200 "Size 100<x<200 emp."

gen size400=0
replace size400=1 if size>200 & size<=400
label var size400 "Size 200<x<400 emp."

gen size700=0
replace size700=1 if size>400 & size<=700
label var size700 "Size 400<x<700 emp."

gen size1000=0
replace size1000=1 if size>700 
label var size1000 "Size x>700 emp."

**Logarithm of Size
inspect size 
gen ln_size= ln(1 + size)
inspect ln_size
label var ln_size "Log of Size"

gen size2= size^2
gen ln_size2= ln(1 + size2)
label var ln_size2 "Size square (log)"


*There are 3 companies that in 2007 did not register the number of employees 
tab inciemp if size==0
/* are companies that in 2007 made a change of activity or abandonment of the 
company that in 2007 entered the liquidation phase */

// 14. Human Capital 

**Imputing value of the percentage of employees with higher education (remusup) for the year 2005
tab remusup, missing
tab remusup if year==2005, missing
*Imputing value of the percentage of employees with higher education (remusup) for the year 2005
gen higher_education= remusup if !missing(remusup)
replace higher_education = remusup[_n+1] if remusup==. 
inspect higher_education
tab higher_education if year==2005, missing
tab higher_education if year==2008, missing
* There are 236 observations for which they are until 2005 and then disappeared

replace higher_education= (higher_education/100)
inspect higher_education 
label var higher_education "Higher education t"

/*Deflating series
**The GDP implicit deflator is the ratio of GDP in current local currency to GDP 
*in constant local currency. Source: world Bank 

*2005=90.7523966 	2006=94.3627122864731	 2007=97.5061572466056
*2008=99.5884263307221	2009=99.839928050897 2010=100 base	
*2011=100.028969173995	2012=100.07763446164 2013=100.647251717676
*2014= 100.24822305797

*Deflating sales*/


// 16. Sales 

inspect cifra
* (94 observations reported turnover in 0 "
generate cifracons=.
replace cifracons= cifra if year==2005
replace cifracons= (cifra/90.7523966)*100 if year==2005
replace cifracons= (cifra/94.3627122864731)*100 if year==2006
replace cifracons= (cifra/97.5061572466056)*100 if year==2007
replace cifracons= (cifra/99.5884263307221)*100 if year==2008
replace cifracons= (cifra/99.839928050897)*100 if year==2009
replace cifracons= (cifra/100)*100 if year==2010
replace cifracons= (cifra/100.028969173995)*100 if year==2011
replace cifracons= (cifra/100.096938028972)*100 if year==2012
replace cifracons= (cifra/100.450891156403)*100 if year==2013
replace cifracons= (cifra/100.255028111053)*100 if year==2014
replace cifracons= (cifra/100.867461777699)*100 if year==2015

label var cifracons "Sales constant prices"
inspect cifracons
*checking outliers
extremes cifracons

// 17. Total expenditures on innovation activities
inspect  gtinn
generate gtinncons=.
replace gtinncons= (gtinn/90.7523966)*100 if year==2005
replace gtinncons= (gtinn/94.3627122864731)*100 if year==2006
replace gtinncons= (gtinn/97.5061572466056)*100 if year==2007
replace gtinncons= (gtinn/99.5884263307221)*100 if year==2008
replace gtinncons= (gtinn/99.839928050897)*100 if year==2009
replace gtinncons= (gtinn/100)*100 if year==2010
replace gtinncons= (gtinn/100.028969173995)*100 if year==2011
replace gtinncons= (gtinn/100.096938028972)*100 if year==2012
replace gtinncons= (gtinn/100.450891156403)*100 if year==2013
replace gtinncons= (gtinn/100.255028111053)*100 if year==2014
replace gtinncons= (gtinn/100.867461777699)*100 if year==2015

label var gtinncons "Total Innovation expenditures (constant prices)"
inspect gtinncons

gen lngtinncons= ln(gtinncons)

// 18. Deflating fixed investments (Base year==2005)
inspect  inver
generate invercons=.
replace invercons= (inver/90.7523966)*100 if year==2005
replace invercons= (inver/94.3627122864731)*100 if year==2006
replace invercons= (inver/97.5061572466056)*100 if year==2007
replace invercons= (inver/99.5884263307221)*100 if year==2008
replace invercons= (inver/99.839928050897)*100 if year==2009
replace invercons= (inver/100)*100 if year==2010
replace invercons= (inver/100.028969173995)*100 if year==2011
replace invercons= (inver/100.096938028972)*100 if year==2012
replace invercons= (inver/100.450891156403)*100 if year==2013
replace invercons= (inver/100.255028111053)*100 if year==2014
replace invercons= (inver/100.867461777699)*100 if year==2015

label var invercons "Fixed investment (constant prices)"
inspect invercons

gen invest= (inver>0)
label var invest "Fixed investment"
// Intensity

// INNOVACION

// 19. Over sales
sum cifracons, detail
gen inteninnov=gtinn/cifra
sum inteninnov, detail
sum inteninnov if inteninnov>1, detail
label var inteninnov "Intensity of innovation expenditures"
inspect inteninnov
*94 missing due to observations without turnover

gen ln_inteninn= ln(1 + inteninnov)
label var ln_inteninn "Log innovation intensity"
inspect ln_inteninn



//20. Innovation expenditures per worker
gen gtinnpt= gtinncons/size
label var gtinnpt "Total Innovation expenditures per worker"
inspect gtinnpt
* (3 missing values due to the 3 observations that in 2007 do not record employment data)

gen ln_gtinnpt = ln(1 + gtinnpt) // +1
label var ln_gtinnpt "Log total innovation expenditures per worker+1"
inspect ln_gtinnpt 

gen zeros1= (gtinnpt==0)
tab zeros1 //(3 missing)

gen ln_gtinnptf = ln(gtinnpt)
label var ln_gtinnptf "Log total innovation expenditures per worker"
inspect ln_gtinnptf 

//R&D

// 21. R&D per worker

inspect gintid
gen gintidpt= (gtinncons*(gintid/100))/size
label var gintidpt "R&D expenditures per worker"
inspect gintidpt

gen ln_gintidpt= ln(1 + gintidpt) 
label var ln_gintidpt "Log R&D expenditures per worker+1"
inspect ln_gintidpt
sum ln_gintidpt, d
histogram ln_gintidpt


gen ln_gintid= ln(1 + (gtinncons*(gintid/100)))
label var ln_gintid "R&D expenditures (log)"

//22. Ratio public support
gen support_ratio=.
replace support_ratio= fap if year==2006
replace support_ratio= fonpubli if year==2005
replace support_ratio= fonpubli if year>2006
replace support_ratio= (support_ratio/100)
inspect support_ratio

// 23. R&D financed with own resources (from f1 and fprop)
gen gintidtot= (gintid*gtinncons)/100
label var gintidtot "Total R&D"

// 24. Total public support
gen support_tot=.
replace support_tot= (gintidtot*fap)/100 if year==2006
replace support_tot= (gintidtot*fonpubli)/100 if year==2005
replace support_tot= (gintidtot*fonpubli)/100 if year>2006
inspect support_tot

gen ln_support_tot= ln(1 + support_tot)

// 25. Innovation expenditures net of funding
gen privateinn= (gtinncons - support_tot)
label var privateinn "Innovation Spending net of funding"
inspect privateinn

gen lnprivateinn= ln(privateinn) 
label var lnprivateinn
inspect lnprivateinn

// 25. Innovation expenditures net of funding (per worker)
gen privateinn_pt= (gtinncons - support_tot)/size
label var privateinn_pt "Innovation Spending net of funding per worker"

gen ln_private_inn_pt = ln(1 + privateinn_pt) //
label var ln_private_inn_pt "Log 1 + innovation net of funding"
inspect ln_private_inn_pt

gen zeros2= (privateinn_pt==0)
tab zeros2 

// 25. Innovation expenditures net of funding (over sales)
gen inteninnov_priv= privateinn/ cifra
label var inteninnov_priv "Private innovation over sales"
inspect inteninnov_priv

gen privateid=.
replace privateid= (gintidtot*f1)/100 if year==2005
replace privateid= (gintidtot*fpro)/100 if year==2006
replace privateid= (gintidtot*f1)/100 if year>2006
inspect privateid

gen lnprivateid= ln(1 + privateid)
label var lnprivateid "Log R&D privately financed+1"
inspect lnprivateid 

gen intensidad_id= ((gtinncons*(gintid/100))/cifracons)
label var intensidad_id "R&D intensity"
inspect intensidad_id

gen ln_intensidad_id= ln(1 + intensidad_id)
label var ln_intensidad_id "log R&D intensity +1"
inspect ln_intensidad_id

gen ln_private_pt= ln(privateid /size) 
label var ln_private_pt "Log Private R&D intensity per worker"
inspec ln_private_pt

/* Generation of the ratio between the investment in R & D and total investment 
from gintid, gtinncons, invercons "gross investment in machinery and equipment" */

gen gintid_ratio= (gtinncons*(gintid/100))/(invercons+(gtinncons*(gintid/100)))
label var gintid_ratio "Ratio Innovation investment and Total investment"
sum gintid_ratio, d
histogram gintid_ratio

gen ln_gintid_ratio= ln(1 + gintid_ratio)
label var ln_gintid_ratio "Log Ratio Innovation investment and Total investment"

gen bgintid_rat=gintid_ratio>0
label var bgintid_rat "Dummy Investment ratio"
table year bgintid_rat
tabstat bgintid_rat if tam200==0, by(year) stat(n mean)
tabstat bgintid_rat if tam200==1, by(year) stat(n mean)


// Investment in machinery

// 26. Gross investment per worker
inspect invercons //(31660 zeros)

gen inverpt= invercons/size
label var inverpt "Gross investment in machinery per worker"
inspect inverpt //3 missing
sum invercons if size==0 & invercons==0

gen ln_inverpt = ln(1 + inverpt)
label var ln_inverpt "Log Gross investment in machinery per worker"
inspect ln_inverpt 

// 27. Investment intensity (over sales)
gen inteninver=inver/cifra
sum inteninver, detail
sum inteninver if inteninver>1, detail
label var inteninver "Gross investment intensity"
inspect inteninver
*(94 missing)*

gen ln_inteninver= ln(1 + inteninver)
label var ln_inteninver "Gross investment intensity"
inspect ln_inteninver
*(94 missing)*

// 28. Revenue based productivity

** Generating turnover per worker = sales / l "Labor productivity"
gen productivity= cifracons/size
label var productivity "labour productivity"
inspect productivity
*(94 observations reported 0 in turnover and 3 missing values because employment = 0)
gen ln_productivity= ln(1 + productivity)
label var ln_productivity "log labour productity"
inspect ln_productivity

bysort tech year: egen rpavg= mean(ln_productivity)
bysort ident year: gen rprod=ln_productivity/rpavg
label var rprod "Relative productivity"
// 29. Abandon Variables

gen abandono=consin1+consin2
tab year abandono, row  nokey

gen dabandono=abandono>0
tab abandono dabandono, missing

gen dabandono_ambas=.
replace dabandono_ambas=1 if consin1==1 & consin2==1
replace dabandono_ambas=0 if dabandono_ambas==.

//Ordinal Variable for Failure
gen failure_ord= .
replace failure_ord= 1 if consin1==0 & consin2==0
replace failure_ord=2 if consin1==1 & consin2==0
replace failure_ord=3 if consin1==0 & consin2==1
replace failure_ord=4 if consin1==1 & consin2==1
label define failure 1 "Do not abandon" 2 "Only during conception" 3 "Only during execution" 4 " During Conception and execution"
label values failure_ord failure

//Innocation Failure
gen failure= (consin1==1 | consin2==1)
label var failure "Innovation failure"
tab failure, miss

// 30. Generating variable new innovative products for the market
gen newmer_innov= newmer/100
label var newmer_innov "Market Innovativeness over sales"


gen newemp_innov= newemp/100
label var newemp_innov "Firm Innovativeness over sales"

/*  
It is convenient to make a description for companies that have a positive 
innovation expenditure for at least one of the years of the entire period,
as they do in the article by García-Vega y López. I think one way to do it 
would be to generate a variable that is the sum of the value of the binary 
of expenses of innovation bgtinn) of all years. We can name it sumbgtinn. 
At most its value would be 11, and the minimum 0.
*/

sort ident
bys ident: egen sumbgtinn=sum(bgtinn)
replace sumbgtinn=0 if sumbgtinn==. 

tab bgtinn
tab sumbgtinn

sort ident
bys ident: egen sumbgintid=sum(bgintid)
replace sumbgintid=0 if sumbgintid==. 


sort ident
bys ident: egen sumbgitid= sum(bgintid)
replace sumbgintid=0 if sumbgintid==.
tab bgintid
tab sumbgintid

// 31. Growth rate of Sales
gen lncifra=ln(1 + cifracons)
by ident: gen evolcifra=lncifra-lncifra[_n-1]
label var evolcifra "Sales Growth rate (log dif)"

by ident: gen tasacifra=((cifracons-cifracons[_n-1])*100)/cifracons[_n-1]
label var tasacifra "Variation rate in Sales"
sum tasacifra, d
gen outcifra=tasacifra>250.00 & !missing(tasacifra)
inspect outcifra
tab outcifra

// Ruling out outliers
gen extcifra=tasacifra<-100
tab extcifra

by ident: gen tasaempleo=((size-size[_n-1])*100)/size[_n-1]
gen outempleo=tasaempleo>250.00 & !missing(tasaempleo)
tab outempleo

replace tasaempleo= tasaempleo/100
label var tasaempleo "Variation rate in employment"

// 32. Sector
gen manufacturing= (ManufAT==1 | ManufTM==1 | ManufRest==1)
label var manufacturing "Manufacturing firm"
tab manufacturing, miss

gen services= (ServAT==1 | ServRest==1)
label var services "Service firm"
tab services, miss

// 33. Interaction term between external financing obstacles and sales growth
by ident: gen interaventas_bfinex=tasacifra*bfinex
label var interaventas_bfinex "Interaction term external financing and sales growth"

// 34. Dummy formal intellectual protection mechanisms (copyrights, brands, designs, patents)
gen bip= 1 if pat==1 | usomodel==1 | usomarca==1 | usoautor==1
replace bip=0 if bip==.
label var bip "Intellectual property rights"
tab bip 
inspect bip
 
// 35. R&D activities measured in full-time equivalent(FTE).
//Employees

gen humank= ln(1 + ((pidt-bec)*pidtejc/100))
label var humank "Total personnel in R&D FTE"

// 36. Dummy for years
tabulate year, gen(year)

// 37. Dummy for group
rename grupo group
tab group, miss

**Declaring the panel**
xtset ident year

// Lagging variables

sort ident year

#delimit ;
foreach X of varlist bsupport bfinex binfmer bdomin bddrisk bnodem bgtinn ///
intensidad_id higher_education bip group bextranj tasacifra interaventas_bfinex ///
size20 size50 size100 size400 size700 size1000 ln_gtinnpt ln_gintid bsupport_ue ///
support_tot exporter researchers_pt invest rprod
 { ;
by ident: gen `X't_1 = `X'[_n-1] ;
} ;
 
#delimit cr ;

label var bsupportt_1 "Support (t-1)"
label var bsupport_uet_1 "Support UE t-1"
label var bfinext_1 "O. External finance (t-1)"
label var size20 "Size x<20 emp"
label var size50 "Size 20<x<50 emp"
label var size100 "Size 50<x<100 emp"
label var size400 "Size 200<x<400 emp"
label var size700 "Size 400<x<700 emp"
label var size1000 "Size 700<x<1000 emp"
label var binfmert_1 "Binary obstacle high: lack of information on markets (t-1)"
label var bdomint_1 "Binary obstacle high: Market dominated by established companies (t-1)"
label var bddriskt_1 "Binary obstacle high: uncertain demand for innovative goods and services (t-1)"
label var bnodemt_1 "Dummy:  High lack of demand for innovations (t-1)"
label var bgtinnt_1 "Dummy: Innovation expenditures (t-1)"
label var intensidad_idt_1 "Log innovation intensity t-1"
label var higher_educationt_1 "Higher education (t-1)"
label var researchers_ptt_1 "Researcher over size t-1"
label var groupt_1 "Group (t-1)"
label var bextranjt_1 "Foreign capital (t-1)"
label var bipt_1 "Intellectual property (t-1)"
label var ln_gtinnptt_1 "log innovation expenditure per worker (t-1)"
label var support_tott_1 "Support Total (t-1)"
label var exportert_1 "Exporter (t-1)"
label var ln_gintidt_1 "Ln R&D expenditures (t-1)"
label var investt_1 "Invest in Fixed capital (t-1)"
label var rprodt_1 "Relative productivity (t-1)"
gen bsupportt_2 = `X'[_n-2]
label var bsupportt_2 "Support (t-2)"


gen novelty= newemp + newmer
label var novelty "Turnover from new to market and new to firm innovations"

gen novelty_emp = (novedemp==1)
label var novelty_emp "Novelty only for the firm"
gen novelty_mark = (novedad==1)
label var novelty_mark "Novelty only for the market"

*Innovation related variables
gen btech= (novedad==1 | innproc==1)
gen bnontech = (inorgn1==1 | inorgn2==1 | inorgn3==1 | incomn1==1 | incomn2==1 | incomn3==1 | incomn4==1)

**Technological collaboration
gen cooperation= (coopera==1)
label var cooperation "technological cooperation"

global XTLIST1 ln_age ln_age2 ln_size ln_size2 ln_gintidpt depth breadth ////
		novedad binnorg financial_constraints knowledge_barriers dominated_barrier //// 
		uncertainty_barrier ln_researchers parque researchers_ratio ln_support_tot btech ///
		cooperation innova_tech
#delimit ;
foreach X of varlist $XTLIST1 
 { ;
by ident: gen `X't_1 = `X'[_n-1] ;
} ;
 
#delimit cr ;

label var evolcifra "Sales Growth"
label var bsupportt_1 "Public Support (t-1)"
label var ln_sizet_1 "Size (log) (t-1)"
label var age "Age (log)"
label var ln_gintidptt_1 "R&D intensity (log) (t-1)"
label var financial_constraintst_1 "Financial Constraints (t-1)"
label var knowledge_barrierst_1 "Knowledge Barriers (t-1)"
label var dominated_barriert_1 "Market Barriers: Dominated (t-1)"
label var uncertainty_barriert_1 "Market Barriers: Uncertainty (t-1)"
label var novedad  "Novelty"
label var ln_researcherst_1 "Researchers (log) (t-1)"
label var higher_educationt_1 "Higher education (t-1)"
label var group "Group membership (t-1)"
label var bextranjt_1 "Foreign (t-1)"
label var bipt_1  "Intellectual protection (t-1)"
label var ManufAT  "High-tech manuf"
label var ManufTM  "Medium-tech manuf"
label var ServAT  "High-tech serv"
label var ServRest  "Rest of serv"
label var ln_age2t_1 "Age Square (t-1)"
label var ln_size2t_1 "Size Square (t-1)"
label var researchers_ratiot_1 "Researchers (t-1)"
label var ln_support_tott_1 "Public support (log) (t-1)"
label var btecht_1 "Tech innovation t-1"
label var cooperationt_1 "Cooperation t-1"
label var innova_techt_1 "Technological innovation t_1"


*Controlling employment incidence
gen inciempleo= (inciemp>0)
label var inciempleo "Employment incidence"
inspect inciempleo

*gen bsupport2005= (bsupport==1 & year==2005)

gen innovative= (sumbgtinn>0 & noninnova==0)

*Declaring Data as Panel

xtset ident year

*******************************************************************************
***********                Sample Filtering                       ************* 
*******************************************************************************

//Ruling out companies in branches of activity that will not be used

drop if act==0 | act== 1 | act==2 

//Ruling out Energy, sanitation and construction
drop if tech==6

**Filtering outliers
keep if outcifra==0 & extcifra==0 & outempleo==0


//Labels
label var evolcifra "Sales growth"
label var bfinext_1 "External financial constraints (t-1)"
label var bddriskt_1"Market Barriers: Uncertainty(t-1) (t-1)"
label var bipt_1 "Intellectual protection (t-1)"
label var higher_educationt_1 "Higher education (t-1)"
label var groupt_1 "Group membership (t-1)"
label var bextranjt_1 "Foreign (t-1)"
label var exporter "Exporter"
label var size20 "Size x=20 employees"
label var size50 "Size 20<x=50 employees"
label var size100 "Size 50<x=100 employees"
label var ln_age "Age"
label var ManufAT "High tech. Manufacturing."
label var ManufTM "Medium tech Manufacturing"
label var ServAT "High. tech. Services"
label var ServRest "Rest of services"
label var bsupport_ue "UE funding (t-1)"
label var ln_gtinnptt_1 "Innotation intensity (t-1)"


*****************************Saving the panel***********************************

save   "${Output}\Panel_sample.dta", replace //File Generate: Panel_muestra


//Summarizing the Samples
label define muestra1 1 "Only MEG" 2 "Only MID" 3 "MED & MID" 4 "MIDE" 5 "MEP" 
label values muestra muestra1
xttab muestra

sort year
by year: tab muestra
by year: tab tam200
by year: tab tech

sort ident year
********************************************************************************
********************************************************************************
