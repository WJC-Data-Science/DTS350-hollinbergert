---
title: "12 Case Study: Building the Past"
author: "TomHollinberger"
date: "11/10/2020"
output: 
 html_document: 
   keep_md: yes
   toc: TRUE
   toc_depth: 6
   code_folding:  hide
   results: 'hide'
   message: FALSE
   warning: FALSE
---  
---  
THIS RSCRIPT USES ROXYGEN CHARACTERS.  
YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_12/analysis/


```r
library(tidyverse)
```

```
## -- Attaching packages ------------------------------------------------------------------------ tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.2     v purrr   0.3.4
## v tibble  3.0.3     v dplyr   1.0.0
## v tidyr   1.1.0     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.5.0
```

```
## -- Conflicts --------------------------------------------------------------------------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(readr)
library(haven)
library(readxl)
library(downloader)
library(dplyr)


##GET PERMIT DATA
tmpcsv <- tempfile()
tmpcsv
```

```
## [1] "C:\\Users\\tomho\\AppData\\Local\\Temp\\Rtmpewc2Xl\\file336035be7ce8"
```

```r
tempdir()
```

```
## [1] "C:\\Users\\tomho\\AppData\\Local\\Temp\\Rtmpewc2Xl"
```

```r
download("https://github.com/WJC-Data-Science/DTS350/raw/master/permits.csv",tmpcsv, mode = "wb")
permitscsv <- read_csv(tmpcsv)
```

```
## Warning: Missing column names filled in: 'X1' [1]
```

```
## Parsed with column specification:
## cols(
##   X1 = col_double(),
##   state = col_double(),
##   StateAbbr = col_character(),
##   county = col_double(),
##   countyname = col_character(),
##   variable = col_character(),
##   year = col_double(),
##   value = col_double()
## )
```

```r
#View(permitscsv)  
summary(permitscsv)
```

```
##        X1             state        StateAbbr             county     
##  Min.   :     1   Min.   : 1.00   Length:327422      Min.   :  1.0  
##  1st Qu.: 81856   1st Qu.:18.00   Class :character   1st Qu.: 33.0  
##  Median :163712   Median :29.00   Mode  :character   Median : 75.0  
##  Mean   :163712   Mean   :30.09                      Mean   : 98.5  
##  3rd Qu.:245567   3rd Qu.:45.00                      3rd Qu.:127.0  
##  Max.   :327422   Max.   :56.00                      Max.   :840.0  
##   countyname          variable              year          value        
##  Length:327422      Length:327422      Min.   :1980   Min.   :    1.0  
##  Class :character   Class :character   1st Qu.:1987   1st Qu.:    9.0  
##  Mode  :character   Mode  :character   Median :1995   Median :   38.0  
##                                        Mean   :1995   Mean   :  308.3  
##                                        3rd Qu.:2002   3rd Qu.:  163.0  
##                                        Max.   :2010   Max.   :70225.0
```

```r
unique(permitscsv$StateAbbr) #DOES HAVE AK, HI, & DC.  DOESNOT HAVE PR.  AK sorts after AL?
```

```
##  [1] "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" "IN"
## [16] "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH"
## [31] "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT"
## [46] "VT" "VA" "WA" "WV" "WI" "WY"
```

```r
str(permitscsv)
```

```
## tibble [327,422 x 8] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ X1        : num [1:327422] 1 2 3 4 5 6 7 8 9 10 ...
##  $ state     : num [1:327422] 1 1 1 1 1 1 1 1 1 1 ...
##  $ StateAbbr : chr [1:327422] "AL" "AL" "AL" "AL" ...
##  $ county    : num [1:327422] 1 1 1 1 1 1 1 1 1 1 ...
##  $ countyname: chr [1:327422] "Autauga County" "Autauga County" "Autauga County" "Autauga County" ...
##  $ variable  : chr [1:327422] "All Permits" "All Permits" "All Permits" "All Permits" ...
##  $ year      : num [1:327422] 2010 2009 2008 2007 2006 ...
##  $ value     : num [1:327422] 191 110 173 260 347 313 367 283 276 400 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   X1 = col_double(),
##   ..   state = col_double(),
##   ..   StateAbbr = col_character(),
##   ..   county = col_double(),
##   ..   countyname = col_character(),
##   ..   variable = col_character(),
##   ..   year = col_double(),
##   ..   value = col_double()
##   .. )
```

```r
#Test Pike County Ohio    In USA Boundaries  county fp = 131, statefp = 39
PikeOhio <- filter(permitscsv, state == 39 & county == 131)
PikeOhio
```

```
## # A tibble: 91 x 8
##        X1 state StateAbbr county countyname  variable     year value
##     <dbl> <dbl> <chr>      <dbl> <chr>       <chr>       <dbl> <dbl>
##  1 221553    39 OH           131 Pike County All Permits  2010    75
##  2 221554    39 OH           131 Pike County All Permits  2009    80
##  3 221555    39 OH           131 Pike County All Permits  2008   111
##  4 221556    39 OH           131 Pike County All Permits  2007    59
##  5 221557    39 OH           131 Pike County All Permits  2006    76
##  6 221558    39 OH           131 Pike County All Permits  2005   155
##  7 221559    39 OH           131 Pike County All Permits  2004   233
##  8 221560    39 OH           131 Pike County All Permits  2003   204
##  9 221561    39 OH           131 Pike County All Permits  2002    35
## 10 221562    39 OH           131 Pike County All Permits  2001    22
## # ... with 81 more rows
```

```r
##CONFIRM   (state and county in csv)  == (statefp and countyfp in USAboundaries)

unique(permitscsv$variable)  #has 6 types of permit aggregations:   "All Permits" "Single Family" "All Multifamily""2-Unit Multifamily""3 & 4-Unit Multifamily" "5+-Unit Multifamily"   
```

```
## [1] "All Permits"            "Single Family"          "All Multifamily"       
## [4] "2-Unit Multifamily"     "3 & 4-Unit Multifamily" "5+-Unit Multifamily"
```

```r
#need to filter for only the "All Permit" data
allpermits <- filter(permitscsv, variable == "All Permits")
allpermits    #drops the total rows from 327422 to 87396
```

```
## # A tibble: 87,396 x 8
##       X1 state StateAbbr county countyname     variable     year value
##    <dbl> <dbl> <chr>      <dbl> <chr>          <chr>       <dbl> <dbl>
##  1     1     1 AL             1 Autauga County All Permits  2010   191
##  2     2     1 AL             1 Autauga County All Permits  2009   110
##  3     3     1 AL             1 Autauga County All Permits  2008   173
##  4     4     1 AL             1 Autauga County All Permits  2007   260
##  5     5     1 AL             1 Autauga County All Permits  2006   347
##  6     6     1 AL             1 Autauga County All Permits  2005   313
##  7     7     1 AL             1 Autauga County All Permits  2004   367
##  8     8     1 AL             1 Autauga County All Permits  2003   283
##  9     9     1 AL             1 Autauga County All Permits  2002   276
## 10    10     1 AL             1 Autauga County All Permits  2001   400
## # ... with 87,386 more rows
```

```r
unique(permitscsv$StateAbbr)   #still have 51 states
```

```
##  [1] "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" "IN"
## [16] "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH"
## [31] "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT"
## [46] "VT" "VA" "WA" "WV" "WI" "WY"
```

```r
write_csv(allpermits,"allpermits.csv")  #check in file explorer to be sure you got what you wanted.


# Check years of coverage
unique(allpermits$year)    #1980 -- 2010
```

```
##  [1] 2010 2009 2008 2007 2006 2005 2004 2003 2002 2001 2000 1999 1998 1997 1996
## [16] 1995 1994 1993 1992 1991 1990 1989 1988 1987 1986 1985 1984 1983 1982 1981
## [31] 1980
```

```r
#Permits : Group by and Summarize by state by year
styr <- allpermits %>%
  group_by(StateAbbr, year) %>%
  summarise(sumval = sum(value, na.rm = TRUE))
```

```
## `summarise()` regrouping output by 'StateAbbr' (override with `.groups` argument)
```

```r
#Scale down the value by dividing by 1000
styr$sumvalk <- styr$sumval / 1000 

styr  # Sum of All Permits by state for each year 1980 thru 2010
```

```
## # A tibble: 1,580 x 4
## # Groups:   StateAbbr [51]
##    StateAbbr  year sumval sumvalk
##    <chr>     <dbl>  <dbl>   <dbl>
##  1 AK         1980   1837   1.84 
##  2 AK         1981   3862   3.86 
##  3 AK         1982   7438   7.44 
##  4 AK         1983  10671  10.7  
##  5 AK         1984   6264   6.26 
##  6 AK         1985   4038   4.04 
##  7 AK         1986   1399   1.40 
##  8 AK         1987    763   0.763
##  9 AK         1988    838   0.838
## 10 AK         1989    645   0.645
## # ... with 1,570 more rows
```

```r
#Now exclude CA, TX, and FL beacuse they are soo big, they stretch the y-scale and dwarf the other states.
styrwoCATXFL <- filter(styr, !StateAbbr %in% c("CA", "TX", "FL"))

str(styrwoCATXFL)
```

```
## tibble [1,487 x 4] (S3: grouped_df/tbl_df/tbl/data.frame)
##  $ StateAbbr: chr [1:1487] "AK" "AK" "AK" "AK" ...
##  $ year     : num [1:1487] 1980 1981 1982 1983 1984 ...
##  $ sumval   : num [1:1487] 1837 3862 7438 10671 6264 ...
##  $ sumvalk  : num [1:1487] 1.84 3.86 7.44 10.67 6.26 ...
##  - attr(*, "groups")= tibble [48 x 2] (S3: tbl_df/tbl/data.frame)
##   ..$ StateAbbr: chr [1:48] "AK" "AL" "AR" "AZ" ...
##   ..$ .rows    : list<int> [1:48] 
##   .. ..$ : int [1:31] 1 2 3 4 5 6 7 8 9 10 ...
##   .. ..$ : int [1:31] 32 33 34 35 36 37 38 39 40 41 ...
##   .. ..$ : int [1:31] 63 64 65 66 67 68 69 70 71 72 ...
##   .. ..$ : int [1:31] 94 95 96 97 98 99 100 101 102 103 ...
##   .. ..$ : int [1:31] 125 126 127 128 129 130 131 132 133 134 ...
##   .. ..$ : int [1:31] 156 157 158 159 160 161 162 163 164 165 ...
##   .. ..$ : int [1:30] 187 188 189 190 191 192 193 194 195 196 ...
##   .. ..$ : int [1:31] 217 218 219 220 221 222 223 224 225 226 ...
##   .. ..$ : int [1:31] 248 249 250 251 252 253 254 255 256 257 ...
##   .. ..$ : int [1:31] 279 280 281 282 283 284 285 286 287 288 ...
##   .. ..$ : int [1:31] 310 311 312 313 314 315 316 317 318 319 ...
##   .. ..$ : int [1:31] 341 342 343 344 345 346 347 348 349 350 ...
##   .. ..$ : int [1:31] 372 373 374 375 376 377 378 379 380 381 ...
##   .. ..$ : int [1:31] 403 404 405 406 407 408 409 410 411 412 ...
##   .. ..$ : int [1:31] 434 435 436 437 438 439 440 441 442 443 ...
##   .. ..$ : int [1:31] 465 466 467 468 469 470 471 472 473 474 ...
##   .. ..$ : int [1:31] 496 497 498 499 500 501 502 503 504 505 ...
##   .. ..$ : int [1:31] 527 528 529 530 531 532 533 534 535 536 ...
##   .. ..$ : int [1:31] 558 559 560 561 562 563 564 565 566 567 ...
##   .. ..$ : int [1:31] 589 590 591 592 593 594 595 596 597 598 ...
##   .. ..$ : int [1:31] 620 621 622 623 624 625 626 627 628 629 ...
##   .. ..$ : int [1:31] 651 652 653 654 655 656 657 658 659 660 ...
##   .. ..$ : int [1:31] 682 683 684 685 686 687 688 689 690 691 ...
##   .. ..$ : int [1:31] 713 714 715 716 717 718 719 720 721 722 ...
##   .. ..$ : int [1:31] 744 745 746 747 748 749 750 751 752 753 ...
##   .. ..$ : int [1:31] 775 776 777 778 779 780 781 782 783 784 ...
##   .. ..$ : int [1:31] 806 807 808 809 810 811 812 813 814 815 ...
##   .. ..$ : int [1:31] 837 838 839 840 841 842 843 844 845 846 ...
##   .. ..$ : int [1:31] 868 869 870 871 872 873 874 875 876 877 ...
##   .. ..$ : int [1:31] 899 900 901 902 903 904 905 906 907 908 ...
##   .. ..$ : int [1:31] 930 931 932 933 934 935 936 937 938 939 ...
##   .. ..$ : int [1:31] 961 962 963 964 965 966 967 968 969 970 ...
##   .. ..$ : int [1:31] 992 993 994 995 996 997 998 999 1000 1001 ...
##   .. ..$ : int [1:31] 1023 1024 1025 1026 1027 1028 1029 1030 1031 1032 ...
##   .. ..$ : int [1:31] 1054 1055 1056 1057 1058 1059 1060 1061 1062 1063 ...
##   .. ..$ : int [1:31] 1085 1086 1087 1088 1089 1090 1091 1092 1093 1094 ...
##   .. ..$ : int [1:31] 1116 1117 1118 1119 1120 1121 1122 1123 1124 1125 ...
##   .. ..$ : int [1:31] 1147 1148 1149 1150 1151 1152 1153 1154 1155 1156 ...
##   .. ..$ : int [1:31] 1178 1179 1180 1181 1182 1183 1184 1185 1186 1187 ...
##   .. ..$ : int [1:31] 1209 1210 1211 1212 1213 1214 1215 1216 1217 1218 ...
##   .. ..$ : int [1:31] 1240 1241 1242 1243 1244 1245 1246 1247 1248 1249 ...
##   .. ..$ : int [1:31] 1271 1272 1273 1274 1275 1276 1277 1278 1279 1280 ...
##   .. ..$ : int [1:31] 1302 1303 1304 1305 1306 1307 1308 1309 1310 1311 ...
##   .. ..$ : int [1:31] 1333 1334 1335 1336 1337 1338 1339 1340 1341 1342 ...
##   .. ..$ : int [1:31] 1364 1365 1366 1367 1368 1369 1370 1371 1372 1373 ...
##   .. ..$ : int [1:31] 1395 1396 1397 1398 1399 1400 1401 1402 1403 1404 ...
##   .. ..$ : int [1:31] 1426 1427 1428 1429 1430 1431 1432 1433 1434 1435 ...
##   .. ..$ : int [1:31] 1457 1458 1459 1460 1461 1462 1463 1464 1465 1466 ...
##   .. ..@ ptype: int(0) 
##   ..- attr(*, ".drop")= logi TRUE
```

```r
unique(styr$StateAbbr)   #51 states
```

```
##  [1] "AK" "AL" "AR" "AZ" "CA" "CO" "CT" "DC" "DE" "FL" "GA" "HI" "IA" "ID" "IL"
## [16] "IN" "KS" "KY" "LA" "MA" "MD" "ME" "MI" "MN" "MO" "MS" "MT" "NC" "ND" "NE"
## [31] "NH" "NJ" "NM" "NV" "NY" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT"
## [46] "VA" "VT" "WA" "WI" "WV" "WY"
```

```r
unique(styrwoCATXFL$StateAbbr)  #48 states excluding CA, TX, FL
```

```
##  [1] "AK" "AL" "AR" "AZ" "CO" "CT" "DC" "DE" "GA" "HI" "IA" "ID" "IL" "IN" "KS"
## [16] "KY" "LA" "MA" "MD" "ME" "MI" "MN" "MO" "MS" "MT" "NC" "ND" "NE" "NH" "NJ"
## [31] "NM" "NV" "NY" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "UT" "VA" "VT" "WA"
## [46] "WI" "WV" "WY"
```

```r
library(geofacet)   #install.packages("geofacet")
```

```
## Warning: package 'geofacet' was built under R version 4.0.3
```

```r
# All States, and DC
```

### **PLOT 1 INSIGHT** : This plot shows housing permits from 1980 to 2010 in all states.  
The time window is important because it shows the 2008 crash, and also reaches back to the Recession of 1981, 
when the housing market had a similar downturn.  The obvious worst-case situations are CA, TX, and FL, 
but they have such large values, they stretch the y-axis and dwarf the other states.  
The next chart zooms in on these other states.
These charts use the GEOFACET package which provides a visual arrangement of states on a map, but also allows charted data to be displayed for each state.  
It's a useful compromise between numeric charts and geographic maps.


```r
ggplot(styr, aes(year,sumvalk)) +
  geom_line() + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Housing Permits per Year (Thousands)") +
  xlab("Year") +
  labs(title = "Housing Permits by State by Year (All States & DC)")
```

![](12CaseStudy_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
ggsave("geofacet all states.png")  
```

```
## Saving 7 x 5 in image
```

```r
#Graph without CA, TX, or FL because their values stretch the y-axis and dwarf the other states. 
  library(geofacet)  #install.packages("geofacet")
```

### **PLOT 2 INSIGHT** : This plot shows the same data, except that  CA, TX, or FL have been excluded
because their high values stretch the y-axis and dwarf the other states.  Now, with a more 'zoomed-in' y axis, 
you can see similar 'crash' trends in some states, but not others. 
It's hard to discern a pattern.  Perhaps coastal (AZ, GA, NC, VA), but also more populated Midwest states (OH, MI, IL, MN, CO)
According to https://www.thestreet.com/personal-finance/savings/the-five-states-hit-hardest-by-foreclosures-10414898
the top 5 hardest hit states (measured by foreclosures) were Nevada, California, Florida, Colorado, and Arizona.  


```r
ggplot(styrwoCATXFL, aes(year,sumvalk)) +
    geom_line() + 
    facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
    scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
    ylab("Housing Permits per Year (Thousands)") +
    xlab("Year") +
    labs(title = "Housing Permits by State by Year (excluding CA, TX, and FL for scaling purposes)")
```

![](12CaseStudy_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
ggsave("geofacet woCATXFL.png") 
```

```
## Saving 7 x 5 in image
```

