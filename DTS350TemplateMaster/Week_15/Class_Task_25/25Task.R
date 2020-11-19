#' ---
#' title: "25Task: Animated Maps"
#' author: "TomHollinberger"
#' date: "11/19/2020"
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


# Get data:
library(gapminder)
library(ggplot2)
library(gganimate)
library(gifski) # for gif output
library(USAboundaries)
library(dplyr)
library(sf)
#install(rnaturalearth)
#install(rnaturalearthdata)
library(rnaturalearth)
library(rnaturalearthdata)
library(maps)



#Earthquakes  Magnitude 5 or greater, occurring in the last 30 days (2020-10-19 -- 2020-11-16)
# from https://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php

getwd()
library(readr)
eqs5 <- read_csv("5eqs.csv",                #requires library(readr)
                 col_names = TRUE)

head(eqs5)
tail(eqs5)




#World Map    This works
world_map_data <- ne_countries(scale = "medium", returnclass = "sf")
world_map <- map('world', fill = TRUE, plot = FALSE) %>% st_as_sf()

ggplot() +
  geom_sf(data = world_map, fill = NA) +
  theme_bw() 


#Earthquake Pops  This works
ggplot(eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
  geom_point() +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
  enter_fade() +
  exit_fade() +
  ease_aes('sine-in-out') +
  shadow_mark(alpha = .3) +
  guides(colour = FALSE)


# Can't get the world map and the earthquake pops to coexist on the same ggplot
ggplot() +
  geom_sf(data = world_map, aes(fill = NA)) +
  geom_point(eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
  enter_fade() +
  exit_fade() +
  ease_aes('sine-in-out') +
  shadow_mark(alpha = .3) +
  guides(colour = FALSE)

