#' ---
#' title: "Task 7: Developing a Graphic"
#' author: "TomHollinberger"
#' date: "9/20/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'
#'# **Task 7 Developing a Graphic** 
#'
#' _________________________________
#'   


flts <- nycflights13::flights
str(flts)
?flights

library(ggplot2)
library(ggcorrplot)
#'
#' ## [ ] Find an insightful relationship between two of the variables (columns) and display that relationship in a table or graphic.

#' Strip Off Outliers using https://rpubs.com/Mentors_Ubiqum/removing_outliers
 
boxplot(flts$arr_delay)$out  #get the actual values of the outliers with this
boxplot(flts$arr_delay, plot=FALSE)$out #(Optional) hide the plot using plot=FALSE
outliers <- boxplot(flts$arr_delay, plot=FALSE)$out #assign the outlier values into a vector
print(outliers) # Check the results
flts[which(flts$arr_delay %in% outliers),] # First you need find in which rows the outliers are
fltsout <- flts[-which(flts$arr_delay %in% outliers),]  #remove the rows containing the outliers
boxplot(fltsout$arr_delay)  #check the boxplot, Now without outliers.

#' str(fltsout)  #look at the data without outliers
#' summary(fltsout)  #look at the data without outliers

#'
#' ## [ ] Provide a distributional summary of the relevant variable in nycflights13::flights.
#' Distribution of Arr_Delays  -- using Density Plot from Top 50 Master List
g <- ggplot(fltsout, aes(arr_delay))
g + geom_density(aes(), alpha = 0.8) + 
  labs(title = "Arrival Delays, Outliers excluded", 
       subtitle = "All months and all locations.",
       caption = "Source: fltsout.                           Negative times represent early arrivals.",
       x = "Arrival Delays in Minutes"
     )
ggsave("7TaskPlot1.png", width = 15, units = "in")


#'
#' ## [ ] Build bivariate summaries of the relevant variables.
#' Side-by-Side Box Plots of Each Month's Arrival Delays

ggplot(fltsout, aes(factor(month), arr_delay)) +    #add color, and side-by-side of auto&manual
  geom_boxplot(aes(color = factor(month))) +
  labs(title = "Arrival Delays per Month, Outliers excluded", 
     subtitle = "Boxplot for Distribution of Arrival Delays in each Month.  All Airlines, All Airports.",
     caption = "Source: fltsout.                           Negative times represent early arrivals.",
     y = "Arrival Delays in Minutes",
     x = "Month"
     )
ggsave("7TaskPlot2.png", width = 15, units = "in")
#'
#' ## [ ] document the iterative script that built to your insightful relationship.
#' See the notes and comments for each code line and code section.

#'
#' ## [ ] Review the “What do people do with new data” link above and write one quote that resonated with you in your .R file.
#' Quotable Quote from "What People Do With New Data"
#' 
#' #### *"If it is medical/social data I usually look for personally identifiable information, remove PII and burn it with fire — Peter Skomoroch "*
#' 
#' 
#'
#' ## [ ] In your .R script include also your data visualization development with 1-2 commented paragraphs summarizing your 2 finalized graphics and the choices you made in the data presentation.
#' ### Data Manipulation
#' Data was brought in from flights datra frame.  
#' Str and ?Flights was used to understand the dataframe structure and variable definitions.
#' From previous boxplots, I knew there were many, many outliers.
#' The outliers were removed using code found on the rpubs.com website.  
#' Str and summary of the new fltsout dataframe was performed to see the new layout. 
#'
#' ### Data Visualization
#' I decided that an interesting connection would be the relation between Month and Arrival_Delays.
#' That is, is there a trend of better or worse arrival performance across the months of a year.
#' Could there be logical (weather or human factors) explanations for these monthly changes in arrival performance?<br>
#' **A Dentisty Plot** was chosen from Top 50 Master List to show how the overall success rate for Arrivals.  
#' It shows that the average arrival time is actually ahead of schedule.  And that there is a strong right tail (lateward).
#' This is indicative of a safety-conscious and weather-dependent operation which can and should be delayed often.<br>
#' **Side-by-Side Boxplots** were used to show the biavriate relation between months of the year and arrival times. 
#' A separate boxplot for each month, side-by-side, with a common vertical (arrival lateness) scale.
#' This plot is helpful in identifying which months have the most/least delays, and logical reasons can be inferred.
#' Such as, Spring Break travel in April, Holiday Travel in December, Summer vacation travel, Less travel when school starts in September.
#' 
#' 
#' 
#' ## [ ] Save your .png images of each your final graphics and push all your work (including your .R file) to your repository.<br>
#' Used this code above:  ggsave("7TaskPlot1.png", width = 15, units = "in")  #saves to the project folder, overwrites without asking
#'
#'<br><br><br>
#' #### Scratch
#' Use a Correlation matrix

#' Select only numeric columns.  From https://statisticsglobe.com/select-only-numeric-columns-from-data-frame-in-r
num_cols <- unlist(lapply(flts, is.numeric))         # Identify numeric columns
num_cols
data_num <- flts[ , num_cols]                        # Subset numeric columns of data
data_num   
str(data_num)

#' Correlogram Plot of numeric columns 1-14  (not sure why it throws out some variables)
ggcorrplot(cor(data_num[,1:14]),   #Correlogram from Top50 Master List
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method = "circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title = "Correlogram of flts", 
           ggtheme = theme_bw)
