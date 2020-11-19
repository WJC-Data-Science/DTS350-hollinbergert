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




#World Map    This did work, and now it doesn't : FRUSTRATING!   And no error message.
world_map_data <- ne_countries(scale = "medium", returnclass = "sf")
world_map <- map('world', fill = TRUE, plot = FALSE) %>% st_as_sf()

#ggplot() +
#  geom_sf(data = world_map, fill = NA) +
#  theme_bw() 


#Earthquake Pops  This works
#ggplot(eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
#  geom_point() +
#  theme_bw() +
  # gganimate specific bits:
#  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
#  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
#  enter_fade() +
#  exit_fade() +
#  ease_aes('sine-in-out') +
#  shadow_mark(alpha = .3) +
#  guides(colour = FALSE)


#'## PLOT1 : EARTHQUAKES AROUND THE WORLD LAST MONTH
#'### This animated plot shows 124 earthquakes popping around the world in the last 30 days.
#'### The size of the circles are relative to the magnitude of the earthquake.
#'### The circles are somewhat transparent so you can see the build-up of successive earthquakes in the same local.
#'### The animation uses transition_time, which aparently can't be slowed down.  But animates in sequence according to the time of occurrence 
#'### It is sort of possible to see spatial patterns in the sequencing of the earthquakes.  For example, you can see a sequence of successive quakes going up and down the island chains north of Australia.  

ggplot() +
  geom_sf(data = world_map, fill = NA) +
  geom_point(data = eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
  enter_fade() +
  exit_fade() +
  ease_aes('sine-in-out') +
  shadow_mark(alpha = .3) +
  guides(colour = FALSE)

