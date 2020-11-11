#' ---
#' title: "12 Case Study: Building the Past"
#' author: "TomHollinberger"
#' date: "11/10/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#'    code_folding:  hide
#'    results: 'hide'
#'    message: FALSE
#'    warning: FALSE
#' ---  
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_12/analysis/

library(tidyverse)
library(readr)
library(haven)
library(readxl)
library(downloader)
library(dplyr)


##GET PERMIT DATA
tmpcsv <- tempfile()
tmpcsv
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/permits.csv",tmpcsv, mode = "wb")
permitscsv <- read_csv(tmpcsv)
#View(permitscsv)  
summary(permitscsv)
unique(permitscsv$StateAbbr) #DOES HAVE AK, HI, & DC.  DOESNOT HAVE PR.  AK sorts after AL?
str(permitscsv)

#Test Pike County Ohio    In USA Boundaries  county fp = 131, statefp = 39
PikeOhio <- filter(permitscsv, state == 39 & county == 131)
PikeOhio
##CONFIRM   (state and county in csv)  == (statefp and countyfp in USAboundaries)

unique(permitscsv$variable)  #has 6 types of permit aggregations:   "All Permits" "Single Family" "All Multifamily""2-Unit Multifamily""3 & 4-Unit Multifamily" "5+-Unit Multifamily"   
#need to filter for only the "All Permit" data
allpermits <- filter(permitscsv, variable == "All Permits")
allpermits    #drops the total rows from 327422 to 87396
unique(permitscsv$StateAbbr)   #still have 51 states
write_csv(allpermits,"allpermits.csv")  #check in file explorer to be sure you got what you wanted.


# Check years of coverage
unique(allpermits$year)    #1980 -- 2010

#Permits : Group by and Summarize by state by year
styr <- allpermits %>%
  group_by(StateAbbr, year) %>%
  summarise(sumval = sum(value, na.rm = TRUE))

#Scale down the value by dividing by 1000
styr$sumvalk <- styr$sumval / 1000 

styr  # Sum of All Permits by state for each year 1980 thru 2010


#Now exclude CA, TX, and FL beacuse they are soo big, they stretch the y-scale and dwarf the other states.
styrwoCATXFL <- filter(styr, !StateAbbr %in% c("CA", "TX", "FL"))

str(styrwoCATXFL)


unique(styr$StateAbbr)   #51 states
unique(styrwoCATXFL$StateAbbr)  #48 states excluding CA, TX, FL


library(geofacet)   #install.packages("geofacet")
# All States, and DC
#' ### **PLOT 1 INSIGHT** : This plot shows housing permits from 1980 to 2010 in all states.  
#' The time window is important because it shows the 2008 crash, and also reaches back to the Recession of 1981, 
#' when the housing market had a similar downturn.  The obvious worst-case situations are CA, TX, and FL, 
#' but they have such large values, they stretch the y-axis and dwarf the other states.  
#' The next chart zooms in on these other states.
#' These charts use the GEOFACET package which provides a visual arrangement of states on a map, but also allows charted data to be displayed for each state.  
#' It's a useful compromise between numeric charts and geographic maps.
ggplot(styr, aes(year,sumvalk)) +
  geom_line() + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Housing Permits per Year (Thousands)") +
  xlab("Year") +
  labs(title = "Housing Permits by State by Year (All States & DC)")
ggsave("geofacet all states.png")  


#Graph without CA, TX, or FL because their values stretch the y-axis and dwarf the other states. 
  library(geofacet)  #install.packages("geofacet")
#' ### **PLOT 2 INSIGHT** : This plot shows the same data, except that  CA, TX, or FL have been excluded
#' because their high values stretch the y-axis and dwarf the other states.  Now, with a more 'zoomed-in' y axis, 
#' you can see similar 'crash' trends in some states, but not others. 
#' It's hard to discern a pattern.  Perhaps coastal (AZ, NV, GA, NC, VA), but also more populated Midwest states (OH, MI, IL, MN, CO)
#'    According to https://www.thestreet.com/personal-finance/savings/the-five-states-hit-hardest-by-foreclosures-10414898
#' the top 5 hardest hit states (measured by foreclosures) were Nevada, California, Florida, Colorado, and Arizona.  
ggplot(styrwoCATXFL, aes(year,sumvalk)) +
    geom_line() + 
    facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
    scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
    ylab("Housing Permits per Year (Thousands)") +
    xlab("Year") +
    labs(title = "Housing Permits by State by Year (excluding CA, TX, and FL for scaling purposes)")
ggsave("geofacet woCATXFL.png") 
  
