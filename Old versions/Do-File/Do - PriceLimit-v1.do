cls
clear


import delimited "C:\Project\PriceLimit\Stock_Price_limit4.csv", encoding(UTF-8)
 
cd"C:\Project\PriceLimit\Final Report"


label variable v1 "[4.5,5)"
label variable v2 "[4,4.5)"
label variable v3 "[2,4)"
label variable vm "(-2,2)"
label variable v4 "(-4,-2]"
label variable v5 "(-4.5,-4]"
label variable v6 "(-5,-4.5]"

label variable tomorrowopenlast "TOpen-Last"
label variable lastopen "Last-Open"
label variable closetoopen "Close-Open"



eststo clear 
foreach v of varlist lastopen closetoopen tomorrowopenlast ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly reg `v' upperhit v1 v2 v3 vm v4  v5 v6    lowerhit  limitchange marketratio , cluster(t) 
}

 esttab lastopen closetoopen tomorrowopenlast ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 , label  drop(marketratio)

eststo clear 
foreach v of varlist lastopen closetoopen tomorrowopenlast eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300 {

eststo `v':quietly reg `v' upperhit v1 v2 v3 vm v4  v5 v6    lowerhit  limitchange marketratio , cluster(t) 
}

 esttab lastopen closetoopen tomorrowopenlast eret_2 eret_2to5 eret_5to50 eret_50to100 eret_100to300 , label  drop(marketratio)

//use "PriceLimit.dta"

// Return 
eststo clear 
foreach v of varlist closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly reg `v' upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , cluster(t) 
}



esttab closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup"),using example1.tex,replace

//eqlabels("YES" "YES" "YES" "YES""YES" "YES" "YES" "YES", lhs("limitgroup"))



eststo clear 
foreach v of varlist closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly reg `v' upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , cluster(id) 
}

esttab closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 ,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup"),using example2.tex,replace



//VolumeI

generate lnvolume = ln(volume)

foreach v of varlist turn relturn lnvolume{

eststo `v' :quietly reg `v' upperhit  upper middle lower lowerhit limitchange marketratio i.limitgroup,cluster(t)


}

esttab lnvolume turn relturn ,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup"),using example3.tex,replace


//Individual Buy
eststo clear
foreach v of varlist inslimbalance indlimbalance findlimbalance finslimbalance {
eststo `v' :quietly reg `v' upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , cluster(t) 
}


esttab inslimbalance finslimbalance indlimbalance findlimbalance  ,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup"),using example6.tex,replace

reg f2indlimbalance upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , cluster(t) 
//Other




//Panel Regression

xtset id t

eststo clear

foreach v of varlist closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300 {

eststo `v':quietly xtreg `v' upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , fe robust
}



esttab closetoopen opentoclose ret_1 ret_2 ret_2to5 ret_5to50 ret_50to100 ret_100to300,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup"),using example4.tex,replace



//VolumeII
eststo clear

foreach v of varlist turn relturn lnvolume{

eststo f`v' :quietly xtreg `v' upperhit  upper middle lower lowerhit limitchange marketratio i.limitgroup, fe robust


}
   

esttab lnvolume turn relturn flnvolume fturn frelturn ,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup") mgroups(Cluster(t) FE, pattern(1 0 0 1 0 0)) ,using example5.tex,replace 


//Individual BuyII

eststo clear
foreach v of varlist inslimbalance indlimbalance findlimbalance finslimbalance {
eststo `v' :quietly xtreg `v' upperhit  upper middle lower  lowerhit limitchange marketratio i.limitgroup , fe robust 
}
esttab inslimbalance finslimbalance indlimbalance findlimbalance  ,keep(upper middle lower  lowerhit limitchange) addnotes("We controll for marketratio and limitgroup") ,using example7.tex,replace



cls
clear
 import excel "C:\Project\PriceLimit\Vdata.xlsx", sheet("Sheet1") firstrow clear
 
 
  line VUEReturn VLEReturn index ,xline(0) yline(1)  ytitle("Value (By Excess Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)30)
 
   line VUReturn VLReturn index ,xline(0) yline(1)  ytitle("Value (By Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)30)
  
  line UInslImbalance UIndlImbalance index , ytitle("Imbalance") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Limit") xlab(-15(5)30)
  
    line LInslImbalance LIndlImbalance index , ytitle("Imbalance") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Limit") xlab(-15(5)30)

 line UTurn LTurn index , ytitle("Turn") legend(pos(7) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)30)	
 
line URelReturn LRelReturn index ,  ytitle("RelTurn") legend(pos(7) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)30)	

	
	
 
 // twoway connected  VUEReturn VLEReturn index ,xline(0) yline(1)  ytitle("Value (By Excess Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid")
 
