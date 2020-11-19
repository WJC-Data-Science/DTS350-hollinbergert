#' ---
#' title: "13 Case Study: Building the Past Using Leaflet"
#' author: "TomHollinberger"
#' date: "11/18/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#'    code_folding:  hide
#'    results: 'hide'
#'    message: FALSE
#'    warning: FALSE
#'    echo: FALSE
#' ---  
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS DONE IN A RSCRIPT.
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_13/analysis/

library(tidyverse)
library(readr)
library(haven)
library(readxl)
library(downloader)
library(dplyr)
library(leaflet)
getwd()


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
#PikeOhio <- filter(permitscsv, state == 39 & county == 131)
#PikeOhio
##CONFIRM   (state and county in csv)  == (statefp and countyfp in USAboundaries)


unique(permitscsv$variable)  #has 6 types of permit aggregations:   "All Permits" "Single Family" "All Multifamily""2-Unit Multifamily""3 & 4-Unit Multifamily" "5+-Unit Multifamily"   
#need to filter for only the "All Permit" data
sfpermits <- filter(permitscsv, variable == "Single Family")
sfpermits    #drops the total rows from 327422 to 87396
unique(permitscsv$StateAbbr)   #still have 51 states
write_csv(sfpermits,"sfpermits.csv")  #check in file explorer to be sure you got what you wanted.


# Check years of coverage
unique(sfpermits$year)    #1980 -- 2010

#Reduce the years of coverage to ONLY 1990 - 2010, because that's the last 'cycle' 
# https://fred.stlouisfed.org/series/HOUST
# 1990 was the last 'local minimum'
sfpermits9010 <- filter(sfpermits, 
               year >= 1990 & year <= 2010)
#view(sfpermits9010)  #confirm years 1990-2010


#Permits : Group by and Summarize by state by year
styr <- sfpermits9010 %>%
  group_by(StateAbbr, year) %>%
  summarise(sumval = sum(value, na.rm = TRUE))

#Scale down the value by dividing by 1000
styr$sumvalk <- styr$sumval / 1000 

styr  # Sum of All Permits by state for each year 1990 thru 2010


#Minimum Housing Permits in whichever year, per state.  Similar to Worst-In-Class
stmin <- styr %>%
  group_by(StateAbbr) %>%
  filter(row_number((sumval)) == 1)
stmin
stmin <- mutate(stmin,
                sfmin = sumvalk,
                yrmin = year)
stmin <-select(stmin,StateAbbr,yrmin,sfmin)
stmin

#2010 Housing Permits, per state. 
st10 <- styr %>%
  group_by(StateAbbr) %>%
  filter(year == 2010)
st10
st10 <- mutate(st10,
                sf10 = sumvalk,
                yr10 = year)
st10 <-select(st10,StateAbbr,yr10,sf10)
st10


#Maximum Housing Permits in whichever year, per state.  Similar to Best-In-Class 
stmax <- styr %>%
  group_by(StateAbbr) %>%
  filter(row_number(desc(sumval)) == 1)
stmax
stmax <- mutate(stmax,
       sfmax = sumvalk,
       yrmax = year)
stmax <-select(stmax,StateAbbr,yrmax,sfmax)
stmax

#Join Min, Max, and 2010 by State
stmax10 <- left_join(stmax,st10, by = "StateAbbr")
stmax10

stmax10min <- left_join(stmax10,stmin, by = "StateAbbr")
stmax10min

#Create a Belowmax variable that shows LOSS, i.e.,  (Max - 2010) / Max
#Create a Above Min variable that shows REBOUND, i.e.,  (2010 - Min) / Min, which will be Zero, if 2010 is the worst year.
#view(stmax10min)

stmax10minab <- mutate(stmax10min,
                         belowmax = (sfmax - sf10) / sfmax,
                         abovemin = -(sfmin - sf10) / sfmin)
stmax10minab
#view(stmax10minab)

#Need to read in the lat & long data, associated with state abbreviation
library(readr)
stateswabbr <- read_csv("stateswabbr.csv", 
                   col_names = FALSE)

head(stateswabbr)

#' Change the headings so it will recognize the latitude and longitude values
getwd()
statesLatLng <- transmute(stateswabbr, StateAbbr = X1, stname = X2, Lat = X3, Long = X4)
statesLatLng

#Join to the Permit MaxMin data
statesmaxmin10abvblwlatlng <- left_join(statesLatLng,stmax10minab, by = "StateAbbr")
statesmaxmin10abvblwlatlng


#These are palettes to use in conjunction with numeric data columns like belowmax.
pal1 <- colorBin("Blues", domain = 0:1)
pal2 <- colorBin("Reds", domain = 0:1)


#' ## PLOT1 : HOUSING BUBBLE (Max vs 2010)
#' ### This map show each state with a blue outter circle whose area equals the maximum number of annual single family permits between 1990 and 2010. 
#' ### 1990 was chosen as a starting point because it is the bottom of the last downturn, based on Federal Reserve data.
#' ### The inner red circle's area equals the 2010 single family permits.  The difference between the blue outter circle and the red inner circle is how far down the 2010 market is from it's highest point.
#' ### The pop-up upon hover shows the percentage drop from Max to 2010 levels, i.e, how much the market shrank.
#' ### The lightness or darkness of the circle is on a sliding scale to portray the percentage of drop (more percentage drop = darker circles).
leaflet(statesmaxmin10abvblwlatlng) %>% addTiles() %>%
    addCircleMarkers(
      radius = ~(sqrt(sfmax/3.14))*2,   #math transformation to make the volume of the circle (not the radius) portray the volume of the market.
      color = ~pal1(belowmax),   
      stroke = FALSE,
      fillOpacity = 0.5) %>%
    addLabelOnlyMarkers(statesmaxmin10abvblwlatlng, lat = ~Lat, lng = ~Long, label = ~belowmax) %>%
  addCircleMarkers(
    radius = ~(sqrt(sf10/3.14))*2,   #math transformation to make the volume of the circle (not the radius) portray the volume of the market.
    color = ~pal2(belowmax),   
    stroke = FALSE,
    fillOpacity = 0.5) %>%
  addLabelOnlyMarkers(statesmaxmin10abvblwlatlng, lat = ~Lat, lng = ~Long, label = ~belowmax) #%>%



# MAPPING EARTHQUAKES
#  https://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php


eqs5 <- read_csv("5eqs.csv", 
                        col_names = TRUE)

head(eqs5)

eqs5 <- mutate(eqs5,
                 labelmsg = (paste0("Magnitude  ", mag, "   Click for more info")),
                 popupmsg = (paste0(place, "   //   ","    Magnitude = ",mag, "   //   ", "   Date/Time = ", time ))
)
eqs5
view(eqs5)


#' Change the headings so it will recognize the latitude and longitude values
#getwd()
#statesLatLng <- transmute(stateswabbr, StateAbbr = X1, stname = X2, Lat = X3, Long = X4)
#statesLatLng

#Join to the Permit MaxMin data
#statesmaxmin10abvblwlatlng <- left_join(statesLatLng,stmax10minab, by = "StateAbbr")
#statesmaxmin10abvblwlatlng


#These are palettes to use in conjunction with numeric data columns like belowmax.
pal1 <- colorBin("Reds", domain = 0:8)
#pal2 <- colorBin("Reds", domain = 0:1)


#' ## PLOT2 : EARTHQUAKES (Greater than 5.0 in the last 30 days)
#' ### This map show each earthquake of magnitude 5.0 or greater, in the last 30 days; i.e., 2020-10-19 -- 2020-11-16.  
#' ### The radius of the circle-marker shows the magnitude on a relative scale.  
#' ### The circles are slightly transparent, so you can see and appreciate the build-up of successive earthquakes in the same/nearby location.
#' ### The pop-up upon hover gives the magnitude of the quake, and an offer to click for more information.
#' ### When the pop-up is clicked, the label provides the location, the magnitude, and the date/time of the quake.
#' ### This interactive map is particularly interesting when you zoom in to see swarms of earthquakes in the same locale.
p <- leaflet(eqs5) %>% 
  addTiles() %>%
  addMarkers(eqs5, lat = ~lat, lng = ~lng, popup = ~popupmsg, label = ~labelmsg) %>%   #label is a hover-over, and pop-up requires a click-on
  addCircleMarkers(eqs5, lat = ~lat, lng = ~lng,
    radius = ~(sqrt((mag-4.99)/3.14))*50,   #math transformation to make the volume of the circle (not the radius) portray the volume of the market.
    color = ~pal1(mag),   
    stroke = FALSE,
    fillOpacity = 0.5) 
p


