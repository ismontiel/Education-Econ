cd "L:\Coursework\lmao"
bcuse card, clear

* Since this is 10yr panel data, add variable for beginning of panel
gen age66 = age-10

* Construction of variable indicating proximity to ANY college
gen nearColl = 0
replace nearColl =1 if (nearc2==1)
replace nearColl =1 if (nearc4==1)

*Summary statistics
sum lwage educ motheduc fatheduc black smsa66 libcrd14 age
tab motheduc
tab fatheduc
tab educ
tab libcrd
tab libcrd if smsa66==1
tab libcrd if smsa66==0

* Testing in IV approach to libcard effects through education
reg educ libcrd14
predict educHat

*Comparison of models to normal education effects
reg lwage educHat
reg lwage educ

*Direct IV regression with more possible endo vars
ivreg lwage (educ=libcrd14 IQ)
estimates store Model_1
overid
	* Fail to reject both tests

ivreg lwage (educ=libcrd14 IQ) fatheduc
estimates store Model_2
overid
	* Fail
	
ivreg lwage (educ=libcrd14 IQ) black
estimates store Model_3
overid
	* Fail 
ivreg lwage (educ=libcrd14 IQ) black KWW
estimates store Model_4
overid
	* Fail

ivreg lwage (educ=libcrd14 IQ) fatheduc black KWW
estimates store Model_5
overid
	* Fail
	
estimates table Model_1 Model_2 Model_3 Model_4 Model_5, star stats (N r2 r2_a)

/*
* More linear models that didn't seem to do the trick as IV did
reg educ libcrd14 fatheduc IQ
predict educBaseHat
estimates store olsBase
reg educ libcrd14 fatheduc IQ smsa
predict educSMSAHat
estimates store olsSMSA
reg educ libcrd14 fatheduc IQ smsa nearColl
predict educAllCollHat
estimates store olsAllColl
reg educ libcrd14 fatheduc IQ smsa nearc2 nearc4
predict educSepCollHat
estimates store olsSepColl

reg lwage educBaseHat black smsa enroll
estimates store ivBase
reg lwage educSMSAHat black smsa enroll
estimates store ivSMSA
reg lwage educAllCollHat black smsa enroll
estimates store ivAllColl
reg lwage educSepCollHat black smsa enroll
estimates store ivSepColl

estimates table olsBase olsSMSA olsAllColl olsSepColl, star stats (N r2 r2_a)
estimates table ivBase ivSMSA ivAllColl ivSepColl, star stats (N r2 r2_a)
*/
