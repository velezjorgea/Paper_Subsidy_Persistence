********************************************************************************
*******************      Master DO-File: Chapter 4           *******************
*********************            Thesis UAB               **********************
*********************       Date: 13-Jan-2019             **********************
*****************         Supervisor: Isabel Busom        **********************
********************************************************************************

set more off
clear all
macro drop _all

//Contents
*			1. Importing
*			2. Cleaning data set, labeling and inspection
*           3. Sample Filters
*           4.1 Estimations: SMEs 
*			4.2 Estimations: large firms 

**********************************************************************

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

capture log close

log using "${document}\mylog.log", text replace


//Running .do files

//1: importing raw data
	 

do "${dofiles}\1. Import.do"

//2: data cleaning

do "${dofiles}\2. Cleaning.do"

// 3: Sample Filters

do "${dofiles}\3. Sample Filters.do"

// 4: Estimations


// 4.1: Estimations: SMEs
do "${dofiles}\4.1 Estimations SMEs.do"

// 4.2: Estimations: Large firms
do "${dofiles}\4.2 Estimations large.do"

********************************************************************************
********************************************************************************
