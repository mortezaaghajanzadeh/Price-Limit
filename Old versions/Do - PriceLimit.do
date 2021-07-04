clear


import delimited "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\RA\PriceLimit\Stock_Price_limit2.csv", encoding(UTF-8)
 
cd"H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\RA\PriceLimit\Report"



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

