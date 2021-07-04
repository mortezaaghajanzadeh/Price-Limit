
cls
clear
 import excel "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit\Vdata.xlsx", sheet("Sheet1") firstrow clear
 
 drop if index >15
 cd"G:\Dropbox\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\PriceLimit\Final Report"
 // 
 
 
 foreach v of varlist  VUEReturn VLEReturn VUReturn VLReturn VUAReturn VLAReturn VCUEReturn VCLEReturn VCUReturn VCLReturn VCUAReturn VCLAReturn {
replace `v' = (`v' - 1) * 100
}


 foreach v of varlist  UNEReturn LNEReturn UNReturn LNReturn UNAbReturn LNAbReturn CUNEReturn CLNEReturn CUNReturn CLNReturn CUNAbReturn CLNAbReturn UPEReturn LPEReturn UPReturn LPReturn UPAbReturn LPAbReturn CUPEReturn CLPEReturn CUPReturn CLPReturn CUPAbReturn CLPAbReturn{
replace `v' = (`v' - 1) * 100
}

 
 foreach v of varlist  CLIndValue CLInsValue LIndValue LInsValue UIndValue UInsValue  CUIndValue CUInsValue{
replace `v' = `v'  / 10^13
gen cum_`v' = sum(`v')
}
 
 twoway connected cum_CLIndValue cum_CLInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Lower Hit (Cumulative)") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export CLVCUM.eps,replace
graph export CLVCUM.png,replace


 twoway connected cum_LIndValue cum_LInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Lower Hit (Cumulative)") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export LVCUM.eps,replace
graph export LVCUM.png,replace


 twoway connected cum_UIndValue cum_UInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Upper Hit (Cumulative)") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export UVCUM.eps,replace
graph export UVCUM.png,replace

 twoway connected cum_CUIndValue cum_CUInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Upper Hit (Cumulative)") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export CUVCUM.eps,replace
graph export CUVCUM.png,replace
 
twoway connected CLIndValue CLInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Lower Hit") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export CLV.eps,replace
graph export CLV.png,replace

twoway connected LIndValue LInsValue  index , xline(0) xlab(-15(5)15)legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Lower Hit") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy)
graph export LV.eps,replace
graph export LV.png,replace

twoway connected  UIndValue UInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Upper Hit") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy)
graph export UV.eps,replace
graph export UV.png,replace




twoway connected CUIndValue CUInsValue  index , xline(0) xlab(-15(5)15) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Upper Hit")msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy) 
graph export CUV.eps,replace
graph export CUV.png,replace

 

 twoway connected VUEReturn VCUEReturn  VCLEReturn VLEReturn index , msymbol(Th  i i Sh) xline(0,lpattern(shortdash_dot)) yline(0)    ytitle("") legend(pos(5) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid solid dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,""then calculate the cumulativereturn for  asset.") title("Cumulative excess return from the market") ytitle("Percent")
graph export TER.eps,replace
graph export TER.png,replace








twoway connected VUReturn VCUReturn  VCLReturn VLReturn index , xline(0,lpattern(shortdash_dot)) yline(0) ytitle("Percent")    title("Cumulative Return") legend(pos(5) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) msymbol(Th  i i Sh)  xtitle("Peroid") xlab(-15(5)15)  lpattern(solid solid dash_dot solid) note("This figure graphs the cumulative return." "We normalized the event day's return (period = 0) to zero,""then calculate the return for asset.") title("Cumulative Return") ytitle("Percent")
 graph export TR.eps,replace
graph export TR.png,replace


////////////////


 twoway connected VUEReturn VCUEReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)    title("Value (By Return - Market)") legend(pos(5) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulativereturn for  asset.") title("Cumulative excess return from the market") ytitle("Percent")
graph export CUER.eps,replace
graph export CUER.png,replace


 //// P & N
 twoway connected UNEReturn UPEReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend(pos(5) ring(0) col(1) label(1 "Upper Hit in Down day") label(2 "Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative excess return from the market") ytitle("Percent")
 
graph export UPNER.eps,replace
graph export UPNER.png,replace 
 
 

  twoway connected LNEReturn LPEReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(2) label(1 "Lower Hit in Down day") label(2 "Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative excess return from the market") ytitle("Percent")

graph export LPNER.eps,replace
graph export LPNER.png,replace



  twoway connected CLNEReturn CLPEReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(1) label(1 "Near to Lower Hit in Down day") label(2 "Near to Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative excess return from the market") ytitle("Percent")

graph export CLPNER.eps,replace
graph export CLPNER.png,replace


twoway connected CUNEReturn CUPEReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(1) label(1 "Near to Upper Hit in Down day") label(2 "Near to Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative excess return from the market") ytitle("Percent")

graph export CLPNER.eps,replace
graph export CLPNER.png,replace



////

 twoway connected UNAbReturn UPAbReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend(pos(5) ring(0) col(1) label(1 "Upper Hit in Down day") label(2 "Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative Abnormal return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")
 
graph export UPNAbR.eps,replace
graph export UPNAbR.png,replace 
 
 

  twoway connected LNAbReturn LPAbReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(2) label(1 "Lower Hit in Down day") label(2 "Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative Abnormal return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")

graph export LPNAbR.eps,replace
graph export LPNAbR.png,replace



  twoway connected CLNAbReturn CLPAbReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(1) label(1 "Near to Lower Hit in Down day") label(2 "Near to Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative Abnormal return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")

graph export CLPNAbR.eps,replace
graph export CLPNAbR.png,replace


twoway connected CUNAbReturn CUPAbReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   title("Value (By Return - Market)") legend( ring(1) col(1) label(1 "Near to Upper Hit in Down day") label(2 "Near to Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative Abnormal return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulative return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")

graph export CUPNAbR.eps,replace
graph export CUPNAbR.png,replace
////
 
 

 twoway connected VLEReturn VCLEReturn index , msymbol(Sh i) xline(0,lpattern(shortdash_dot)) yline(0)    title("Value (By Return - Market)") legend(pos(5) ring(0) col(1) label(1 "Lower Hit") label(2 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15)  lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulativereturn for  asset.") title("Cumulative excess return from the market") ytitle("Percent")
graph export CLER.eps,replace
graph export CLER.png,replace 
 
 

/////
twoway connected VUAReturn VCUAReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)    title("Value (By Abnormal Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative abnormal return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""abnormal return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")
graph export CUAR.eps,replace
graph export CUAR.png,replace


 twoway connected VLAReturn VCLAReturn index , msymbol(Sh i) xline(0,lpattern(shortdash_dot)) yline(0)    title("Value (By Abnormal Return)") legend(pos(1) ring(0) col(1) label(1 "Lower Hit") label(2 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative abnormal return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""abnormal return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")
graph export CLAR.eps,replace
graph export CLAR.png,replace 


twoway connected VUAReturn VCUAReturn  VCLAReturn VLAReturn index , msymbol(Th  i i Sh) xline(0,lpattern(shortdash_dot)) yline(0) title("Value (By Abnormal Return)") legend(pos(5) ring(1) col(4) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the cumulative abnormal return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""abnormal return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")
 graph export TAR.eps,replace
graph export TAR.png,replace

 //////
twoway connected VUReturn VCUReturn index , msymbol(Th i) xline(0,lpattern(shortdash_dot)) yline(0)   legend(pos(5) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""return for  asset.") title("Cumulative return ") ytitle("Percent")
graph export CUR.eps,replace
graph export CUR.png,replace


 twoway connected VLReturn VCLReturn index , msymbol(Sh i) xline(0,lpattern(shortdash_dot)) yline(0)   legend(pos(5) ring(0) col(1) label(1 "Lower Hit") label(2 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid dash_dot dash_dot solid) note("This figure graphs the cumulative return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""return for  asset.") title("Cumulative return ") ytitle("Percent")
graph export CLR.eps,replace
graph export CLR.png,replace 


////////////



 twoway connected VUEReturn VLEReturn index , msymbol(Th Sh) xline(0,lpattern(shortdash_dot)) yline(0) title("Value (By Return - Market)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)15)  note("This figure graphs the cumulative excess return from market." "We normalized the event day's return (period = 0) to zero,"" then calculate the cumulativereturn for  asset.") title("Cumulative excess return from the market") ytitle("Percent")
 
graph export ER.eps,replace
graph export ER.png,replace	



///////////


 twoway connected VUAReturn VLAReturn index , msymbol(Th Sh) xline(0,lpattern(shortdash_dot)) yline(0)  title("Value (By Abnormal Return)") legend(pos(3) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)15) note("This figure graphs the cumulative abnormal return." "We normalized the event day's return (period = 0) to zero, then calculate the cumulative ""abnormal return for  asset.") title("Cumulative abnormal return ") ytitle("Percent")
  graph export AR.eps,replace
graph export AR.png,replace


   twoway connected VUReturn VLReturn index , msymbol(Th Sh) xline(0,lpattern(shortdash_dot)) yline(0) title("Value (By Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) note("This figure graphs the cumulative return." "We normalized the event day's return (period = 0) to zero, then calculate the return for asset.") title("Cumulative Return") ytitle("Percent")
  graph export R.eps,replace
graph export R.png,replace
 
 
   twoway connected UInslImbalanceValue UIndlImbalanceValue index , xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  graph export UIV.eps,replace
graph export UIV.png,replace




 
 
 
 
  twoway connected UInslImbalance UIndlImbalance index , xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  graph export UI.eps,replace
graph export UI.png,replace


 twoway connected UInslImbalance UIndlImbalance CUInslImbalance CUIndlImbalance index , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual") order (1 2 3 "[4.5,5)") ) xtitle("Peroid") title("Upper Hit via Near to Upper Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  graph export TUI.eps,replace
graph export TUI.png,replace


 twoway connected UInslImbalanceValue UIndlImbalanceValue CUInslImbalanceValue CUIndlImbalanceValue index , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual") order (1 2 3 "[4.5,5)") ) xtitle("Peroid") title("Upper Hit via Near to Upper Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  graph export TUIV.eps,replace
graph export TUIV.png,replace


    twoway connected LInslImbalance LIndlImbalance index ,xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(1) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Hit") xlab(-15(5)15) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
graph export LI.eps,replace
graph export LI.png,replace


    twoway connected LInslImbalanceValue LIndlImbalanceValue index ,xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(1) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Hit") xlab(-15(5)15) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
graph export LIV.eps,replace
graph export LIV.png,replace

  twoway connected LInslImbalance LIndlImbalance CLInslImbalance CLIndlImbalance index ,xline(0,lpattern(shortdash_dot)) msymbol(D O i i)  ytitle("Buy-Sell Imbalances") legend(pos(1) ring(0) col(1) label(1 "Institutional") label(2 "Individual")  order (1 2 3 "(-5,-4.5]")) xtitle("Peroid") title("Lower Hit via Near to Lower Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot )color(navy maroon green green)note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
graph export CLI.eps,replace
graph export CLI.png,replace

  twoway connected LInslImbalanceValue LIndlImbalanceValue CLInslImbalanceValue CLIndlImbalanceValue index ,xline(0,lpattern(shortdash_dot)) msymbol(D O i i)  ytitle("Buy-Sell Imbalances") legend(pos(1) ring(0) col(1) label(1 "Institutional") label(2 "Individual")  order (1 2 3 "(-5,-4.5]")) xtitle("Peroid") title("Lower Hit via Near to Lower Hit") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot )color(navy maroon green green)note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
graph export CLIV.eps,replace
graph export CLIV.png,replace


  twoway connected UTurn LTurn index , xline(0,lpattern(shortdash_dot)) msymbol(Th Sh) ytitle("Turnover") legend(pos(7) ring(0) col(1) label(1 "Upper Hit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)15)	lpattern(solid solid dash_dot dash_dot ) note("This figure graphs the turnover of stock." "It is defined as the amount traded in Rial divided by the market capitalization of the stock.")
 graph export T.eps,replace
graph export T.png,replace

 
 
 
  twoway connected UTurn CUTurn index , xline(0,lpattern(shortdash_dot)) msymbol(Th i) ytitle("Turnover") legend(pos(7) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)")) xtitle("Peroid") xlab(-15(5)15)	 lpattern(solid dash_dot )  note("This figure graphs the turnover of stock." "It is defined as the amount traded in Rial divided by the market capitalization of the stock.")
 graph export CUT.eps,replace
graph export CUT.png,replace

  twoway connected LTurn CLTurn index , xline(0,lpattern(shortdash_dot)) msymbol(Sh i) ytitle("Turnover") legend(pos(7) ring(0) col(1) label(1 "Lower Hit") label(2 "(-5,-4.5]")) xtitle("Peroid")  xlab(-15(5)15)	lpattern(solid dash_dot )note("This figure graphs the turnover of stock." "It is defined as the amount traded in Rial divided by the market capitalization of the stock.")
  
 graph export CLT.eps,replace
graph export CLT.png,replace




 twoway connected UTurn CUTurn CLTurn LTurn index ,msymbol(Th i i Sh) xline(0,lpattern(shortdash_dot)) yline(1)    ytitle("Turnover") legend(pos(1) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the turnover of stock." "It is defined as the amount traded in Rial divided by the market capitalization of the stock.")
  graph export TT.eps,replace
graph export TT.png,replace



 
 twoway connected URelReturn LRelReturn index , xline(0,lpattern(shortdash_dot)) msymbol(Th Sh)  ytitle("Relative turnover ") legend(pos(7) ring(0) col(1) label(1 "Upper Hit") label(2 "Lower Hit")) xtitle("Peroid") xlab(-15(5)15)	note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")
graph export RT.eps,replace
graph export RT.png,replace
 

twoway connected URelReturn CURelReturn   index , xline(0,lpattern(shortdash_dot))    ytitle("Relative turnover") legend(pos(7) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) msymbol(Th  i i Sh)  xtitle("Peroid") xlab(-15(5)15)  lpattern(solid dash_dot dash_dot solid)note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")
graph export CURT.eps,replace
graph export CURT.png,replace

twoway connected LRelReturn CLRelReturn   index , xline(0,lpattern(shortdash_dot))    ytitle("Relative turnover") legend(pos(7) ring(0) col(1) label(3 "Upper Limit") label(4 "[4.5,5)") label(1 "Lower Hit") label(2 "(-5,-4.5]")) msymbol(Sh i  )  xtitle("Peroid") xlab(-15(5)15)  lpattern(solid dash_dot dash_dot solid)note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")
graph export CLRT.eps,replace
graph export CLRT.png,replace




 twoway connected URelReturn CURelReturn CLRelReturn LRelReturn index ,msymbol(Th i i Sh) xline(0,lpattern(shortdash_dot))   ytitle("Relative turnover") legend(pos(1) ring(0) col(1) label(1 "Upper Hit") label(2 "[4.5,5)") label(4 "Lower Hit") label(3 "(-5,-4.5]")) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")
  graph export TRT.eps,replace
graph export TRT.png,replace
 

  
  
 //////////
  
  
twoway connected LNRelTurn LPRelTurn index ,msymbol(Th i i Sh) legend( ring(1) col(1) label(1 "Lower Hit in Down day") label(2 "Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")  ytitle("Relative turnover") xline(0,lpattern(shortdash_dot))
graph export LPNRT.eps,replace
graph export LPNRT.png,replace

twoway connected   UNRelTurn UPRelTurn index ,msymbol(Th i i Sh) legend( ring(1) col(1) label(1 "Upper Hit in Down day") label(2 "Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")  ytitle("Relative turnover") xline(0,lpattern(shortdash_dot))
graph export UPNRT.eps,replace
graph export UPNRT.png,replace
 
 
twoway connected   CUNRelTurn CUPRelTurn index ,msymbol(Th i i Sh) legend( ring(1) col(1) label(1 "Near to Upper Hit in Down day") label(2 "Near to Upper Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")  ytitle("Relative turnover") xline(0,lpattern(shortdash_dot))
graph export CUPNRT.eps,replace
graph export CUPNRT.png,replace


twoway connected   CLNRelTurn CLPRelTurn index ,msymbol(Th i i Sh) legend( ring(1) col(1) label(1 "Near to Lower Hit in Down day") label(2 "Near to Lower Hit in Up day")) xtitle("Peroid") xlab(-15(5)15) xtitle("Peroid") xlab(-15(5)15) lpattern( solid solid dash_dot solid) note("This figure graphs the relative turnover of stock." "It is defined as the ratio of the turnover of stock k on date t to the 60 day average turnover""of stock k.")  ytitle("Relative turnover") xline(0,lpattern(shortdash_dot))
graph export CLPNRT.eps,replace
graph export CLPNRT.png,replace
 
 ////////////////////////
 
 
  twoway connected UNInslImbalance UNIndlImbalance index  , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Hit in Down day") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  
graph export NUI.eps,replace
graph export NUI.png,replace

 twoway connected UPInslImbalance UPIndlImbalance index  , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Hit in Up day") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  
graph export PUI.eps,replace
graph export PUI.png,replace
 
 
 
   twoway connected LNInslImbalance LNIndlImbalance index  , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Hit in Down day") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  
graph export NLI.eps,replace
graph export NLI.png,replace

 twoway connected LPInslImbalance LPIndlImbalance index  , xline(0,lpattern(shortdash_dot)) msymbol(D O i i Oh) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Hit in Up day") xlab(-15(5)15) lpattern(solid solid dash_dot dash_dot ) color(navy maroon green green) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  
graph export PLI.eps,replace
graph export PLI.png,replace
 
 
 
 
 // twoway connected  VUEReturn VLEReturn index ,xline(0) yline(1)  ytitle("Value (By Excess Return)") legend(pos(5) ring(0) col(1) label(1 "Upper Limit") label(2 "Lower Hit")) xtitle("Peroid")
 
 drop if index <-5
 drop if index >5
 twoway connected UInslImbalance UIndlImbalance index , xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(5) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Upper Hit") xlab(-5(1)5) lpattern(solid solid dash_dot dash_dot ) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
  graph export UI2.eps,replace
graph export UI2.png,replace
 
 
    twoway connected LInslImbalance LIndlImbalance index ,xline(0,lpattern(shortdash_dot)) msymbol(D O) ytitle("Buy-Sell Imbalances") legend(pos(1) ring(0) col(1) label(1 "Institutional") label(2 "Individual")) xtitle("Peroid") title("Lower Hit")  xlab(-5(1)5) note("This figure graphs the buy-sell imbalances for each type. ""It is defined as the net buying ratio of stock k on date t by a particular type to the amounts bought ""and sold by that type.")
graph export LI2.eps,replace
graph export LI2.png,replace



twoway connected CLIndValue CLInsValue  index , xline(0) xlab(-5(1)5)legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Lower Hit") msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy)
graph export CLV2.eps,replace
graph export CLV2.png,replace

twoway connected LIndValue LInsValue  index , xline(0) xlab(-5(1)5)legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Lower Hit")  msymbol(O D) ytitle("HMT") xtitle("Period") color(maroon navy)
graph export LV2.eps,replace
graph export LV2.png,replace

twoway connected  UIndValue UInsValue  index , xline(0) xlab(-5(1)5) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Upper Hit") msymbol(O D) ytitle("HMT") xtitle("Period")color(maroon navy)
graph export UV2.eps,replace
graph export UV2.png,replace

twoway connected  CUIndValue CUInsValue  index , xline(0) xlab(-5(1)5) legend(label(1 "Individual Net Buy") label(2 "Institutional Net Buy")) title("Near to Upper Hit") msymbol(O D) ytitle("HMT") xtitle("Period")color(maroon navy)
graph export CUV2.eps,replace
graph export CUV2.png,replace
 
 