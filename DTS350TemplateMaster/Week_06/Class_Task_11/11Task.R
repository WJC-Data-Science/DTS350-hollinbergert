#' ---
#' title: "Task 11 World Data Investigations PAert 2"
#' author: "TomHollinberger"
#' date: "10/01/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.

library(tidyverse)
library(ggplot2)
library(dplyr)

summary(diamonds)


#'from 6Task sideways blue to yellow
#'library("ggplot2")
ecodecl <- read.csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_04/Class_Task_06/economic-decline-in-the-second-quarter-of-2020.csv")
head(ecodecl)
str(ecodecl)

#' Create factor / categorical / discrete variables out of Country and GDPQ2
ecodecl$Ctryf <- as.factor(ecodecl$Ctry)
ecodecl$GDPQ2f <- as.factor(ecodecl$GDPQ2)

#' Create the Visualization

ggplot(ecodecl, aes(x = reorder(GDPQ2,Ctry), y = GDPQ2)) +   #dbl-wide problems when value (CAN, MEX)is the same, had to alter the data
  geom_col(aes(fill = GDPQ2f)) +  geom_col(aes(fill = GDPQ2f)) +
  geom_text(aes(label = GDPQ2), nudge_x = 0.15, nudge_y = -1,size = rel(2)) +
  geom_text(aes(label = Ctry), nudge_x = 0.15, nudge_y = -3,size = rel(2)) +
  coord_flip() +
  scale_fill_viridis_d(
    option = "C") +               #plasma C from https://bids.github.io/colormap/ 
  labs(
    title = "Economic decline in the second quarter of 2020",
    subtitle = "The percentage decline of GDP relative to the same quarter in 2019. It is adjusted for inflation.",
    caption = "Source: Eurostat, OECD and individual national statistics agencies
    Note: Data for China is not shown given the earlier timing of its economic downturn.  The country saw positive growth of 3.2% in Q2 preceded by a fall of 6.8% in Q1") +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +    #https://stackoverflow.com/questions/27433798/how-can-i-change-the-y-axis-figures-into-percentages-in-a-barplot
  theme_light() +
  theme(plot.caption = element_text(hjust = 0),   #left-justify the caption (default is right-justified) https://ggplot2.tidyverse.org/reference/theme.html
        axis.title.x = element_blank(),            #deletes the axis titles
        axis.title.y = element_blank(),
        legend.position = "none",                  #deletes the legend
        panel.grid.major.y = element_blank(),       #deletes the horizontal gridlines
        panel.grid.minor.y = element_blank(),
        axis.text.y = element_blank(),             #deletes the y axis ticks and numbers    axis.ticks.y = element_blank())
  )




library(devtools)
newdataset <- ourworldindata::financing_healthcare
newdataset

summary(newdataset)
