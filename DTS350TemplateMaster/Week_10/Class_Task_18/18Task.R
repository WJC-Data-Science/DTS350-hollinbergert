#' ---
#' title: "18Task :  Does Weather Hurt My Bottomline?"
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
#'alerady set by github   setwd("350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_10/Class_Task_18/")
getwd()


#' Download the csv  go to github and copy the link and paste here...
#download.file("https://github.com/WJC-Data-Science/DTS350/raw/master/carwash.csv", "cw.csv", mode = "wb")

#' Open csv in excel and filter each row to see what the column contents are (missing data = 99 for example, etc) .
#' Also look for opening lines to skip, comment flags, column names (header row), etc 
#' name	type	time	amount

#'Now we use the read_csv function to load the data.
cw <- read_csv("cw.csv")
cw    #looks good, all columns came over.
#' cols(name = col_character(), type = col_character(), time = col_datetime(format = ""), amount = col_double()
#' says name (char) = splashanddash only.  type (char) = services only,   
str(cw)   

cwta <- select(cw, time, amount) 
cwta

#' Convert the times from UTC time to mountain time using the right function out of library(lubridate).
list(OlsonNames())  #see all 600 entries.  Choose "America/Denver" to represent Mountain tz
cwtb <- cwta
cwtb
cwtb$time <- ymd_hms(cwtb$time, tz = "UTC") 
cwtb$timemtn <- with_tz(cwtb$time, tz = "America/Denver")  
cwtb   #now has Mountain time column

#' Create a new hourly grouping variable using ceiling_date() from library(lubridate).  Aggregate the point of sale data into hour sales totals
cwtc <- cwtb
cwtc$timemtnhr <- ceiling_date(cwtb$timemtn, "hour")
cwtc

#' Aggregate the point of sale data into hour sales totals.  HOW TO AGGREGATE : NEED TO SUM the AMOUNT columns
cwhrly <- group_by(cwtc, timemtnhr)
cwsalhrly <- summarise(cwhrly, salphr = sum(amount, na.rm = TRUE))
cwsalhrly  #It's here  use this to merge or join to tmpc

#' ### PRELIM PLOT OF SALES (hourly across the whole time period)
ggplot(cwsalhrly, aes(timemtnhr, salphr)) +
  geom_point() +
  geom_smooth()



cwsalhrlyb <- cwsalhrly
cwsalhrlyb
cwsalhrlyb$hronly <- hour(cwsalhrlyb$timemtnhr) 
cwsalhrlyb
#' ### PRELIM PLOT OF TYPICAL DAY'S SALES  (hourly sales profile of a typical day)  
#' Pull out only the hour data, and graph by typical hour-of-the-day.  
ggplot(cwsalhrlyb, aes(hronly, salphr)) +
  geom_point() +
  geom_smooth()

#' Use riem_measures(station = "RXE",  date_start  = ,  date_end  =  ) for station RXE from library(riem) 
#' to get the matching temperatures.
#' Create a new hourly variable that matches your car wash hourly variable.
#' install riem
library(riem)
summary(cwtc$timemtnhr)  
#to find date window : min and max to be
#used as date_start adn date_end in the following riem_measures statement.
#  Min = 2016-05-13   Max = 2016-07-18
min(cwtc$timemtnhr)
max(cwtc$timemtnhr)

tmpa <- riem_measures(station = "RXE",  date_start  = "2016-05-13",  date_end  = "2016-07-18")
tmpa   #"valid" is the date variable (dttm).  It's in UTC.  tmpf is the temperature variable, it is a dbl
tmpa <- select(tmpa, valid, tmpf)
tmpa
unique(tmpa$tmpf)  #has some NA's
tmpa <- filter(tmpa, !is.na(tmpf))
unique(tmpa$tmpf)  #OK, NA is gone

#' Convert the times from UTC time to mountain time using the right function out of library(lubridate).
tmpb <- tmpa
tmpb
tmpb$time <- ymd_hms(tmpb$valid, tz = "UTC") 
tmpb$timemtn <- with_tz(tmpb$time, tz = "America/Denver")  
tmpb$timemtn   #now has Mountain time column

#' Create a new hourly grouping variable using ceiling_date() from library(lubridate).  
#' Aggregate the TEMPERATURE data into average-for-that-day&hour
tmpc <- tmpb
tmpc$timemtnhr <- ceiling_date(tmpb$timemtn, "hour")
tmpc

tmphrly <- group_by(tmpc, timemtnhr)
tmpavhr <- summarise(tmphrly, avhrtmp = mean(tmpf, na.rm = TRUE))
tmpavhr  #It's here  use this to merge or join to cwsalhrlyb


#' Aggregate the temperature data into hourly totals (average). 
#' Inspect original data with View
#View(tmpa)  #two or three readings per hour
#View(tmpb)
#View(tmpc)   #  for example 2016-06-06 20:00:00  several readings in that hour

#' ### PRELIM PLOT OF TEMPS (hourly across the whole time period)
ggplot(tmpavhr, aes(timemtnhr, avhrtmp)) +
  geom_line() +
  geom_smooth()


tmpd <- tmpc
tmpd 
tmpd$hronly <- hour(tmpd$timemtnhr) 
tmpd
#' ### PRELIM PLOT OF TYPICAL DAY'S TEMPs (hourly temperature profile of a typical day)  
#' Pull out only the hour data, and group by typical hour across all days.
tmpd %>%
  count(hronly) %>%
  ggplot(aes(hronly, n)) +
  geom_line() +
  geom_smooth()


#' Now Join hourly sales totals to hourly average temps, by mountain-time-hour 
timeandtemp <- left_join(cwsalhrlyb, tmpavhr, by = "timemtnhr")
timeandtemp

#' ### **FINAL PLOT : Hourly Sales Total, and Hourly Avg Temps** (hourly across the whole 2-month time period).
ggplot(timeandtemp) +
  geom_line(aes(timemtnhr, avhrtmp), color = "red") +
  geom_smooth(aes(timemtnhr, avhrtmp), color = "red") +
  geom_line(aes(timemtnhr, salphr), color = "green") +
  geom_smooth(aes(timemtnhr, salphr), color = "green") +
  labs(title = "The Effect of AVERAGE Temperature on HOURLY Sales", 
       subtitle = "Average hourly temperatures vs Each Hour's sales.",
       caption = "Source: github...carwash.csv",
       x = "Month, Day, and Hour of Each Day",
       y = "Avg Temp (in Red) or Hourly Sales (in Green)")  
#'### **Results : No Discernable Relationship** between Sales and Temperature across the whole 2-month time period.
ggsave("EachHour.jpeg")

#'
#'TYPICAL HOUR OF THE DAY -- Now groupby and summarize by typical hour.


tnthr <- group_by(timeandtemp, hronly)
tnttypphr <- summarise(tnthr, typtmpphr = mean(avhrtmp, na.rm = TRUE), typsalphr = mean(salphr, na.rm = TRUE))
tnttypphr  
#' ### **FINAL PLOT : Typical Avg Hourly Temps vs Typical Hour-of-the-Day Sales, for Typical Hours of the Day.**
#'from ggplot Top 50, time series plots, wide format, data in multiple columns.
ggplot(tnttypphr, aes(x=hronly)) + 
  geom_line(aes(y=typsalphr, col="Typical Hour's Sales")) + 
  geom_smooth(aes(hronly, typsalphr), color = "green") +
  geom_line(aes(y=typtmpphr, col="Average Hourly Temperature")) + 
  geom_smooth(aes(hronly, typtmpphr), color = "red") +
  labs(title = "In a TYPICAL HOUR of the Day:   \n   The Effect of TYPICAL Temperature on TYPICAL Sales", 
       subtitle = "Typical average hourly temperatures vs typical hour's sales.",
       caption = "Source: github...carwash.csv",
       x = "Typical Hour of the Day",
       y = "Avg Hrly Temp (F) or Hourly Sales ($)") + 
  scale_color_manual(name="", 
                     values = c("Typical Hour's Sales"="#00ba38", "Average Hourly Temperature"="#f8766d")) +  # line color
  theme(panel.grid.minor = element_blank(), legend.position = "bottom")  # turn off minor grid, put legend on bottom, horizontally
#'### **Results : No Discernable Relationship** between Sales and Temperature in the typical hour of a typical day.
#'### Sales appear to be **more related to people's activity patterns** (lunch hour, end-of-workday).

ggsave("TypicalHour.jpeg") 


