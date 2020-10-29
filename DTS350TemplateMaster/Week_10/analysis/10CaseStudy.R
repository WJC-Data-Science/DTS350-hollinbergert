#' ---
#' title: "10 Case Study :  It's About Time"
#' author: "TomHollinberger"
#' date: "10/28/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    code_folding:  hide
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#' sample filepath E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_10/Class_Task_18/data.xlsx


library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)
#' Check working directory
#'getwd() #"C:/Users/tomho/Documents"
#'already set by github   setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_10/analysis")
getwd()


#' Download the csv  go to github and copy the link and paste here...once, then # it out
#download.file("https://github.com/WJC-Data-Science/DTS350/raw/master/sales.csv", "sala.csv", mode = "wb")

#' Open csv in excel and filter each row to see what the column contents are (missing data = 99 for example, etc) .
#' Also look for opening lines to skip, comment flags, column names (header row), etc 
#' name	type	time	amount

#'Now we use the read_csv function to load the data.
sal <- read_csv("sala.csv")
sal    #looks good, all columns came over.
#' Columns are Upper/Lower Case.  cols(Name = col_character(), Type = col_character(), Time = col_datetime(format = ""), Amount = col_double()
 
sala <- sal
#Do unique() for character variables to see what we are dealing with:
unique(sala$Name)
#"Tacontento"    "SplashandDash" "ShortStop"     "LeBelle"       "HotDiggity"    "Frozone"       "Missing"    
unique(sala$Type)
#"Food(prepared)"     "Services"           "Food(pre-packaged)" "Goods"              "Missing"   

#Do Summary of numeric adn date variables to see extent:
summary(sala$Time)
#Min = "2016-04-20 19:01:00",  Max = "2016-07-20 15:53:00"   According to the Problem Stmt, these are MTN time zone.

summary(sala$Amount)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-194.500    2.500    3.000    5.294    4.500 1026.000 

#MISSING DATA or OUTLIERS-- 
#View(sala)  #use this code line then # it out, filter for "Missing" in Name and/or Type columns 
#Note the bottom of the View windows says there are 15,656 total entries.
#Results:
#1Missing	Missing	2016-06-17 21:12:00	150.00
#2Missing	Missing	2016-04-20 19:01:00	-3.07
sala  #15,656 rows
salb <- filter(sala, Name != "Missing")
salb   #15,654 rows, thus removed the 2 Missing Datas

# Also a comeback from first preliminary plot1, which showed an outlier due to an extremely early date:
#find it using View's filter
# HotDiggity	Food(prepared)	2016-04-20 19:01:00	-87.67
salb  #15,654 rows 

salc <- filter(salb, Amount != -87.67)   #couldn't get it to filter on Time == "2016-04-20 19:01:00"
salc  #15,653, thus removed the 1 outlier early date.



#THis is a long-form datafram.  Similar to:
#View(economics_long)

#Rename variables for ease of typing
sald <- salc %>%
rename(nm = Name, ty = Type, time = Time, amount = Amount)
sald

#' Assume the incoming data is in UTC.  It doesn't say so, but is UTC by default.  Convert the times from UTC time to mountain time using the right function out of library(lubridate).
list(OlsonNames())  #see all 600 entries.  Choose "America/Denver" to represent Mountain tz
sale <- sald
sale$time <- ymd_hms(sale$time, tz = "UTC") 
sale$timemtn <- with_tz(sale$time, tz = "America/Denver")  
sale   #now has Mountain time column

# Also a comeback from third preliminary plot (hourly, faceted), which showed approximately 10 MIDNIGHT (MTN TZ) outliers:
#find it using View's filter



#salf <- sale
#salf$hronly <- hour(salf$timemtn) 
#salf   #15,653 rows
#salg <- filter(salf, (hronly != 0))   
#salg   #15,646 rows, thus removed the 7 outlier MIDHIGHT MTN TZ.

#View(salg)

#salh <- salg
#salh   #15,646 rows
#sali <- filter(salh, hour(timemtn) > 3)   
#sali   #still 15,646 rows, thus DID NOT removed the 3 outliers assume dto be at 1AM MTNTIME.



#' Create a new hourly grouping variable using ceiling_date() from library(lubridate).  
salj <- sale
salj$timemtnhr <- ceiling_date(salj$timemtn, "hour")
salj

#' Create a new daily grouping variable using ceiling_date() from library(lubridate).  
salk <- salj
salk$timemtnday <- ceiling_date(salk$timemtn, "day")
salk

#' Aggregate the point of sale data into HOUR sales totals.  HOW TO AGGREGATE : NEED TO SUM the AMOUNT columns
salhrly <- group_by(salk, nm, timemtnhr)
sumsalhrly <- summarise(salhrly, salphr = sum(amount, na.rm = TRUE))
sumsalhrly  #It's here  use this to merge or join 

#' Aggregate the point of sale data into DAILY sales totals.  HOW TO AGGREGATE : NEED TO SUM the AMOUNT columns
saldaly <- group_by(salk, nm, timemtnday)
sumsaldaly <- summarise(saldaly, salpday = sum(amount, na.rm = TRUE))
sumsaldaly  #It's here  use this to merge or join 

#' ### PRELIM PLOT OF HOURLY SALES (hourly across the whole time period)
ggplot(sumsalhrly, aes(timemtnhr, salphr, color = nm)) +
  geom_point() +
  geom_smooth(se = FALSE) +
labs(title = "HOURLY Sales Track", 
     subtitle = "Hourly Sales across the 2-month Period.",
     caption = "Source: github...sales.csv",
     x = "Month, Day, and Hour of Each Day",
     y = "Hourly Sales ($)")  
# There appears/appeared to be one outlying date (in early May), go back to View to filter and it.  Then filter out this outlier.
# Other extremely high or low dollar amopunts are not considered outliers at this point.
ggsave("HourlySales.jpeg")

#' ### **FINAL PLOT** OF DAILY SALES (daily across the whole time period)
ggplot(sumsaldaly, aes(timemtnday, salpday, color = nm)) +
  geom_point() +
  geom_smooth(se = FALSE) +
labs(title = "Daily Sales Track", 
     subtitle = "Daily Sales across the 2-month Period.",
     caption = "Source: github...sales.csv",
     x = "Month and Day",
     y = "Daily Sales ($)")  
#'### **Insight**: Lebelle seems to have a large sales volume, with a recent up-trend.  
#'### **Insight**: All other companies have level or decreasing recent sales volume, which may indicate the waning of a seasonal market.
ggsave("DailySales.jpeg")

#' TYPICAL DAY'S SALES  (hourly sales profile of a typical day)  
#' Pull out only the hour data, and graph by typical hour-of-the-day.  
sumsalhrlyb <- sumsalhrly
sumsalhrlyb
sumsalhrlyb$hronly <- hour(sumsalhrlyb$timemtnhr) 

# View(sumsalhrlyb) it appears/appeared that there are approx 10 MIDNIGHT or 1AM Records = hronly = 0 or 1.
# It would be helpful to change 0 to 24, and 1 to 25, so that they graph on the far right , instead of far left

sumsalhrlyb$hronly <- as.double(sumsalhrlyb$hronly)  

sumsalhrlyc <- mutate(sumsalhrlyb, hronly = case_when(
  hronly == 0 ~ 24,
  hronly == 1 ~ 25,
  TRUE ~ hronly))
unique(sumsalhrlyc$hronly)   #correctly, only 1 thru 24

#' ### **FINAL PLOT** OF TYPICAL DAY'S SALES  (hourly sales profile of a typical day)  
#' Pull out only the hour data, and graph by typical hour-of-the-day.  
ggplot(sumsalhrlyc, aes(hronly, salphr, color = nm)) +
  geom_point() +
  geom_smooth() +
labs(title = "Typical Daily Sales", 
     subtitle = "Average sales for each hour of a typical day.",
     caption = "Source: github...carwash.csv",
     x = "Hour of Typical Day",
     y = "Hourly Sales ($)")  
#'### **Insight**: Looks like HotDiggity has a high peak at NOON, but drops off quickly in the afternoon.
#'### **Insight**: Looks like LeBelle has a 3pm peak and has higher-than-others sales until closing time, which appears to be one hour earlier than the others.  LeBelle may have room to increase their hours of operation to take advantage of this healthy position. 
ggsave("TypDaySales.jpeg")

#' ### **FINAL PLOT** OF TYPICAL DAY'S SALES (FACETED)  (hourly sales profile of a typical day) 
#'Digging further, using facets to distinguish between Companies.
ggplot(sumsalhrlyc, aes(hronly, salphr, color = nm)) +
  geom_point() +
  geom_smooth() +
  facet_wrap("nm") +
  labs(title = "Typical Daily Sales", 
       subtitle = "Average sales for each hour of a typical day.",
       caption = "Source: github...carwash.csv",
       x = "Hour of Typical Day",
       y = "Hourly Sales ($)")  
#' ### **Insight**: It appears that LeBelle has a shorter workday, starting later (9am), and closing sooner (10pm).  Interestingly, it closes as hourly sales are still increasing.  They may be turning away business. LeBelle may have room to increase their hours of operation to take advantage of this situation. 
#' ### **Insight**: SplashandDash has an even shorter workday.  But it closes as hourly sales are waning, which makes sense.  
#' ### **Insight**: LeBelle seems to have a relatively higher variance in sales volume from day to day.
ggsave("TypDaySales-Faceted.jpeg")


#' Look at data in a table
salj
salw <- salj
salw$timemtnyear <- ceiling_date(salw$timemtn, "year")
salw

salwyrly <- group_by(salw, nm, ty)
salwyrly


sumwyrly <- summarise(salwyrly, Annual_Sales_Volume = sum(amount, na.rm = TRUE), Customers_Per_Year = n(), Avg_Sale = mean(amount, na.rm = TRUE))
sumwyrly  

#' ### **Table Insights**:   HotDiggity has the highest overall sales volume for the period.  LeBelle is second place.
#' ### **Table Insights**:   HotDiggity and LeBelle are in different sectors; Food(prepared) and Goods, respectively.  They have dramatically different average sale amount.has the highest ovrall sales volume for the period.  LeBelle is second place. 


#' ### **Overall Insights:** Lebelle seems to have a larger sales volume, with a recent up-trend, and room to increase their hours of operation to take advantage of this healthy position.  All other companies have level or decreasing recent sales volume, which may indicate the waning of a seasonal market.
#' ### **Recommendation:** Approve the loan to LeBelle, inquire about extending hours of operations.  Hold off on approval of other companies' requests until after their seasonal cycle has run its course.
 