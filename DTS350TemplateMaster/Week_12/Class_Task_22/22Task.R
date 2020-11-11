#' ---
#' title: "22 Task : Spatial Data & Measurement Data"
#' author: "TomHollinberger"
#' date: "11/11/2020"
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
#' 
#'   https://dcl-2017-04.github.io/curriculum/
#'   
#'Spatial Data in R
#'Spatial packages

install.packages("sf")
install.packages("devtools")
devtools::install_github("tidyverse/ggplot2")
devtools::install_github("ropensci/USAboundaries")
#devtools::install_github("ropensci/USAboundariesData")


#'Loading data
library(tidyverse)
library(sf)
library(USAboundaries)
library(ggrepel)
library(ggplot2)
library(maps)


#'USAboundaries
install.packages("USAboundaries")
library(USAboundaries)
states1 <- us_states()
cities <- us_cities()  
#head(cities)

lower48states <- states1 %>%
  filter(state_abbr != "AK", state_abbr != "HI", state_abbr != "PR", state_abbr != "DC")
lower48states

#View (lower48states)

Top3inState <- cities %>%
  group_by(state_abbr) %>%
  filter(row_number(desc(population)) <= 3, state_abbr != "AK", state_abbr != "HI", state_abbr != "PR", state_abbr != "DC") %>%
  mutate(population = population/1000)
Top3inState

Top3wRnk <- mutate(Top3inState, rnk = rank(population))   #ranks within state (not sure why it still is grouped by state, but it works.)
#View(Top3wRnk)

LargestCity <- cities %>%
  group_by(state_abbr) %>%
  filter(row_number(desc(population)) == 1, state_abbr != "AK", state_abbr != "HI", state_abbr != "PR", state_abbr != "DC")
LargestCity

#View(Top3inState)

#Idaho County Outlines
id_counties <- us_counties(states = "ID")
ggplot(data = id_counties) +
  geom_sf(fill = NA) +
  labs(title = "Idaho Counties") +
  theme_bw()


ggplot() +
  geom_sf(data = lower48states, fill = NA) +    #layer order is important, back layer goes first
  geom_sf(data = id_counties, fill = NA) +  
  geom_sf(data = Top3wRnk, (aes(alpha = rnk, size = population)), color = "blue") +
  ggrepel::geom_label_repel(
    data = LargestCity, 
    aes(label = city, geometry = geometry),
    stat = "sf_coordinates",
    min.segment.length = 0,
    size = 2
  ) +
  scale_size_continuous("Population \n (1,000)") +  
  theme_bw() +
  labs(
    x = element_blank(),
    y = element_blank()) +
    guides(alpha = FALSE)


ggsave("Task22Plot.png", width = 8, unit = "in")





















