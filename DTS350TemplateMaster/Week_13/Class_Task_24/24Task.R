#' ---
#' title: "24 Task : Interactive Maps"
#' author: "TomHollinberger"
#' date: "11/17/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    code_folding:  hide
#'    results: 'hide'
#'    message: FALSE
#'    warning: FALSE

#' ---  

#' THIS RSCRIPT USES ROXYGEN CHARACTERS. <br> 
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  <br>
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.<br>
#'
#' _________________________________
#' _________________________________
#' 
#' 
#' #install.packages("leaflet")
library(leaflet)
library(tidyverse)

#' Steps to create a Leaflet map
#   1.  Create a map widget by calling `leaflet()`.
#   2.  Add layers like addTiles, addMarkers, addPolygons.
#   3.  Repeat step 2 as desired.
#   4.  Print the map widget to display it.

library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = "white", stroke = FALSE)


library(readr)
cities <- read_csv("top3uscities.csv", 
                   col_names = TRUE)
head(cities)


Top3inState <- cities %>%
  group_by(state_id) %>%
  filter(row_number(desc(population)) <= 3) %>%
  mutate(population = population/1000)
Top3inState

Top3wRnk <- mutate(Top3inState, rnk = rank(population))   #ranks within state (not sure why it still is grouped by state, but it works.)
head(Top3wRnk)
#View(Top3wRnk)
write_csv(Top3wRnk,"Top3wRnk.csv") 


LargestCity <- Top3inState %>%
  group_by(state_id) %>%
  filter(row_number(desc(population)) == 1)
LargestCity
write_csv(LargestCity,"LargestCity.csv")


pal <- colorFactor(c("light blue", "blue","dark blue"), domain = c(1,2,3))

#'##  **PLOT 1 : Permanent Labels**
#'The map below has the Largest Cities name label permanently displayed, no need to hover.  
#'Note that these cities are different than the original Task 22 largest cities 
#'because of a different data source with a different way of capturing the data (City proper vs SMSA, etc.)
mapStates = map("state", fill = TRUE, plot = FALSE)
mapStates <- leaflet() %>%
addTiles() %>%
  addPolygons(data = mapStates, fillColor = "white", stroke = FALSE) %>%
  addCircleMarkers(data = Top3wRnk,
    radius = 4,
    color = ~pal(rnk),
    stroke = FALSE,
    fillOpacity = .7) %>% 
  addLabelOnlyMarkers(data = LargestCity, lat = ~lat, lng = ~lng,  label = ~city_ascii, labelOptions = labelOptions(noHide = T)) 
  mapStates                  
  

  
#'##  **PLOT 2 : Pop-Up Labels**
#'The map below pops-up the Each States' Largest Cities' name when you hover over it.  St Louis, for example.
mapStates = map("state", fill = TRUE, plot = FALSE)
  mapStates <- leaflet() %>%
    addTiles() %>%
    addPolygons(data = mapStates, fillColor = "white", stroke = FALSE) %>%
    addCircleMarkers(data = Top3wRnk,
                     radius = 6,
                     color = ~pal(rnk),
                     stroke = FALSE,
                     fillOpacity = .7) %>% 
    addLabelOnlyMarkers(data = LargestCity, lat = ~lat, lng = ~lng,  label = ~city_ascii)#, labelOptions = labelOptions(permanent = FALSE)) 
    #addLabelOnlyMarkers(data = LargestCity, lat = ~lat, lng = ~lng,  label = ~city_ascii,labelOptions = labelOptions(noHide = T)) 
  mapStates        


















