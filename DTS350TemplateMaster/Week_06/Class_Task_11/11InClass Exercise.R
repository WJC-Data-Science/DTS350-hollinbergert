#' ---
#' title: "Day 11 In Class : Labeling, Histogram, Case_when"
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


library(ggplot2)
library(dplyr)
library(hexbin)

summary(faithful)


#'
#' ### Plot 1 Old Faithful Histogram ,  ala Textbook Section 7.3.2
#' 
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
geom_histogram(binwidth = 0.25, color = "white") +
  labs(
    x = "Duration of Eruption (minutes)",
    y = "Number of Observations"
    ) +
  theme_bw()
  

#'
#' ### Plot 2 Old Faithful Case_when 2-Bracket Histogram ,  ala Textbook Section 7.3.2 and Case_when from 7.4
#' 

faithfulwbrackets <- faithful %>%
  mutate(
  brkts = case_when(
    waiting < 67 ~ "<67",
    waiting >= 67 ~ ">=67"
    )
  )
faithfulwbrackets



listofcolors <- c("green","blue")  #assigns these alphabetically to the brkts

ggplot(data = faithfulwbrackets, mapping = aes(x = eruptions, fill = brkts, color = "white")) + 
  geom_histogram(binwidth = 0.12, color = "white") +
  labs(
    x = "Duration of Eruption (minutes)",
    y = "Number of Observations"
  ) +
  scale_fill_discrete(name = "Duration of Wait") +
#  scale_fill_brewer(palette = "Set1") +      
scale_fill_manual(values = listofcolors) +
theme_bw() +
theme(legend.position="bottom")   



#'
#'
#'
#' ### Plot 3 Old Faithful Hexbin ,  ala Textbook Section 7.5.3
# install.packages("hexbin")
ggplot(data = faithful) +
  geom_hex(mapping = aes(x = eruptions, y = waiting)) +
  labs(
    x = "Duration of Eruption (minutes)",
    y = "Time between eruptions (minutes)",
    fill = "Number of observations"   #this changes the legend's title
  )
