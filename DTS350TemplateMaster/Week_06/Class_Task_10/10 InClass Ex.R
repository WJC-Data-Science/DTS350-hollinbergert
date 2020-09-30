#' ---
#' title: "Task 10 / Day 10 In Class : Labeling"
#' author: "TomHollinberger"
#' date: "9/29/2020"
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
library(nycflights13)

#'____________
#'____________
#' ### Exercise 1: Look at the Data:  Top 10, Bottom 10, Row count, ID columns with NA's 

head(flights,10)  # see the first 10 rows of data
tail(flights,10)  # see the last 10 rows of data
str(flights)   #there are 336,776 rows of data 
colnames(flights)[ apply(flights, 2, anyNA) ]    # there are 6 columns with NAs.  List COLUMNS with missing data, from https://stackoverflow.com/questions/20364450/find-names-of-columns-which-contain-missing-values

#'
#'Create the charts

fl_bp <- flights %>%
  ggplot(aes(x = carrier, y = dep_delay))
fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay))


#'
#'____________
#'____________
#' ### Exercise 2:  Create clean labels for the x and y axes using labs() so that we have the following plots.
#' Book Section 28.2 (pg 28.5)


fl_bp <- flights %>%
  ggplot(aes(x = carrier, y = dep_delay))
fl_bp + geom_boxplot() +
  labs(
    x = "Carrier Abbreviation",
    y = "Departure Delay (minutes)",
    title = "Departure Delays Boxplots by Carrier"
  )



fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay))
fl_sc + geom_point() +
labs(
  x = "Departure Time",
  y = "Departure Delay (minutes)",
  title = "Departure Delays For Each Departure Time"
)


#'
#'____________
#'____________
#' ### Exercise 3: Zoom in on the y axis from 50 to 100 minutes using coord_cartesian(), and also have breaks every 15 minutes using scale_y_continuous() and also scale_x_continuous on fl_sc plot. W
#' Book Section 28.5, (pg28.25) and https://rpubs.com/Mentors_Ubiqum/scale_x_continuous
#' 
fl_bp <- flights %>%
ggplot(aes(x = carrier, y = dep_delay))
fl_bp + geom_boxplot() +
  labs(
    x = "Carrier Abbreviation",
    y = "Departure Delay (minutes)",
    title = "Departure Delays Boxplots by Carrier") +
  coord_cartesian(ylim = c(50,100) ) +
  scale_y_continuous(breaks = seq(from = 45, to = 105, by = 15))




fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay))
fl_sc + geom_point() +
  labs(
    x = "Departure Time",
    y = "Departure Delay (minutes)",
    title = "Departure Delays For Each Departure Time") +
  coord_cartesian(ylim = c(50,100) ) +
  scale_x_continuous(breaks = seq(from = 800, to = 860, by = 15)) +
  scale_y_continuous(breaks = seq(from = 45, to = 105, by = 15))  

#'
#'____________
#'____________
#' ### Exercise 4: Color the points of fl_sc by origin using the Brewer scale using scale_color_brewer().  
#' Book Section 28.4.3.  (pg28.25)
#' 
#' 


library(RColorBrewer)    #  load the colorbrewer library  Note: Brewer scale is for discrete variables.

fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay, color = origin))   #add color=origin
fl_sc + geom_point() +
  labs(
    x = "Departure Time",
    y = "Departure Delay (minutes)",
    title = "Departure Delays For Each Departure Time") +
  coord_cartesian(ylim = c(50,100) ) +
  scale_x_continuous(breaks = seq(from = 800, to = 860, by = 15)) +
  scale_y_continuous(breaks = seq(from = 45, to = 105, by = 15)) +
  scale_colour_brewer(palette = "Set1")     #add the palette choice
  

#'
#'____________
#'____________
#' ### Exercise 5: Choose a theme, change the orientation of the x-axis text to 35 degrees, and save your final plot.
#' Themes: Book Section 28.6. (pg 28.35) ;  Axis Text Orientation (5inclass line 320) ;  ggsave : Book Section 28.7 (pg28.39)
#' 
library(tidyverse)
fl_bp <- flights %>%
  ggplot(aes(x = carrier, y = dep_delay))
fl_bp + geom_boxplot() +
  theme_light() +
  labs(
    x = "Carrier Abbreviation",
    y = "Departure Delay (minutes)",
    title = "Departure Delays Boxplots by Carrier") +
    coord_cartesian(ylim = c(50,100) ) +
    scale_y_continuous(breaks = seq(from = 45, to = 105, by = 15)) +
    theme(axis.text.x = element_text(angle = 35))
ggsave("10TaskBoxPlot.png")    
#'
#'____________
#'____________
#'### **10Task BoxPlot**: a short paragrph describing your plot and what you learned from creating the plot.<br>
#'This plot actually only shows the upper outliers because the y limits have excluded the box of the boxplots.  It now shows which carriers have late departures in the 50 to 100 minute range. 
#'I learned how to change the limits of the y-axis. 
#'I learned how to set the increments for breaks for the grid.
#'Re-learned how to set the color, and change the axis titles, and plot title.
#'<br>



fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay, color = origin))   
fl_sc + geom_point() +
  theme_light() +
  labs(
    x = "Departure Time",
    y = "Departure Delay (minutes)",
    title = "Departure Delays For Each Departure Time") +
  coord_cartesian(ylim = c(50,100) ) +
  scale_x_continuous(breaks = seq(from = 800, to = 860, by = 15)) +
  scale_y_continuous(breaks = seq(from = 45, to = 105, by = 15)) +
  scale_colour_brewer(palette = "Set1") +     
  theme(axis.text.x = element_text(angle = 35))
ggsave("10TaskScatterPlot.png")

#'
#'____________
#'____________
#'### **10Task ScatterPlot**: a short paragrph describing your plot and what you learned from creating the plot.<br>
#'This plot shows departure times (x) between 8am and 8:30am. And Departur delays from 50 to 100 minutes on the y-axis.  Data points are colorized by carrier.  Interesting are the diagonal tracks of points from lower-left to upper-right.  Apparently there is a close correlation between when the flight was scheduled to leave, and how delayed it will be.  These tracks might show a bottleneck in the runway operations.  Once a logjam occurs, then each successive flight is pushed back by one more minute.  
#'I learned how to change the axis text angle, 
#'I learned how to pick the color_brewer palette.
#'<br>
#'
#'____________
#'____________
#' ### Exercise 6: Use the code from 28.3 and recreate the following plot as well as you can. Note, you don’t need to match the color scheme, but if you want to, I used library(viridis). Save your plot.
library(viridis)
#' 
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(cty)) == 1)
best_in_class


ggplot(mpg, aes(displ, cty)) +
geom_point(aes(size = 8, colour = class)) +
  theme_light() +
  labs(
    x = "Engine displacement",
    y = "Miles per gallon (highway)",
    color = "Vehicle type") +
  coord_cartesian(ylim = c(10,40) ) +
  scale_x_continuous(breaks = seq(from = 2, to = 7, by = 1)) +
  scale_y_continuous(breaks = seq(from = 10, to = 40, by = 10)) +
  scale_fill_viridis() + 
  geom_point(shape = 21, size = 5, stroke = 2, data = best_in_class) +
  guides(size = FALSE, shape = 1) +             #book 28.4.1
  ggrepel::geom_text_repel(aes(label = model, color = class), data = best_in_class, nudge_x = -1, nudge_y = -1) +
  theme(panel.grid.minor.y = element_blank(),   #takes out the mminor horizontal white lines
          panel.grid.minor.x = element_blank())   #takes out the minor vertical white lines)
ggsave("10TaskExercise6Plot.png")

#'
#'____________
#'____________
#'### **Plot for Exercise 6**: a short paragrph describing your plot and what you learned from creating the plot. <br>
#'This plot shows engine displacement (x) and miles per gallon (y),and calls out the best-in-class model for each of 7 classes.  Data points are colorized by class.  There is a negative correlation between engine displacement and miles per gallon, with larger engine displacement causing fewer miles per gallon.  Also the vertical dispersion of the datacloud shows that in the smaller-displacement engines there is a larger variation, from 17mpg up to 35 mpg.  While in the larger-displacement engines, there is less variation, from 11 to 16 mpg.
#'I learned how to change the shape, size, and stroke of the Best-In-Class points.
#'Can't figure out how to color-code them, though.
#'Learned how to turn off one of the sub-legends using 'guide' command.
#'Couldn't get viridis to work.
#'Learned about negative nudging to plave labels below and to the left of a point.
#'Can't figure out how to change the icon in the legend.  Used to be a circle, but it changes to a leaf, or something.