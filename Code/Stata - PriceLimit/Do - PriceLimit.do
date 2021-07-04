cls
clear


import delimited "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit\Stock_Price_limit7.csv", encoding(UTF-8)
 
 cd"G:\Dropbox\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\PriceLimit\Final Report"


label variable v1 "[4.5,5)"
label variable v2 "[4,4.5)"
label variable v3 "[2,4)"
label variable vm "(-2,2)"
label variable v4 "(-4,-2]"
label variable v5 "(-4.5,-4]"
label variable v6 "(-5,-4.5]"

label variable tomorrowopenlast "TOpen-Last"
label variable tomorrowlasttomorrowopen "TLast-TOpen"
label variable lastopen "Last-Open"
label variable closetoopen "TOpen-Close"
label variable opentoclose "TClose-TOpen"
label variable closeopen "Close-Open"

label variable ret_2to5 "[2,5]"
label variable ret_5to50 "[5,50]"
label variable ret_50to100 "[50,100]"
label variable ret_100to300 "[100,300]"

label variable eret_2to5 "E[2,5]"
label variable eret_5to50 "E[5,50]"
label variable eret_50to100 "E[50,100]"
label variable eret_100to300 "E[100,300]"

label variable abret_2to5 "Ab[2,5]"
label variable abret_5to50 "Ab[5,50]"
label variable abret_50to100 "Ab[50,100]"
label variable abret_100to300 "Ab[100,300]"

label variable positive "Up Market"


eststo clear 
foreach v of varlist closeopen lastopen tomorrowopenlast closetoopen opentoclose tomorrowlasttomorrowopen ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly reg `v' upperhit v1 v2 v3 vm v4  v5 v6    lowerhit positive   limitchange marketratio , cluster(t) 
}

 esttab closeopen lastopen tomorrowopenlast closetoopen opentoclose tomorrowlasttomorrowopen , label  drop(marketratio limitchange) r2 addnotes("This table reports OLS estimates of Open, Last and Close returns." "The independent variables are dummies that control for events . We calculate standard errors by clustering on each stocks" ) , using Return1.tex, replace

 
 
esttab ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 , label  drop(marketratio limitchange) r2 addnotes("This table reports OLS estimates of normal returns." "The independent variables are dummies that control for events . We calculate standard errors by clustering on each stocks" ) , using Return2.tex, replace



foreach v of varlist eret_1 eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300 {

eststo `v':quietly reg `v' upperhit v1 v2 v3 vm v4  v5 v6    lowerhit  positive limitchange marketratio , cluster(t) 
}

 esttab eret_1 eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300 , label  drop(marketratio limitchange) r2 addnotes("This table reports OLS estimates of extra return from market." "The independent variables are dummies that control for events . We calculate standard errors by clustering on each stocks" ) , using EReturn.tex , replace
 
 
 foreach v of varlist abret_1 abret_2 abret_2to5 abret_5to50 abret_50to100 abret_100to300 {

eststo `v':quietly reg `v' upperhit v1 v2 v3 vm v4  v5 v6    lowerhit positive limitchange marketratio , cluster(t) 
}

 esttab abret_1 abret_1 abret_2to5 abret_5to50 abret_50to100 abret_100to300 , label  drop(marketratio limitchange) r2 addnotes("This table reports OLS estimates of Abnormal returns." "The independent variables are dummies that control for events . We calculate standard errors by clustering on each stocks" )  , using AbReturn.tex , replace
 
 

//use "PriceLimit.dta"


//VolumeI

generate lnvolume = ln(volume)

foreach v of varlist turn relturn lnvolume{

eststo `v' :quietly reg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive limitchange marketratio ,cluster(t)


}

esttab lnvolume turn relturn ,drop(marketratio  limitchange) label r2 addnotes("This table reports OLS estimates of volume, turnover and relative turnover." "The independent variables are dummies that control for events . We calculate standard errors by clustering on each stocks" ) , using Volume.tex , replace

//addnotes("We controll for marketratio")

//Individual Buy
eststo clear
foreach v of varlist inslimbalance indlimbalance findlimbalance finslimbalance {
eststo `v' :quietly reg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive limitchange marketratio ,cluster(t)
}


esttab inslimbalance finslimbalance indlimbalance findlimbalance ,drop(marketratio limitchange) label r2 addnotes("This table reports OLS estimates of net-buy imbalances. The independent variables are dummies that " " control for events . We calculate standard errors by clustering on each stocks" )  ,using Imbalance.tex , replace




//Other

 


//Panel Regression

xtset id t

eststo clear


foreach v of varlist closeopen lastopen tomorrowopenlast closetoopen opentoclose tomorrowlasttomorrowopen ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly xtreg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive limitchange marketratio  , fe robust
}



 esttab closeopen lastopen tomorrowopenlast closetoopen opentoclose tomorrowlasttomorrowopen , label  drop(marketratio limitchange) r2 addnotes("This table reports fixed effect estimates of Open, Last and Close returns." "The independent variables are dummies that control for events . We calculate standard errors by using fixed effect on stock level" )  ,using PReturn1.tex,replace
 
esttab ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 , label  drop(marketratio limitchange) r2 addnotes("This table reports fixed effect estimates of normal returns. The independent variables are dummies " " that control for events . We calculate standard errors by using fixed effect on stock level" ),using PReturn2.tex,replace

foreach v of varlist eret_1 eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300{

eststo `v':quietly xtreg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit  positive limitchange marketratio  , fe robust
}

 esttab eret_1 eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300 , label  drop(marketratio limitchange) r2 addnotes("This table reports fixed effect estimates of extra return from market.The independent variables are dummies " " that control for events . We calculate standard errors by using fixed effect on stock level" ), using PEReturn.tex , replace


 
  foreach v of varlist abret_1 abret_2 abret_2to5 abret_5to50 abret_50to100 abret_100to300 {
  
eststo `v':quietly xtreg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive  limitchange marketratio  , fe robust
}

 esttab abret_1 abret_2 abret_2to5 abret_5to50 abret_50to100 abret_100to300  , label  drop(marketratio limitchange) r2 addnotes("This table reports fixed effect estimates of abnormal returns. The independent variables are dummies " " that control for events . We calculate standard errors by using fixed effect on stock level" ) , using PAbReturn.tex , replace

//VolumeII
eststo clear

foreach v of varlist turn relturn lnvolume{

eststo `v' :quietly xtreg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive limitchange marketratio ,fe robust


}

esttab lnvolume turn relturn ,drop(marketratio limitchange)  r2 label addnotes("This table reports fixed effect estimates of volume, turnover and relative turnover. The independent variables are dummies " " that control for events . We calculate standard errors by using fixed effect on stock level" )   , using PVolume.tex , replace


//Individual BuyII

eststo clear
foreach v of varlist inslimbalance indlimbalance findlimbalance finslimbalance {
eststo `v' :quietly xtreg `v' upperhit  v1 v2 v3 vm v4  v5 v6 lowerhit positive limitchange marketratio ,fe robust
}


esttab inslimbalance finslimbalance indlimbalance findlimbalance ,drop(marketratio limitchange) r2 label addnotes("This table reports fixed effect estimates of net-buy imbalances. The independent variables are dummies " " that control for events . We calculate standard errors by using fixed effect on stock level" ) ,using PImbalance.tex , replace




 /* */

cls
clear
 import excel "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit\VdataI.xlsx", sheet("Sheet1") firstrow clear
 
 cd"G:\Dropbox\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\PriceLimit\Final Report"


twoway connected Close Open Last period if flag == "U"  || rspike Open Last period if flag == "U" , xlab(-1(1)1) 

twoway connected Close Open Last period if flag == "U" ,msymbol(O T S)   xlab(-1(1)1) title("Upper Hit") legend(pos(5) ring(0) col(1) ) xline(0,lpattern(shortdash_dot))  note("This figure graphs the value of an asset according to Open, Last, and Close price." "We normalized the day before event's close price (period = 0) to one, then calculate the value of the asset "" according to prices.")

graph export DUT.eps,replace
graph export DUT.png,replace

twoway connected Close Open Last period if flag == "L" ,msymbol(O T S) xlab(-1(1)1) title("Lower Hit") legend(pos(1) ring(0) col(1) ) xline(0,lpattern(shortdash_dot))note("This figure graphs the value of an asset according to Open, Last, and Close price." "We normalized the day before event's close price (period = 0) to one, then calculate the value of the asset "" according to prices.")

graph export DLT.eps,replace
graph export DLT.png,replace

twoway connected Close Open Last period if flag == "CU" ,msymbol(O T S) xlab(-1(1)1) title("Near to Upper Hit") legend(pos(3) ring(0) col(1) ) xline(0,lpattern(shortdash_dot))note("This figure graphs the value of an asset according to Open, Last, and Close price." "We normalized the day before event's close price (period = 0) to one, then calculate the value of the asset "" according to prices.")

graph export DCUT.eps,replace
graph export DCUT.png,replace

twoway connected Close Open Last period if flag == "CL" ,msymbol(O T S) xlab(-1(1)1) title("Near to Lower Hit") legend(pos(4) ring(0) col(1) ) xline(0,lpattern(shortdash_dot))note("This figure graphs the value of an asset according to Open, Last, and Close price." "We normalized the day before event's close price (period = 0) to one, then calculate the value of the asset "" according to prices.")

graph export DCLT.eps,replace
graph export DCLT.png,replace


/**/
cls
clear
 import excel "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit\VdataP.xlsx", sheet("Sheet1") firstrow clear
  cd"G:\Dropbox\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\PriceLimit\Final Report"

 sum  upperHit lowerHit
 
 scatter upperHit lowerHit ,msize(vmall) msymbol(+)  mlabel(name)|| function y = x, ra(upperHit) clpat(longdash_dot)  , xtitle("Probabilty of Lower Hit" ) ytitle("Probabilty of Upper Hit" ) legend( col(2) label(2 "P(Upper Hit) = P(Lower Hit)") label(1 "Firm") order(2 1)) note("This figure graphs the probability of limit hits for each stock.")

graph export PUL.eps,replace
graph export PUL.png,replace



  scatter upperHit lowerHit ,msize(vmall) msymbol(+) || function y = x, ra(upperHit) clpat(longdash_dot)  , xtitle("Probabilty of Lower Hit" ) ytitle("Probabilty of Upper Hit" ) legend( col(2) label(2 "P(Upper Hit) = P(Lower Hit)") label(1 "Firm") order(2 1)) note("This figure graphs the probability of limit hits for each stock.")

graph export PUL2.eps,replace
graph export PUL2.png,replace

 
 
 
 
twoway histogram upperHit ,color(navy*.5)  || kdensity upperHit  ,title("Density of probability of upper hit" ) ytitle("Density" ) legend(pos(1) ring(0)col(2) label(2 "Kernel") order(2 )) note("This figure graphs the histogram of the probability of upper hit for each firm.") 

graph export DPU.eps,replace
graph export DPU.png,replace
 
twoway histogram lowerHit ,color(navy*.5)  || kdensity lowerHit  ,title("Density of probability of lower hit" ) ytitle("Density" ) legend(pos(1) ring(0)col(2) label(2 "Kernel") order(2 )) note("This figure graphs the histogram of the probability of lower hit for each firm.") 

graph export DPL.eps,replace
graph export DPL.png,replace

 
 
twoway histogram uu ,color(navy*.5)  || kdensity uu  ,title("Density of probability of upper hit" ) ytitle("Density" ) legend(pos(1) ring(0)col(2) label(2 "Kernel") order(2 )) note("This figure graphs the histogram of the probability of upper hit for each firm.") 

graph export DPUU.eps,replace
graph export DPUU.png,replace

