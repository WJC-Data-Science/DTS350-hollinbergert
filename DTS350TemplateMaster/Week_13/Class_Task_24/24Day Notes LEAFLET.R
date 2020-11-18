#' ---
#' title: "24Day Notes : Leaflet"
#' author: "TomHollinberger"
#' date: "11/17/2020"
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
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_13/Class_Task_23/

#'## Leaflet

# good stuff at https://leafletjs.com/examples

#install.packages("leaflet")
library(leaflet)
library(tidyverse)

#' ## Steps to create a Leaflet map
#   1.  Create a map widget by calling `leaflet()`.
#   2.  Add layers like addTiles, addMarkers, addPolygons.
#addTiles gives you the maps
#Can add additional layers like:
#addMarkers, like map pins
#addLabelOnlyMarkers, the word that displays along with the marker
#addCircles, like impact-radius
#addPopups, on hover info.
#   3.  Repeat step 2 as desired.
#   4.  Print the map widget to display it.



# https://leafletjs.com/examples/choropleth/  shows a map that popsup info on each state when you mouse ovr it.

#' ## Example:
m <- leaflet() %>%
  addTiles() %>%    # Tile without marker gives the whole world map.  Marker without tile gives map pin on blank sheet.
  addMarkers(lng = 174.768, lat = -36.852, popup = "The birthplace of R")  
                    #pop-up shows a label when you mouse click in Viewer in lower right 
                    #Also in viewer, you have zoom (by scroll-wheel) and pan (by click-drag)
m
#  Can use addLabelOnlyMarkers     addLabelOnlyMarkers(data = LargestCity, lat = ~lat, lng = ~lng,  label = ~city_ascii, labelOptions = labelOptions(noHide = T)) 
# With the argument at the end, you get permanenet labels, not hover-on lables.

#' ## Using maps and addPolygons
library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)


#Unlike USAboundaries (Task22 and Case Study 12) With Leaflet you need to provide it a csv with lat, long, and other qualities (name, population, etc.)
#You can create a custom made item to display on the map using GeoJSON   https://leafletjs.com/examples/geojson/

library(readr)
states <- read_csv("states.csv", 
                   col_names = FALSE)

head(states)

#' ##3 Change the headings so it will recognize the latitude and longitude values
statesLatLng <- transmute(states, X1, Lat = X2, Long = X3)

my_states1 <- leaflet(data = statesLatLng) %>%
  addTiles() %>%
  addMarkers()
my_states1

#' ### Assign the latitude and longitude values, and add popups and labels
my_states <- leaflet(data = states) %>%
  addTiles() %>%
  addMarkers(states, lat = ~X2, lng = ~X3, popup = ~X1, label = ~X1)
my_states

#' ### Add a column so we can add colors and circle markers
states2 <- mutate(statesLatLng, quality = case_when
                  (X1 == 'Missouri, USA' ~ 1,
                    X1 == 'Nevada, USA' ~ 2,
                    TRUE ~ 3))

#This is a palette to use in conjunction with numeric data columns like rank of popln.
#be careful about the order of the numbers, it appears to need to be 1,2,3 ascending.
pal <- colorFactor(c("green", "blue","orange"), domain = c(1,2,3))



head(states2)


leaflet(states2) %>% addTiles() %>%
  addCircleMarkers(
    radius = 6,
    color = ~pal(quality),
    stroke = FALSE,
    fillOpacity = 0.5) 

#addTiles gives you the maps
#Can add additional layers like:
#addMarkers, 
#addLabelOnlyMarkers, 
#addCircles, 
#addPopups,


