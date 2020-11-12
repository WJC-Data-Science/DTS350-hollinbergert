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
sfpermits <- filter(permitscsv, variable == "Single Family")
sfpermits    #drops the total rows from 327422 to 87396
unique(permitscsv$StateAbbr)   #still have 51 states
write_csv(sfpermits,"sfpermits.csv")  #check in file explorer to be sure you got what you wanted.


# Check years of coverage
unique(sfpermits$year)    #1980 -- 2010

#Permits : Group by and Summarize by state by year
styr <- sfpermits %>%
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
#' ### **PLOT 1 INSIGHT** : State-by-State Permits Issued, 1980 to 2010.  
#' The time window is important because it shows the 2008 crash, and also reaches back to the Recession of 1981, 
#' when the housing market had a similar downturn.  The obvious worst-case situations are CA, TX, and FL, 
#' but they have such large values, they stretch the y-axis and dwarf the other states. The next chart zooms in on these other states.
#' These charts use the GEOFACET package which provides a visual arrangement of states on a map, but also allows charted data to be displayed for each state.  It's a useful compromise between numeric charts and geographic maps.
ggplot(styr, aes(year,sumvalk)) +
  geom_line() + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Single Family Housing Permits per Year (Thousands)") +
  xlab("Year") +
  labs(title = "Single Family Housing Permits by State by Year (All States & DC)")
ggsave("geofacet all states.png")  


#Graph without CA, TX, or FL because their values stretch the y-axis and dwarf the other states. 
library(geofacet)  #install.packages("geofacet")
#' ### **PLOT 2 INSIGHT** : State-by-State Permits Issued, 1980 to 2010, without CA, TX, or FL
#' This plot shows the same data, except that  CA, TX, or FL have been excluded because their high values stretch the y-axis and dwarf the other states.  Now, with a more 'zoomed-in' y axis, 
#' you can see similar 'crash' trends in some states, but not others. 
#' It's hard to discern a pattern.  Perhaps coastal (AZ, NV, GA, NC, VA), but also more populated Midwest states (OH, MI, IL, MN, CO)
#' 
#'     According to https://www.thestreet.com/personal-finance/savings/the-five-states-hit-hardest-by-foreclosures-10414898
#' the top 5 hardest hit states (measured by foreclosures) were Nevada, California, Florida, Colorado, and Arizona.  
ggplot(styrwoCATXFL, aes(year,sumvalk)) +
    geom_line() + 
    facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
    scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
    ylab("Single Family Housing Permits per Year (Thousands)") +
    xlab("Year") +
    labs(title = "Single Family Housing Permits by State by Year (excluding CA, TX, and FL for scaling purposes)")
ggsave("geofacet woCATXFL.png") 
  


#Create a percent change variable.  (new - old) / old

styr <- mutate(styr, pctchg = (sumvalk - lag(sumvalk))/lag(sumvalk))
styr

ggplot(styr, aes(year,pctchg)) +
  geom_line() + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Percent Change in Single Family Housing Permits (Year-on-Year)") +
  xlab("Year") +
  labs(title = "Single Family Housing Permits by State by Year (All States & DC)")
ggsave("geofacet all states pctchg.png") 

#Remove DC as outlier
styrpctchgwoDC <- filter(styr, StateAbbr != "DC")
unique(styrpctchgwoDC$StateAbbr)

ggplot(styrpctchgwoDC, aes(year,pctchg)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_line() + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Percent Change in Single Family Housing Permits (Year-on-Year)") +
  xlab("Year") +
  labs(title = "Single Family Housing Permits by State, Percentage Change (Year-on-Year) (All States, not DC)")

ggsave("geofacet all states wo DC pctchg.png") 

#Narrow to 2006 - 2010
styrpctchgwoDC0610 <- filter(styrpctchgwoDC, year >= 2006 & year <= 2010)
unique(styrpctchgwoDC0610$year)

#' ### **PLOT 3 INSIGHT** : State-by-State, Percentage Change, 2006 thru 2010.
#' This is a more stylized plot.  The red horizontal line is Zero growth or decline.  The Blue vertical line is 2008.
#' The black lines are bolded for quick visual lock-in.  Interesting are the late dip in NY.  Another takeaway is that almost all states had 
#' stopped the decline in permits issuances by 2010, and some had even increased permit issuances.
ggplot(styrpctchgwoDC0610, aes(year,pctchg)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_vline(xintercept = 2008, color = "blue") +
  geom_line(size = 1.5) + 
  facet_geo(~ StateAbbr, grid = "us_state_grid2") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Percent Change in Single Family Housing Permits (Year-on-Year)") +
  xlab("Year") +
  labs(title = "Single Family Housing Permits by State, Percentage Change (Year-on-Year) (All States, not DC)")





#' ###Across Your State" i.e., Missouri, assume by county





unique(permitscsv$variable)  #has 6 types of permit aggregations:   "All Permits" "Single Family" "All Multifamily""2-Unit Multifamily""3 & 4-Unit Multifamily" "5+-Unit Multifamily"   
#need to filter for only the "All Permit" data
permitscsv
mosfpermits <- filter(permitscsv, variable == "Single Family" & StateAbbr == "MO")
mosfpermits    #drops the total rows from 327422 to 3048

unique(mosfpermits$StateAbbr)   #only MO
unique(mosfpermits$variable)   #only Single Family
unique(mosfpermits$countyname)  #112 counties  
# need to cut the word "county" off of the end because the USAboundary grid uses a variable called 'name' which only has 'Adair', without the word 'county'
mosfpermits$name <- str_sub(mosfpermits$countyname, 1, -8)
mosfpermits$name
mosfpermits

               
write_csv(mosfpermits,"mosfpermits.csv")  #check in file explorer to be sure you got what you wanted.

# Check years of coverage
unique(mosfpermits$year)    #1980 -- 2010

#Permits : Group by and Summarize by county by year
mocyyr <- mosfpermits %>%
  group_by(countyname, year) %>%
  summarise(sumval = sum(value, na.rm = TRUE))

unique(mocyyr$countyname)  #112 counties  
# need to cut the word "county" off of the end because the USAboundary grid uses a variable called 'name' which only has 'Adair', without the word 'county'
mocyyr$name <- str_sub(mocyyr$countyname, 1, -8)
mocyyr$name
mocyyr

#also need to correct for typo differences between county names in USABoundaries and us_mo_counties_grid1
mocyyr2 <- mocyyr %>%
 mutate(
   name = case_when(
      name == "St. Lou" ~ "St Louis City",
      name == "St. Louis" ~ "St Louis",
      name == "DeKalb" ~ "Dekalb",
      name == "St. Francois" ~ "St Francois",
      name == "St. Charles" ~ "St Charles",
      name == "St. Clair" ~ "St Clair",
      TRUE ~ name,
    )
 )


#Create a percent change variable
mocyyr2 <- mutate(mocyyr2, pctchg = (sumval - lag(sumval))/lag(sumval))
mocyyr2   #  Sum of All Permits by state for each year 1980 thru 2010

# narrow date window to 2006 - 2010
mocyyr0610 <- filter(mocyyr2, year >= 2006 & year <= 2010)
unique(mocyyr0610$year)

#display as table
library(DT)
datatable(mocyyr0610)


library(geofacet)   #install.packages("geofacet")

#  https://github.com/hafen/geofacet/issues/152
#  https://cran.r-project.org/web/packages/geofacet/geofacet.pdf
#  us_mo_counties_grid1

#' ### **PLOT 4 INSIGHT** : Missouri Counties, Permits Issued, 2006 thru 2010.
#' **This chart looks much better as a jpeg**
#' Several geographic hot spots for decline in permit issuances:  
#' Jackson County (KCMO), the St. Louis area (St. Louis City and Coiunty, Jefferson, Franklin, Warren, and St. Charles)
#' and also near Branson and Lake of the Ozarks (Greene and Christian counties). 
ggplot(mocyyr0610, aes(year,sumval)) +
  geom_line() + 
  facet_geo(~ name, grid = "us_mo_counties_grid1") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Single Family Housing Permits per Year") +
  xlab("Year") +
  labs(title = "MISSOURI Single Family Housing Permits by County by Year") 
# In Rstudio, this looks unreadable, but saving as a png with the right dimensions, it becomes very useful.
ggsave("geofacet MO.png", height = 10, width = 7, units = "in")  


#' ### **PLOT 5 INSIGHT** : Missouri Counties, Percentage Change, 2006 thru 2010.  
#' **This chart also looks much better as a jpeg**
#' Similar to the national profile, most counties bounced back into positive growth territory by 2010.


ggplot(mocyyr0610, aes(year,pctchg)) +
  geom_hline(yintercept = 0, color = "red") +
  geom_vline(xintercept = 2008, color = "blue") +
  geom_line(size = 1.5) + 
  coord_cartesian(ylim = c(-1, 1)) +
  facet_geo(~ name, grid = "us_mo_counties_grid1") + 
  scale_x_continuous(labels = function(x) paste0("'", substr(x,3,4))) + 
  ylab("Percent Change in Single Family Housing Permits (Year-on-Year)") +
  xlab("Year") +
  labs(title = "MISSOURI Single Family Housing Permits by State, Percentage Change (Year-on-Year)")
# In Rstudio, this looks unreadable, but saving as a png with the right dimensions, it becomes very useful.
ggsave("geofacet MO pct lim.png", height = 10, width = 7, units = "in")  
