//1. Getting V-Dem Regimes of the World
use "V-Dem-CY-Core-v15.dta", clear

keep country_name COWcode year v2x_regime
keep if year >= 2017
duplicates report COWcode year

	**HK is not coded by CoW in V-Dem, but is part of the WVS. Serbia, for some reason, has different COWcodes in both datasets. The rest of the dups are not, so we can drop them**
replace COWcode = 714 if country_name == "Hong Kong"
replace COWcode =  993 if country_name == "Serbia"
drop if missing(COWcode)
sort COWcode year
save "vdem_trimmed.dta", replace

//2. Merging with WVS
use "WVS_Cross-National_Wave_7_stata_v6_0.dta", clear

	**Alignment of var names**
rename C_COW_NUM COWcode
rename A_YEAR year
replace COWcode = 200 if inlist(C_COW_ALPHA, "UKG", "NIRL")

	**Merge**
sort COWcode year
merge m:1 COWcode year using "vdem_trimmed.dta", keepusing(v2x_regime)
drop if _merge == 2
drop _merge


//3. Cleaning the dataset
keep year COWcode N_REGION_WVS S025 v2x_regime regtype regionWB giniWB incomeWB GDPpercap2 ///
     gii dgi womenparl fhregion ///
     Q211 Q209 Q218 Q210 Q98 Q98R Q214 Q213 Q215 Q212 ///
     Q101R Q99R Q219 Q217 Q220 Q201 Q202 Q203 Q206 Q207 Q199 Q4 ///
     Q234A Q252 Q238 Q250 ///
     Q71 Q72 Q73 ///
     Q275 Q275R Q274 Q32 Q240 Q262 Q260 Q263 Q264 Q265 Q288R W_WEIGHT

	 
	**Keeping only young people in**
keep if Q262 <= 34

//4. Recoding variables to binarize
	
	*Political participation*
gen Q211B = .
replace Q211B = 0 if Q211 == 1
replace Q211B = 1 if inrange(Q211, 2, 3)
label variable Q211B

gen Q209B = .
replace Q209B = 0 if Q209 == 1
replace Q209B = 1 if inrange(Q209, 2, 3)

gen Q210B = .
replace Q210B = 0 if Q210 == 1
replace Q210B = 1 if inrange(Q210, 2, 3)

gen Q98B = .
replace Q98B = 0 if Q98R == 0 
replace Q98B = 1 if Q98R == 1

gen Q214B = .
replace Q214B = 0 if Q214 == 1
replace Q214B = 1 if inrange(Q214, 2, 3)

gen Q213B = .
replace Q213B = 0 if Q213 == 1
replace Q213B = 1 if inrange(Q213, 2, 3)

gen Q215B = .
replace Q215B = 0 if Q215 == 1
replace Q215B = 1 if inrange(Q215, 2, 3)

gen Q212B = .
replace Q212B = 0 if Q212 == 1
replace Q212B = 1 if inrange(Q212, 2,3)

	*Community participation*
gen Q101B = .
replace Q101B = 0 if Q101R == 0 
replace Q101B = 1 if Q101R == 1

	
	*Online political participation*
	
gen Q217B = .                             
replace Q217B = 0 if Q217 == 1
replace Q217B = 1 if inrange(Q217, 2, 3)

gen Q218B = .                             
replace Q218B = 0 if Q218 == 1
replace Q218B = 1 if inrange(Q218, 2, 3)

gen Q219B = .
replace Q219B = 0 if Q219 == 1
replace Q219B = 1 if inrange(Q219, 2, 3)

gen Q220B = .
replace Q220B = 0 if Q220 == 1
replace Q220B = 1 if inrange(Q220, 2, 3)

	*Engagement* //Media use for information (daily basis)
gen Q201B = .                             
replace Q201B = 0 if Q201 == 1
replace Q201B = 1 if inrange(Q201, 2, 5)

gen Q202B = .                             
replace Q202B = 0 if Q202 == 1
replace Q202B = 1 if inrange(Q202, 2, 5)	

gen Q203B = .
replace Q203B = 0 if Q203 == 1
replace Q203B = 1 if inrange(Q203, 2, 5)

gen Q206B = .
replace Q206B = 0 if Q206 == 1
replace Q206B = 1 if inrange(Q206, 2, 5)

gen Q207B = .
replace Q207B = 0 if Q207 == 1
replace Q207B = 1 if inrange(Q207, 2, 5)
	
	//Not included in Grasso & Smith, but interest in politics seem to be relevant to engagement.
gen Q199B = .
replace Q199B = 1 if inlist(Q199, 1, 2)
replace Q199B = 0 if inlist(Q199, 3, 4)
	
	*Efficacy* /only external available
gen Q234B = .
replace Q234B = 1 if inlist(Q234A, 1, 2)
replace Q234B = 0 if inlist(Q234A, 3, 4)
	
	*Attitudes to democracy*
gen Q238B = .
replace Q238B = 1 if inlist(Q238, 1, 2)
replace Q238B = 0 if inlist(Q238, 3, 4)

gen Q250B = .                             
replace Q250B = 0 if inrange(Q250, 1, 5)
replace Q250B = 1 if inrange(Q250, 6, 10)

gen Q252B = .                             
replace Q252B = 0 if inrange(Q252, 1, 5)
replace Q252B = 1 if inrange(Q252, 6, 10)

	*Attitudes to representation*
gen Q71B = .
replace Q71B = 1 if inlist(Q71, 1, 2)
replace Q71B = 0 if inlist(Q71, 3, 4)

gen Q72B = .
replace Q72B = 1 if inlist(Q72, 1, 2)
replace Q72B = 0 if inlist(Q72, 3, 4)

gen Q73B = .
replace Q73B = 1 if inlist(Q73, 1, 2)
replace Q73B = 0 if inlist(Q73, 3, 4)

	*Controls*
gen Q262B = .
replace Q262B = 1 if inrange(Q262, 18, 24)
replace Q262B = 2 if inrange(Q262, 25, 34)
label define agegrp 1 "18-24" 2 "25-34"
label values Q262B agegrp

gen Q263B = .
replace Q263B = 0 if Q263 == 1
replace Q263B = 1 if Q263 == 2

gen Q240B = .                             
replace Q240B = 1 if inrange(Q240, 1, 5)
replace Q240B = 0 if inrange(Q240, 6, 10)

gen Q32B = .
replace Q32B = 1 if inlist(Q32, 1, 2)
replace Q32B = 0 if inlist(Q32, 3, 4)

gen Q274C = . 
replace Q274C = 0 if Q274 == 0
replace Q274C = 1 if Q274 >= 1

// Labelling all the newly created variables
label variable Q211B "(B) Political action: attending lawful/peaceful demonstrations"
label variable Q209B "(B) Political action: Signing a petition"
label variable Q210B "(B) Political action: joining in boycotts"
label variable Q98B  "(B) Active/Inactive membership: Political party"
label variable Q214B "(B) Social activism: Contacting a government official"
label variable Q213B "(B) Social activism: Donating to a group or campaign"
label variable Q215B "(B) Social activism: Encouraging others to take action"
label variable Q212B "(B) Political action: joining unofficial strikes"
label variable Q101B "(B) Membership: charitable/humanitarian organization"
label variable Q219B "(B) Political actions online: Encouraging others to act"
label variable Q217B "(B) Political actions online: Searching information" 
label variable Q218B "(B) Political actions online: Signing a petition" 
label variable Q220B "(B) Political actions online: Organizing activities/protests" 
label variable Q201B "(B) Information source: Daily newspaper"
label variable Q202B "(B) Information source: TV news"
label variable Q203B "(B) Information source: Radio news"
label variable Q206B "(B) Information source: Internet"
label variable Q207B "(B) Information source: Social media"
label variable Q199B "(B) Interest in politics (high vs low)"
label variable Q234B "(B) How much system allows people to have a say"
label variable Q252B "(B) Satisfaction with political system performance"
label variable Q238B "(B) Having a democratic political system"
label variable Q250B "(B) Importance of democracy"
label variable Q71B  "(B) Confidence: The Government"
label variable Q72B "(B) Confidence: The Political Parties"
label variable Q73B  "(B) Confidence: Parliament"
label variable Q274C "(B) How many children do you have"
label variable Q32B  "(B) Being a housewife just as fulfilling"
label variable Q240B "(B) Left-right political scale"
label variable Q262B "(B) Age"
label variable Q263B "(B) Respondent immigrant"

save "WVS_recoded.dta", replace

// 5. Printing tables
	
	* General table per sex, LATAM as a whole*
use "WVS_recoded.dta", clear
keep if regionWB == 5
drop if inlist(Q260, -2, -4, -5)

dtable Q211B Q209B Q210B Q98B Q214B Q213B Q215B Q212B ///
       Q101B Q219B Q217B Q218B Q220B ///
       Q201B Q202B Q203B Q206B Q207B Q199B ///
       Q234B Q252B Q238B Q240B Q250B Q71B Q72B Q73B ///
	   [pw = W_WEIGHT] ////
       , by(Q260, tests) ///
		varlabel ///
         nformat(%9.3f) ///
         export("table_LATAM_youthv4", as(xlsx) replace)

	* Tables per country and sex, LATAM*
use "WVS_recoded.dta", clear
keep if regionWB == 5
drop if inlist(Q260, -2, -4, -5)

//Defining DVs
local acts Q211B Q209B Q210B Q98B Q214B Q213B Q215B Q212B Q101B Q219B Q217B Q218B Q220B Q201B Q202B Q203B Q206B Q207B Q199B Q234B Q252B Q238B Q250B Q71B Q72B Q73B

levelsof COWcode, local(country)

//Loop over countries = a dtable per country
foreach c of local country {

    preserve
        keep if COWcode == `c'

        local cname : label (COWcode) `c'
        local cname = subinstr("`cname'"," ","_",.)

        dtable `acts' [pw = W_WEIGHT], ///
            by(Q260, tests) ///
            varlabel ///
            nformat(%9.3f) ///
            title("Country: `cname'") ///
            export("table_`cname'_gender.xlsx", replace)

    restore
}

// 6. Running the multilevel logit model / LATAM

use "WVS_recoded.dta", clear
keep if regionWB == 5
drop if inlist(Q260, -2, -4, -5)
gen female = (Q260==2)
replace Q275R = . if inlist(Q275R, -1, -2, -4, -5)
replace Q288R = . if inlist(Q288R, -1, -2, -4, -5)

//Generating our final DVs	
	**1) Political activism offline**
	gen act_offline = (Q211B==1 | Q210B==1 | Q214B==1 | Q213B==1 | Q215B==1 | Q212B==1)
	
	**2) Online political participation**
	gen act_online = (Q220B == 1 | Q219B==1)

	
// Running a simple logit model
logit act_offline female
logit act_online female

	* Multilevel for political activity offline*
		
		//Pooled age groups
		*Model only with gender (M1)
melogit act_offline i.female || COWcode: 
estat icc
estimates store m1
margins, dydx(female)
	
		*Model with controls (M2)
melogit act_offline i.female i.Q274C i.Q275R i.Q240B i.Q98B i.Q199B i.Q217B i.female#i.Q199B i.Q238B || COWcode:
estat icc
estimates store m2
margins, dydx(female)	

	* Multilevel for political activity online*
		*Model only with gender (M1)
melogit act_online i.female || COWcode: 
estat icc
estimates store m3
margins, dydx(female)
	
		*Model with countrols (M2)
melogit act_online i.female i.Q274C i.Q275R i.Q240B i.Q98B i.Q199B i.Q217B i.female#i.Q199B i.Q238B || COWcode: 
estat icc
estimates store m4
margins, dydx(female)
	
* Printing models
esttab m1 m2 m3 m4 using "melogit_youth_LATAMV6.rtf", ///
    eform se ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N ll, fmt(%9.0g %9.3f) labels("N" "LogLik")) ///
	label ///
    replace

// 7. Running the multilevel logit model /EUROPE

use "WVS_recoded.dta", clear
keep if fhregion == 4
drop if inlist(Q260, -2, -4, -5)
gen female = (Q260==2)

//Generating our final DVs	
	**1) Political activism offline**
	gen act_offline = (Q211B==1 | Q209B==1 | Q210B==1 | Q214B==1 | Q213B==1 | Q215B==1 | Q212B==1)
	
	**2) Online political participation**
	gen act_online = (Q220B==1 | Q218B==1 | Q219B==1 | Q217B==1)

//Generating control for political information

gen polinfo = (Q201B==1 | Q202B==1 | Q203B==1 | Q206B==1 | Q207B==1) if Q201B<. | Q202B<. | Q203B<. | Q206B<. | Q207B<.
	
// Running the logit model
gen female = (Q260==2)
replace Q275R = . if inlist(Q275R, -1, -2, -4, -5)


	* Multilevel for political activity offline*
		
		//Pooled age groups
		*Model only with gender (M1)
melogit act_offline female || COWcode: 
estat icc
estimates store m5
margins, dydx(female)
	
		*Model with controls (M2)
melogit act_offline female i.Q274C i.Q275R Q32B Q240B Q98B Q199B polinfo || COWcode:
estat icc
estimates store m6
margins, dydx(female)	

	* Multilevel for political activity online*
		*Model only with gender (M1)
melogit act_online female || COWcode: 
estat icc
estimates store m7
margins, dydx(female)
	
		*Model with countrols (M2)
melogit act_online female female i.Q274C i.Q275R Q32B Q240B Q98B Q199B polinfo|| COWcode: 
estat icc
estimates store m8
margins, dydx(female)
	
* Printing models
esttab m5 m6 m7 m8 using "melogit_youth_Europe.rtf", ///
    eform se ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N ll, fmt(%9.0g %9.3f) labels("N" "LogLik")) ///
	label ///
    replace

// 8. Analyzing political information against gender

gen polinfo = Q217B ==1 if Q217B<.

logit polinfo female
melogit polinfo female Q234B

replace Q275R = . if inlist(Q275R, -1, -2, -4, -5) 
melogit polinfo female Q234B Q275R Q274C

gen act_online = (Q220B==1 | Q218B==1 | Q219B==1)
melogit act_online female


/// 9. Plotting gender gaps Latam / Europe

//Ideology
drop if Q240 < 0

gen Q240_centered = Q240 - 5.5

label define sex_lbl 0 "Male" 1 "Female", replace
label values female sex_lbl

graph hbar (mean) Q240_centered [pw=W_WEIGHT], ///
    over(female) ///
    over(COWcode, label(labsize(small))) ///
    asyvars ///
    bar(1, color(green)) /// 
    bar(2, color(purple*0.6)) /// 
    ytitle("Youth People Ideological Self-Placement by Gender" "<- Left | Right ->") ///
    legend(title("Gender") pos(6) rows(1)) ///
    blabel(bar, format(%8.2f) size(vsmall)) ///
    yline(0, lcolor(black) lpattern(dash)) //

	
//Interest in politics
drop if Q199 < 0

gen Q199_inv = 5 - Q199

gen Q199_c2 = Q199_inv - 2

graph hbar (mean) Q199_c2 [pw=W_WEIGHT], ///
    over(female) ///
    over(COWcode, label(labsize(vsmall))) /// 
    asyvars ///
    bar(1, color(green)) /// Hombres
    bar(2, color(purple*0.6)) /// Mujeres
    ytitle("Political Interest Gap (Youth 18-34)" "<- Less Interest | More Interest ->") ///
    legend(title("Gender") pos(6) rows(1)) ///
    blabel(bar, format(%8.2f) size(vsmall)) ///
    yline(0, lcolor(black) lpattern(dash)) /// El cero ahora representa el valor original '2'
    note("Scale inverted (4=Very, 1=None) and centered at 2 (Little interest)")

****************************ROBUSTNESS CHECKS/ALTERNATIVE ESPECIFICATIONS****************************
	//A. Dividing per age groups
		*Model only with gender (M1)
melogit act_offline female if Q262B == 1|| COWcode: 
estat icc
estimates store m5
margins, dydx(female)

melogit act_offline female if Q262B == 2|| COWcode: 
estat icc
estimates store m6
margins, dydx(female)
	
		*Model with controls (M2)
melogit act_offline female i.Q274C Q32B Q240B i.Q262B Q263B Q98B Q201B Q101B Q234B Q199B Q238B Q250B polinfo if Q262B == 1|| COWcode:
estat icc
estimates store m7
margins, dydx(female)	

melogit act_offline female i.Q274C Q32B Q240B i.Q262B Q263B Q98B Q201B Q101B Q234B Q199B Q238B Q250B polinfo if Q262B == 2|| COWcode:
estat icc
estimates store m8
margins, dydx(female)	

	* Multilevel for political activity online*
		*Model only with gender (M1)
melogit act_online female if Q262B == 1 || COWcode: 
estat icc
estimates store m9
margins, dydx(female)

melogit act_online female if Q262B == 2 || COWcode: 
estat icc
estimates store m10
margins, dydx(female)
	
		*Model with countrols (M2)
melogit act_online female i.Q274C Q32B Q240B i.Q262B Q263B Q98B Q201B Q101B Q234B Q199B Q238B Q250B polinfo if Q262B == 1 || COWcode: 
estat icc
estimates store m11
margins, dydx(female)

melogit act_online female i.Q274C Q32B Q240B i.Q262B Q263B Q98B Q201B Q101B Q234B Q199B Q238B Q250B polinfo if Q262B == 2 || COWcode: 
estat icc
estimates store m12
margins, dydx(female)
	
* Printing models
esttab m5 m6 m7 m8 m9 m10 m11 m12 using "melogit_youth_LATAM_peragegroup.rtf", ///
    eform se ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N ll, fmt(%9.0g %9.3f) labels("N" "LogLik")) ///
	label ///
    replace
	
	
//B. Alternative definitions of the DVs 

use "WVS_recoded.dta", clear
keep if regionWB == 5
drop if inlist(Q260, -2, -4, -5)
drop if inlist(COWcode, 165, 6) // if we want to exclude PR, as non-autonomous + Uruguay (very little observations)
gen female = (Q260==2)
replace Q275R = . if inlist(Q275R, -1, -2, -4, -5)

//Generating our final DVs	
	**1) Political activism offline**
	gen act_offline = (Q211B==1 | Q209B==1 | Q210B==1 | Q214B==1 | Q213B==1 | Q215B==1 | Q212B==1)
	
	**2) Online political participation**
	gen act_online = (Q220B==1 | Q218B==1 | Q219B==1 | Q217B==1)

//Generating our control por political information
//Initial especification of polinfo (then replaced by Q217B)
gen polinfo = ( Q201B==1 | Q202B==1 | Q203B==1 | Q206B==1 | Q207B==1) if Q201B<. | Q202B<. | Q203B<. | Q206B<. | Q207B<. 

