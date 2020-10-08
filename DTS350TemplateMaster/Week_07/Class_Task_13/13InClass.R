#' ---
#' title: "13 InClass : Data Format and Tidy"
#' author: "TomHollinberger"
#' date: "10/08/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_07/Class_Task_12/messy_data.xlsx


library(tidyverse)
library(readr)
library(haven)
library(readxl)
library(downloader)
library(dplyr)

#'
#'  Read in two files from GitHub
#'  go to github  rightclick and copy link and paste here
Movie1 <- read_rds(url("https://github.com/WJC-Data-Science/DTS350/raw/master/Boxoffice_Movie_Cost_Revenue.RDS"))
Movie2 <- read_dta("https://github.com/WJC-Data-Science/DTS350/raw/master/Boxoffice_Movie_Cost_Revenue.dta")

all_equal(Movie1, Movie2)  # checek to see if these are values, rows and cols are equal

Movie1Problem <- Movie1 %>%
  filter(row_number() == 170)  # this is the result line from all_equal

Movie2Problem <- Movie2 %>%
  filter(row_number() == 170)

bind_rows(Movie1Problem, Movie2Problem)  #sit them together top and bottom

# Separate the Release.Date
New_Movie2 <- Movie2 %>%
  separate(Release.Date, into = c("Month", "Day", "Year"))   #auto-assumes that / is separater
head(New_Movie2)

# Instead of separating the whole date, just get the year away from the rest of the date.
Year_Movie2 <- Movie2 %>%
  separate(Release.Date, into = c("Month/Day", "Year"), sep = -4)  #position-delimited 4th from end, oull off last 4 digits
#could do char delimiting
head(Year_Movie2)

# Fix values:  Suppose all budgets of 150000000 were reduced to 100000000.
Fix_Movie2 <- Movie2 %>%
  mutate(Production.Budget = replace(Production.Budget, Production.Budget == 150000000, 100000000))
# replacing only 150 with 100...in same column.  Could make new column by chg first argument
head(Fix_Movie2)  
