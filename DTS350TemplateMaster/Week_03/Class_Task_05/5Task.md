---
title: "Task 5: Data Import and ggplot2"
author: "TomHollinberger"
date: "9/9/2020"
output: 
 html_document: 
   keep_md: yes
   toc: TRUE
 
---
THIS RSCRIPT USES ROXYGEN CHARACTERS.  
YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.

# **Section 1:  What I Learned, What Was Difficult**
1. Parsing, the concept is hard to grasp.  Seems powerful for bringing in subsets of data, and data clean-up
2. Maybe several more before-and-after parsing examples, and some plain language explanation would help.
3. ggplot direct.labels is very handy, it seems to be able to put the label in the center-of-mass of the group of points.
4. ggrepel and nudging is valuable to get the labels further out of the way.  I guess it applies to all points, can't be customized for individual points.
5. theme has a lot of internal parts.  They seem straightforward, but there's a lot of options to keep in mind.
6. linetype will be very useful in the future. 
7. Use     toc_depth: 4  in the YAML to make the table of contents go down to the 4th level.
8. spin allows you to go directly from rscript to html by typing ctrl+shift+k, but you have to you spin-specific code in the Rscript, like #' instead of just #.  This helps avoid having to create a bunch of code chunks in RMD.
9. When adding theme, you don't need the p at the end to get it to plot to the lower right screen window
10. if hjust = 1, that takes the title the max right-side.
11. nudge_x = 40, pretty much maxes the labels over flush to the right side.
12. When Importing, getwd() tells you where it's going to be imported to.
13. Rename needs you to assign the results to something, so you'll need a "newdf <-" in front of "rename"
14. An easy way to write the rename command is to copy the first line from the csv, into the Rscript line.  That types the old column titles for you. 
15.  Using spin reduced the handwork of creating code chunks in RMD.  ctrl+shift+k to spin from R to html, thus skipping the RMD-creation handwork.
16. readxl / excel_sheets, read_excel will be a very useful library/tools, since they can download a non-csv excel file that has multiple worksheets, and read-into-R one of its worksheets.

# **Section 2:  Download, Read, Manipulate (Change Column Titles), Save as csv** 


```r
library(tidyverse)
```

```
## -- Attaching packages ----------------------------------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.2     v purrr   0.3.4
## v tibble  3.0.3     v dplyr   1.0.0
## v tidyr   1.1.0     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.5.0
```

```
## -- Conflicts -------------------------------------------------------------------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

## **Download** a file from FiveThirtyEight
Check working directory first to make sure you agree with where it's going.


```r
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/Class_Task_05"
```

```
## [1] "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/Class_Task_05"
```

```r
download.file("https://raw.githubusercontent.com/fivethirtyeight/data/master/covid-geography/mmsa-icu-beds.csv",
             "covid.csv", mode = "wb")  #saves to working directory
```

Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command

## **Read_csv** in the "Path/File" 


```r
covid <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/Class_Task_05/covid.csv")   #could filter at this point
```

```
## Parsed with column specification:
## cols(
##   MMSA = col_character(),
##   total_percent_at_risk = col_character(),
##   high_risk_per_ICU_bed = col_double(),
##   high_risk_per_hospital = col_double(),
##   icu_beds = col_double(),
##   hospitals = col_double(),
##   total_at_risk = col_double()
## )
```

```r
head(covid, n = 10)
```

```
## # A tibble: 10 x 7
##    MMSA  total_percent_a~ high_risk_per_I~ high_risk_per_h~ icu_beds hospitals
##    <chr> <chr>                       <dbl>            <dbl>    <dbl>     <dbl>
##  1 San ~ 52.88%                        NA               NA        NA        NA
##  2 Manh~ 47.29%                      4490.            8980.        8         4
##  3 Hilt~ 62.72%                      3904.           36439.       28         3
##  4 Kahu~ 59.13%                      3861.           19303.       20         4
##  5 Spar~ 66.12%                      3786.           85188.       45         2
##  6 Bato~ 66.60%                      3460.           39001.      124        11
##  7 Rock~ 57.72%                      3365.           40381.       60         5
##  8 Sali~ 68.32%                      3292.           37312.       68         6
##  9 Wich~ 67.11%                      3279.           19677.       24         4
## 10 Colo~ 55.96%                      3252.           77226.       95         4
## # ... with 1 more variable: total_at_risk <dbl>
```


## **Manipulate** (Use *'rename'* to Change Column Titles) 


```r
covid_new_col_names <- rename(covid,city = MMSA, totalpctatrisk = total_percent_at_risk, hiriskpericubed = high_risk_per_ICU_bed, hiriskperhosp = high_risk_per_hospital,	icubeds = icu_beds,	hosp = hospitals,	totalatrisk = total_at_risk)
```

it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.


```r
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
head(covid_new_col_names, n = 10)
```

```
## # A tibble: 10 x 7
##    city   totalpctatrisk hiriskpericubed hiriskperhosp icubeds  hosp totalatrisk
##    <chr>  <chr>                    <dbl>         <dbl>   <dbl> <dbl>       <dbl>
##  1 San J~ 52.88%                     NA            NA       NA    NA     923725.
##  2 Manha~ 47.29%                   4490.         8980.       8     4      35919.
##  3 Hilto~ 62.72%                   3904.        36439.      28     3     109317.
##  4 Kahul~ 59.13%                   3861.        19303.      20     4      77211.
##  5 Spart~ 66.12%                   3786.        85188.      45     2     170375.
##  6 Baton~ 66.60%                   3460.        39001.     124    11     429007.
##  7 Rocki~ 57.72%                   3365.        40381.      60     5     201903.
##  8 Salis~ 68.32%                   3292.        37312.      68     6     223874.
##  9 Wichi~ 67.11%                   3279.        19677.      24     4      78706.
## 10 Color~ 55.96%                   3252.        77226.      95     4     308902.
```


## **Save as a csv**


```r
write_csv(covid_new_col_names,"covid_new_col_names.csv")  #check in excel to be sure you got what you wanted.
```

       


```r
library(tidyverse)
library(dplyr)
```

### Example:
 First we will download an example csv file from the Urban Institute's Education data portal. Make sure you know where the file is going to download. You might want to run getwd() to see what your working directory is.
NOTE: If you are using a PC, you need an extra argument in your download.file() function:
THESE 2 LINES OF CODE WAS RUN ONCE WITH ctrl+shift+K, then #'d it out, because it doesn't need to be downloaded every time:    download.file("https://educationdata.urban.org/csv/ipeds/colleges_ipeds_completers.csv",
               "colleges_ipeds_completers.csv", mode = "wb")
Now we use the read_csv function to load the data.


```r
ipeds <- read_csv("colleges_ipeds_completers.csv")
```

```
## Parsed with column specification:
## cols(
##   unitid = col_double(),
##   year = col_double(),
##   fips = col_double(),
##   race = col_double(),
##   sex = col_double(),
##   completers = col_double()
## )
```

Parsed with column specification:
cols(
  unitid = col_double(),
  year = col_double(),
  fips = col_double(),
  race = col_double(),
  sex = col_double(),
  completers = col_double()
)
We now have a tibble that can be used with ggplot2 to make visualizations and dplyr to modify the data set.
When we have a dataset that we want to save to use for later, we can use the write_csv() function to save it. For example, let's create a new data set called ipeds_2011 which contains only the 2011 data from our data set. Then save this data set in the working directory.



```r
ipeds_2011 <- ipeds %>%
  filter(year == 2011)
head(ipeds_2011, n = 10)
```

```
## # A tibble: 10 x 6
##    unitid  year  fips  race   sex completers
##     <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl>
##  1 100654  2011     1     7     1          0
##  2 100654  2011     1     7    99          0
##  3 100654  2011     1     7     2          0
##  4 100654  2011     1     5     1          1
##  5 100654  2011     1     5    99          1
##  6 100654  2011     1     5     2          0
##  7 100654  2011     1     4     1          7
##  8 100654  2011     1     4    99         10
##  9 100654  2011     1     4     2          3
## 10 100654  2011     1     2     1        268
```

```r
write_csv(ipeds_2011, "colleges_ipeds_completers_2011.csv")
getwd()
```

```
## [1] "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/Class_Task_05"
```

________________________________________
### Exercise:
### [1] Filter the ipeds data frome to years 2014-2015 for the state of California (Hint: fips code of 6). Be sure to save this to a new object.  **Done, See Code Below**


```r
ipeds_CA_201415 <- ipeds %>%
  filter(year == 2014 | year == 2015, fips == 6)
head(ipeds_CA_201415,n = 10)
```

```
## # A tibble: 10 x 6
##    unitid  year  fips  race   sex completers
##     <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl>
##  1 108232  2014     6     7     1          6
##  2 108232  2014     6     7    99         16
##  3 108232  2014     6     7     2         10
##  4 108232  2014     6     5     1          5
##  5 108232  2014     6     5    99         14
##  6 108232  2014     6     5     2          9
##  7 108232  2014     6     4     1        108
##  8 108232  2014     6     4    99        233
##  9 108232  2014     6     4     2        125
## 10 108232  2014     6     2     1         41
```

```r
tail(ipeds_CA_201415,n = 10)
```

```
## # A tibble: 10 x 6
##    unitid  year  fips  race   sex completers
##     <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl>
##  1 489858  2015     6     8     2          1
##  2 489858  2015     6    99     1          7
##  3 489858  2015     6    99    99         29
##  4 489858  2015     6    99     2         22
##  5 489858  2015     6     9     1          1
##  6 489858  2015     6     9    99          2
##  7 489858  2015     6     9     2          1
##  8 489858  2015     6     1     1          2
##  9 489858  2015     6     1    99         10
## 10 489858  2015     6     1     2          8
```

### [2] Write your new data frame to a file called "ipeds_completers_ca.csv".  **Done, See Code Below**



```r
write_csv(ipeds_CA_201415, "ipeds_completers_ca.csv")
getwd()
```

```
## [1] "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/Class_Task_05"
```


## **The readxl Package**
We need to load the readxl package.
install.packages("readxl")



```r
library(readxl)
```

If we have data saved as .xls or .xlsx, we use the readxl package.
________________________________________
### Example:
 For this example, we will download data from the HUD FHA Single Family LPortfolio Snap Shot.
THESE 2 LINES OF CODE WAS RUN ONCE WITH ctrl+shift+K, then #'d it out, because it doesn't need to be downloaded every time: download.file("https://www.hud.gov/sites/dfiles/Housing/documents/FHA_SFSnapshot_Apr2019.xlsx",
             "sfsnap.xlsx", mode = "wb")
This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.



```r
excel_sheets("sfsnap.xlsx")
```

```
## [1] "Title Page"                  "Report Generator April 2019"
## [3] "Purchase Data April 2019"    "Refinance Data April 2019"  
## [5] "Definitions"
```

[1] "Title Page"                  "Report Generator April 2019"
[3] "Purchase Data April 2019"    "Refinance Data April 2019"  
[5] "Definitions"
Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.



```r
purchases <- read_excel("sfsnap.xlsx", sheet = "Purchase Data April 2019")
```

________________________________________
### Exercise:
### [3] Use the read_excel() function to load in the table on the "Refinance Data April 2019" sheet into a data frame called "refinances".   **Done, See Code Below**


```r
refinances <- read_excel("sfsnap.xlsx", sheet = "Refinance Data April 2019")
```

Where actually are the purchases and refinances dataframes?


