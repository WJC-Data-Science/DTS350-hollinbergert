#' ---
#' title: "Case Study 4 : Data Dissection"
#' author: "TomHollinberger"
#' date: "9/17/2020"
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
#'# **Case Study 4 : Data Dissection** 
#'
#' _________________________________
#'   
#'## Introduction:<br>
#'  This analysis uses the nycflights13::flights data to review flight delays.<br>
#'  Arrival and Departure delays are measured in minutes.<br>
#'  There are: 3 Origin airports, 105 destination airports, 16 carriers,  <br>
#'  4044 Airplanes, 3844 routes, 1 year (2013)  <br> 
#' In this analysis, we determine:<br>
#' 1. Least departure delays,<br>
#' 2. Least arrival delays, and<br>
#' 3. The overall worst performing airport<br>
#' for several constrained situations.<br>
#' Several data visualizations portray the complexity of the data, and the ranking of carriers and airports.<br>
#'   



#'Install and read in the appropriate libraries
library(ggplot2)
library(dplyr)
library(tidyverse)

#' Read and inspect in the data
flts <- nycflights13::flights
str(flts)
?flights

unique(flts$origin)   #3 Origins: EWR, JFK, LGA
unique(flts$dest)    # 105 different destinations
unique(flts$carrier)  # 16 carriers
unique(flts$tailnum)  #4044 airplanes (tailnumbers)
unique(flts$flight)   #3844 routes
unique(flts$year)     # 1 year  
unique(flts$carrier)

#'## A Visualization showing the complexity of the data<br>
#'#' Distributions of Arr_Delays and Dep_Delays -- using Density Plot from Top 50 Master List
#'
#'
#' Distribution of Arr_Delays (Red) and Dep_Delays (Green)  -- using Density Plot from Top 50 Master List<br>
#' Using all flights, did not remove outliers.<br>
#' Note that arrival delays in red extend well beyond 1000.<br>

ggplot(flts) +
  geom_density(aes(arr_delay), alpha = 0.8, color = "Green", size = 1) + 
  geom_density(aes(dep_delay), alpha = 0.8, color = "Red", size = 1) + 
  labs(title = "Arrival Delays (Red), Departure Delays (Green), INcluding Outliers", 
       subtitle = "All months, All locations",
       caption = "Source: fltsout.                           Negative times represent early arrivals.",
       x = "Arrival and Departure Delays in Minutes"
  )


#' Distribution of Arr_Delays (Red) and Dep_Delays (Green)  -- using Density Plot from Top 50 Master List<br>
#' HAving removed outliers.<br>
#' Note that arrival delays in red now extend to around 600.<br>

#' Strip Off Arr_Delay Outliers using https://rpubs.com/Mentors_Ubiqum/removing_outliers
outliers <- boxplot(flts$arr_delay, plot=FALSE)$out #assign the outlier arr_delay values into a vector
print(outliers) # Check the results
flts[which(flts$arr_delay %in% outliers),] # First you need find in which rows the outliers are
fltsout <- flts[-which(flts$arr_delay %in% outliers),]  #remove the rows containing the outliers
str(fltsout)  #look at the data without outliers
summary(fltsout)  #look at the data without outliers

#' Now Plot
ggplot(fltsout) +
  geom_density(aes(arr_delay), alpha = 0.8, color = "Red", size = 1) + 
  geom_density(aes(dep_delay), alpha = 0.8, color = "Green", size = 1) + 
  labs(title = "Arrival Delays (Red), Departure Delays (Green), EXcluding Outliers", 
       subtitle = "All months and all locations.",
       caption = "Source: fltsout.                           Negative times represent early arrivals.",
       x = "Arrival and Departure Delays in Minutes"
  )


#' Now a zoom-in to the Arrival Delays<br>
#' Note this shows that the industry, on average, has early arrivals by about 12 minutes. 

g <- ggplot(fltsout, aes(arr_delay))
g + geom_density(aes(), alpha = 0.8, color = "Red", size = 1) + 
  labs(title = "Zoom-In to Arrival Delays, Outliers excluded", 
       subtitle = "All months and all locations.",
       caption = "Source: fltsout.                           Negative times represent early arrivals.",
       x = "Arrival Delays in Minutes"
  )



#'
#' _________________________________
#'  
#'
#'## Question 1. If I am leaving before noon, which two airlines do you recommend at each airport (JFK, LGA, EWR) that will have the lowest delay time at the 75th percentile?

#' Strip Off Dep_Delay Outliers using https://rpubs.com/Mentors_Ubiqum/removing_outliers
outliers <- boxplot(flts$dep_delay, plot=FALSE)$out #assign the outlier values into a vector
print(outliers) # Check the results
flts[which(flts$dep_delay %in% outliers),] # First you need find in which rows the outliers are
fltsout <- flts[-which(flts$dep_delay %in% outliers),]  #remove the rows containing the outliers
str(fltsout)  #look at the data without outliers
summary(fltsout)  #look at the data without outliers


fo3am <- filter(fltsout, hour < 12, origin %in% c("JFK","LGA","EWR")) #filter for rows that are before noon and depart from these three airports

fo3ambyarpt <- group_by(fo3am, origin, carrier)   #group by carrier and origin
grpd <- summarise(fo3ambyarpt, Q3depdelay = quantile(dep_delay, c(.75), na.rm = TRUE)) # Produce the 75thpercentile for each airport
str(grpd)

#' Create factor / categorical / discrete variables out of Country and GDPQ2
grpd$carrier <- as.factor(grpd$carrier)
grpd$Q3depdelay <- as.factor(grpd$Q3depdelay)


# Draw Bar Chart plot
ggplot(grpd, aes(x = carrier, y = Q3depdelay)) +    
#ggplot(grpd, aes(x = reorder(Q3depdelay,origin,carrier), y = Q3depdelay)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  facet_wrap(~ origin) +
  labs(title="75th percentile Departure Delays", 
       subtitle="at EWR, JFK, and LGA, by Carrier", 
       caption="Source: fltsout.                                   Negative times represent early departures.", 
       y = "75th percentile Departure Delays",
       x = "Carriers at Each Airport") +                                          
  theme(axis.text.x = element_text(angle=65, vjust=0.6))
#'
#' ### Interpretation:
#' Note that negative numbrs are early departures, so the most reliable will have the most negative 75th percentile. <br>
#' At EWR, the 2 most reliable carriers are 9E and a three-way tie for seci=ond place between B6, DL, and US.<br>
#' At JFK, the 2 most reliable carriers are a five way tie between: 9E, DL, EV, HA and MQ.<br>
#' At LGA, the 2 most reliable carriers are US and YV.<br>
#'
#'
#' _________________________________
#'  
#' ## Question 2.  Which origin airport is best to minimize my chances of a late arrival (AT THE OTHER END) when I am using Delta Airlines?
#'Install and read in the appropriate libraries
library(ggplot2)
library(dplyr)
library(tidyverse)

#' Read and inspect in the data
flts <- nycflights13::flights
str(flts)
unique(flts$origin)   #3 Origins: EWR, JFK, LGA
unique(flts$dest)    # 105 different destinations

#' Strip Off Arr_Delay Outliers using https://rpubs.com/Mentors_Ubiqum/removing_outliers
outliers <- boxplot(flts$arr_delay, plot=FALSE)$out #assign the outlier arr_delay values into a vector
print(outliers) # Check the results
flts[which(flts$arr_delay %in% outliers),] # First you need find in which rows the outliers are
fltsout <- flts[-which(flts$arr_delay %in% outliers),]  #remove the rows containing the outliers
str(fltsout)  #look at the data without outliers
summary(fltsout)  #look at the data without outliers

fodl <- filter(fltsout, carrier %in% c("DL"))  #filter for rows that are Delta airlines from all airports
str(fodl)
fodlbyarpt <- group_by(fodl, origin)  
fodlbyarpt
fodlgrpd <- summarise(fodlbyarpt, meandlarrdelay = mean(arr_delay, na.rm = TRUE)) # Produce the mean for each origin airport
fodlgrpd

#' Draw Bar Chart plot
ggplot(fodlgrpd, aes(x = origin, y = meandlarrdelay)) +
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  labs(title="Late Arrivals of Delta Flights Originating from these Airports", 
       subtitle="departing from EWR, JFK, and LGA", 
       caption="Source: fltsout.                                                        Negative times represent early departures.", 
       y = "Delta Arrival Delays at the OTHER END,",
       x = "when ORIGINATING from these Airports") +                                          
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

#'
#' ### Interpretation:
#' Note that negative numbrs are early arrivals, so the latest arrivals have the largest positive number.<br>
#' Note that we are measuring the arrival at ANOTHER airport, of flights ORIGINATING at these three airports.  <br>
#' JFK has the largest negative number, meaning that it has the earliest arrival times.<br>
#' 
#'
#' _________________________________
#' 
#' ## Question 3.  Which destination airport is the worst (based on Mean Arrival Delays) airport for arrival time?
library(ggplot2)
library(dplyr)
library(tidyverse)

flts <- nycflights13::flights
str(flts)
unique(flts$origin)   #EWR, JFK, LGA
unique(flts$dest)    # 105 different destinations

outliers <- boxplot(flts$arr_delay, plot=FALSE)$out #assign the outlier values into a vector
print(outliers) # Check the results
flts[which(flts$arr_delay %in% outliers),] # First you need find in which rows the outliers are
fltsout <- flts[-which(flts$arr_delay %in% outliers),]  #remove the rows containing the outliers
str(fltsout)  #look at the data without outliers
summary(fltsout)  #look at the data without outliers

fobydest <- group_by(fltsout, dest)  
fobydest
fobdgrpd <- summarise(fobydest, meanarrdelay = mean(arr_delay, na.rm = TRUE)) # Produce the mean for each airport
fobdgrpd
fobdgrpdbad <- filter(fobdgrpd, meanarrdelay >= 0)    #extract only those with positive meanarrdelay; i.e., bad
fobdgrpdbad  

#' Create factor / categorical / discrete variables out of Country and GDPQ2
fobdgrpdbad$destf <- as.factor(fobdgrpdbad$dest)
fobdgrpdbad$meanarrdelayf <- as.factor(fobdgrpdbad$meanarrdelay)

# Draw Ordered Bar Chart plot
ggplot(fobdgrpdbad, aes(x = reorder(meanarrdelay,dest), y = meanarrdelay)) +
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  geom_col(aes(fill = meanarrdelayf)) +  
  #  geom_text(aes(label = meandlarrdelay), nudge_x = 0.15, nudge_y = -1,size = rel(2)) +
  geom_text(aes(label = dest), nudge_x = 0, nudge_y = 0.3,size = rel(2)) +  
  labs(title="The Worst Airport:", 
       subtitle="i.e., with the largest mean arrival delays", 
       caption="Source: fltsout.                                                        Positive numbers are late arrivals.", 
       y = "Mean Arrival Delays in Minutes",
       x = "Airports") +                                          
#  theme(axis.text.x = element_text(angle=90, vjust=0.5))
  theme_light() +
  theme(plot.caption = element_text(hjust = 0),   #left-justify the caption (default is right-justified) https://ggplot2.tidyverse.org/reference/theme.html
        axis.title.x = element_blank(),            #deletes the axis titles
        #axis.title.y = element_blank(),
        legend.position = "none",                  #deletes the legend
        #panel.grid.major.y = element_blank(),       #deletes the horizontal gridlines
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(),             #deletes the x axis ticks and numbers    axis.ticks.y = element_blank())
  )
  
#'
#' ### Interpretation:
#' Note that negative numbers are early arrivals, so the worst airports have the largest positive mean.<br>
#' CAE (Columbia, South Carolina) and JAC (Jackson Hole, Wyoming) are by far the worst airports.
#'
#' _________________________________
#'  
#'<br><br><br>


#'[ ] Address at least two of the three questions stated in the background description (if you have time try to tackle all three).<br>
#'[ ] Make sure to include one or more visualization that shows the complexity of the data.<br>
#'[ ] Create one .rmd file that has your report.<br>
#'[ ] Have a section for each question.<br>
#'[ ] Make sure your code is in the report but defaults to hidden. (In the YAML include code_folding:  hide)<br>
#'[ ] Write an introduction section that describes your results.<br>
#'[ ] Make a plot of the data to show the answer to the specific question.<br>
#'[ ] Push your .Rmd, .md, and .html to your GitHub repo Week_04 file.<br>
#'[ ] Be prepared to discuss your analysis in the upcoming class.<br>
#'[ ] Complete the recommended reading on posting issues.<br>
#'[ ] Find two other student’s compiled files in their repository and provide feedback using the issues feature in GitHub (If they already have two issues find a different student to critique)<br>
#'[ ] Address 1-2 of the issues posted on your project and push the updates to GitHub<br>
