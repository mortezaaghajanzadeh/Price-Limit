 cls
clear
import delimited "H:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit\VVdata.csv", encoding(UTF-8)
 
 cd"G:\Dropbox\Dropbox\Finance(Prof.Heidari-Aghajanzadeh)\Project\PriceLimit\Final Report"





line v4 period if flag == "Ab" & eflag == "U"|| rarea v5 v3 period if flag == "Ab" & eflag == "U" , color(gs15)|| line v3 period if flag == "Ab" & eflag == "U"  , lpattern(dash_dot ) color(gray )|| line v5 period if flag == "Ab" & eflag == "U" , lpattern(dash_dot ) color(gray )|| line v2 period if flag == "Ab" & eflag == "U" , xlab(-15(5)15) xline(0,lpattern(dash))  lpattern(longdash ) color(navy ) legend(pos(7) ring(0) col(1) label(5 "Mean") label(2 "95Percentile") order(5 2)) ytitle("Value (By Abnormal Return)")title("Upper Limit Hit") note("This figure graphs the value of an asset according to abnormal return." "We normalized the event day's close price (period = 0) to one, then calculate the value of asset""according to their return.")

 graph export 95U.eps,replace
graph export 95U.png,replace


line v4 period if flag == "Ab" & eflag == "L"|| rarea v5 v3 period if flag == "Ab" & eflag == "L" , color(gs15)|| line v3 period if flag == "Ab" & eflag == "L"  , lpattern(dash_dot ) color(gray )|| line v5 period if flag == "Ab" & eflag == "L" , lpattern(dash_dot ) color(gray )|| line v2 period if flag == "Ab" & eflag == "L" , xlab(-15(5)15) xline(0,lpattern(dash))  lpattern(longdash ) color(navy ) legend(pos(7) ring(0) col(1) label(5 "Mean") label(2 "95Percentile") order(5 2)) ytitle("Value (By Abnormal Return)") title("Lower Limit Hit") note("This figure graphs the value of an asset according to abnormal return." "We normalized the event day's close price (period = 0) to one, then calculate the value of asset""according to their return.")

 graph export 95L.eps,replace
graph export 95L.png,replace

