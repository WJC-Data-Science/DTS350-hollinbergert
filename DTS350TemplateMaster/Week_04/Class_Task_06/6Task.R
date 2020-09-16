#' ---
#' title: "Task 6: World Data Investigation"
#' author: "TomHollinberger"
#' date: "9/15/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'
#' _________________________________
#'

#'# **Recreating a World in Data graphic**
#' Downloaded to laptop repo from https://ourworldindata.org/covid-health-economy
#' Did a little clean up of the csv file in excel (removed China, EU, NAFTA, OECD rows which are in the file but not in the graphic)
#' Read in the data and investigate the structure.
library("ggplot2")
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


#'## Data Visualization from **Our World in Data**
#'
library(dplyr)
library(tidyverse) 
installed.packages("devtools")
installed.packages("rtools")
library("devtools")
library("ggplot2")
#'library("rtools") <br>
#' Read in the data and investigate the structure.  ONLY NEED TO DO THIS ONCE, then it's in <br>
#' devtools::install_github("drsimonj/ourworldindata") 
cm <- ourworldindata::child_mortality   # as you are typing this line, you get popups for OurWorldInData, and ChildMortality
str(cm)
#'?child_mortality <br>
#'view(cm)
#'
#'## A Two-Line Plot that show year-by-year the change of Child Survival_per_Woman and Death_per_Woman in Afghanistan
#'
cm1 <- select(cm, year, country, deaths_per_woman, survival_per_woman) 
head(cm1)
  
cm2 <- filter(cm1, cm$year >= "1980" & cm$year <= "2014") 

cm3 <- filter(cm2, country == "Afghanistan")
head(cm3)
tail(cm3)

ggplot(cm3) +
  geom_smooth(aes(x = year, y = deaths_per_woman, col = "Deaths"))  +
  geom_smooth(aes(x = year, y = survival_per_woman, col = "Survivals")) +
  labs(
    title = "Afghanistan Child Mortality",
    subtitle = "The Number of Child Survivals and Deaths per Woman in AFGHANISTAN, 1980 - 2013.",
    caption = "Sourced from drsimonj , Our World in Data , Child_Mortality") + 
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_light() +
  theme(plot.caption = element_text(hjust = 0),   #left-justify the caption (default is right-justified) https://ggplot2.tidyverse.org/reference/theme.html
        axis.title.x = element_blank(),            #deletes the axis titles
        axis.title.y = element_blank(),
        legend.title = element_text("Children per Woman"))  #Can't get this to work.  Can't figure out where legend title COLOUR comes from.

#'
#'### INTERPRETATION:  Interestingly, the survival per woman numbers have gone down, AND the deaths per woman have also gone down.  What's probably happening in Afghanistan is the typical developing country scenario where family sizes are going down, thus fewer children to "survive".  And the health conditions are improving so the deaths per woman are going down, too.
#'
#'