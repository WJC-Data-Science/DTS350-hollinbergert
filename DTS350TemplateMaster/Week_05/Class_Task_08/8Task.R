#' ---
#' title: "Task 8: Data to Answer Questions"
#' author: "TomHollinberger"
#' date: "9/22/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    number_sections: true
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.

#' [ ] In an .Rmd file include links to sources with a description of the quality of each data source.<br>
#' [ ] Find 3-5 potential data sources (that are free) and document some information about the source.<br>
#' [ ] Build an R script that reads in, formats, and visualizes the data using the principles of exploratory analysis.<br>
#' [ ] Write a short summary in your .Rmd file of the read in process and some coding secrets you learned.<br>
#' [ ] Include 2-3 quick visualizations in your .Rmd file that you used to check the quality of your data.<br>
#' [ ] Summarize the limitations of your final compiled data in addressing your original question.<br>
#' [ ] After formatting your data, identify any follow up or alternate questions that you could use for your project.<br>
#' _________________________________
#' _________________________________
#'
#' # Task 8: : Data to Answer Questions
#' _________________________________
#' _________________________________
#'  
#' ## Data Source 1 : **Candy Power Rankings**
#' ### **My Question**:  What are the characteristics of the Winning candy? 
#' #### from fivethirtyeight, via github, candy-rank.csv
#' The data contains the following fields:<br>
#' chocolate =	Does it contain chocolate?<br>
#' fruity = Is it fruit flavored?<br>
#' caramel =	Is there caramel in the candy?<br>
#' peanutalmondy =	Does it contain peanuts, peanut butter or almonds?<br>
#' nougat =	Does it contain nougat?<br>
#' crispedricewafer =	Does it contain crisped rice, wafers, or a cookie component?<br>
#' hard =	Is it a hard candy?<br>
#' bar =	Is it a candy bar?<br>
#' pluribus =	Is it one of many candies in a bag or box?<br>
#' sugarpercent =	The percentile of sugar it falls under within the data set.<br>
#' pricepercent =	The unit price percentile compared to the rest of the set.<br>
#' winpercent =	The overall win percentage according to 269,000 matchups.<br>
#'
#' read in https://github.com/fivethirtyeight/data/blob/master/candy-power-ranking/candy-data.csv
#' 
#' ### **Download, Read, Explore/Inspect the Data, Manipulate (Change Column Titles), Check for Blanks, Save as csv, Overview Plots** 
library(tidyverse)
library(dplyr)
library(ggplot2)
library(car)  #for the scatterplotMatrix

#'### **Download** a file from FiveThirtyEight
#'Check working directory first to make sure you agree with where it's going.
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08"

download.file("https://raw.githubusercontent.com/fivethirtyeight/data/master/candy-power-ranking/candy-data.csv",
              "cpr.csv", mode = "wb")  #saves to working directory
#' Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
#' you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command
#'
#'### **Read_csv** in the "Path/File" 
cpr <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08/cpr.csv")   #could filter at this point
#'
#'### **Explore/Inspect the Data**
str(cpr)
head(cpr, n = 10)
tail(cpr, n = 10)
sapply(cpr,class)
summary(cpr)
#'
#'### **Manipulate** (Use *'rename'* to Change Column Titles) 
cpr2 <- rename(cpr,choc = chocolate, frut = fruity, carm = caramel, pean = peanutyalmondy, noug = nougat, rice = crispedricewafer, hard = hard, bar =  bar, plur = pluribus, sugpct = sugarpercent, pricpct = pricepercent, winpct = winpercent)
#' it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
#'
#'### **Check for blank cells**
table(is.na(cpr2$choc))    #looking for 85 False's, the fully-populated list, with no NA's
table(is.na(cpr2$frut)) 
table(is.na(cpr2$carm)) 
table(is.na(cpr2$pean)) 
table(is.na(cpr2$noug)) 
table(is.na(cpr2$rice))
table(is.na(cpr2$hard))
table(is.na(cpr2$bar))
table(is.na(cpr2$plur))
table(is.na(cpr2$sugpct))
table(is.na(cpr2$pricpct))
table(is.na(cpr2$winpct))
#'
#'### **Save as a csv**
write_csv(cpr2,"cpr2.csv")  #check in excel to be sure you got what you wanted.
#'
#'### **Plot Overview Graphics and save the plots** Density for single variables, scatterplotMatrix to find intuitively-paired variables
scatterplotMatrix(formula = ~ sugpct + pricpct + winpct, data = cpr2)

g <- ggplot(cpr2, aes(sugpct))
g + geom_density(aes(), alpha = 0.8) + 
  labs(title = "Distribution of Sugar Percentages",    # I think this is really percent of mass that is sugar.
       subtitle = "All Candies.",
       caption = "Source: cpr2.",
       x = "Percentile"
  )
ggsave("sugpct.png", width = 8, units = "in")

g <- ggplot(cpr2, aes(pricpct))
g + geom_density(aes(), alpha = 0.8) + 
  labs(title = "Distribution of Price Percentiles",    # I think this percentile ranking of price.
       subtitle = "All Candies.",
       caption = "Source: cpr2.",
       x = "Percentile"
  )
ggsave("pricpct.png", width = 8, units = "in")

g <- ggplot(cpr2, aes(winpct))
g + geom_density(aes(), alpha = 0.8) + 
  labs(title = "Distribution of 'Win' Percentages",    # I think this is overall win percentage  Win in 269,000 random matchups.  Need to read article more.
       subtitle = "All Candies.",
       caption = "Source: cpr2.",
       x = "Percentile"
  )
ggsave("winpct.png", width = 8, units = "in")

#' ### Count of 1's for Binary variables
(pctchoc <- sum(cpr2$choc > 0)/85)       #43.5%  from https://www.theanalysisfactor.com/r-tutorial-count/
(pctfrut <- sum(cpr2$frut > 0)/85)       #44.7%
(pctcarm <- sum(cpr2$carm > 0)/85)       #16.4%
(pctpean <- sum(cpr2$pean > 0)/85)       #16.4%
(pctnoug <- sum(cpr2$noug > 0)/85)       #08.2%
(pctrice <- sum(cpr2$rice > 0)/85)       #08.2%
(pcthard <- sum(cpr2$hard > 0)/85)       #17.6%
(pctbar <- sum(cpr2$bar > 0)/85)         #24.7%
(pctplur <- sum(cpr2$plur > 0)/85)       #51.7%
#'
#'### **Data Limitations and Alternate Questions**:  
#'Not sure what the percentage variables (the last three) are saying.  Will need to read and analyze more thoroughly.<br>
#'Need to figure out how to plot multiple binary dummy variables (the first 9 variables) <br>
#'Maybe an interesting ALTERNATIVE question would be: What winning 'market-share' does each ingredient enjoy?  E.g. if Chocolate shows up in 43% of candy products lines, what if that were weighted by winning.
#'___________________________
#'___________________________
#'
#' ## Data Source 2 : **Beer, Wine, and Spirits Alcohol Consumption by Country**
#' ### **My Question**:  Are there trade-offs between Beer, Wine, and Spirits?  When one goes up, does the other go down?
#' #### from fivethirtyeight, via github, alcohol-consumption/drinks.csv
#' The data contains the following fields:
#' country 	
#' beer_servings 	
#' spirit_servings 	
#' wine_servings 	
#' total_litres_of_pure_alcohol
#' 
#' 
#' ### **Download, Read, Explore/Inspect the Data, Manipulate (Change Column Titles), Check for Blanks, Save as csv, Overview Plots** 
library(tidyverse)
library(dplyr)
library(ggplot2)
library(car)  #for the scatterplotMatrix

#'### **Download** a file from FiveThirtyEight
#'Check working directory first to make sure you agree with where it's going.
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08"

download.file("https://raw.githubusercontent.com/fivethirtyeight/data/master/alcohol-consumption/drinks.csv",
              "ac.csv", mode = "wb")  #saves to working directory
#' Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
#' you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command
#'
#'### **Read_csv** in the "Path/File" 
ac <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08/ac.csv")   #could filter at this point
#'
#'### **Explore/Inspect the Data**
str(ac)
head(ac, n = 10)
tail(ac, n = 10)
sapply(ac,class)
summary(ac)
#'
#'### **Manipulate** (Use *'rename'* to Change Column Titles) 
ac2 <- rename(ac,ctry = country, beer = beer_servings, spirit = spirit_servings, wine = wine_servings, total = total_litres_of_pure_alcohol)
#'
#'### **Check for blank cells**
#' it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
table(is.na(ac2$ctry))    #looking for 193 False's, the fully-populated list, with no NA's
table(is.na(ac2$beer)) 
table(is.na(ac2$wine)) 
table(is.na(ac2$spirit)) 
table(is.na(ac2$total)) 
#'
#'### **Save as a csv**
write_csv(ac2,"ac2.csv")  #check in excel to be sure you got what you wanted.
#'
#'### **Plot Overview Graphics and save the plots** Density for single variables, scatterplotMatrix to find intuitively-paired variables
ac2
library(car)
scatterplotMatrix(formula = ~ beer + wine + spirit + total, data = ac2)  
#'

#only list numerics, need to open the lower-right plots window

# ??How to save this as a png, can't use ggsave since it was not createsd in ggplot
#png("plot.png", width = 480, height = 240, res = 120) #from http://www.cookbook-r.com/Graphs/Output_to_a_file/
#plot()
#dev.off()
#dev.
#' 
#'### **Data Limitations and Alternate Questions**:  
#'Should be straightforward, would show up as a negative correlation.
#'Maybe a more interesting ALTERNATIVE question would be: What is the preferred mix of beer, wine, spirits?
#'  
#'      
#'___________________________
#'___________________________
#'
#' ## Data Source 3 : **Bad Drivers by State**
#' ### **My Question**:  What are most common causes of fatal accidents, by State, weighted by something?
#' #### from fivethirtyeight, via github, bad-drivers.csv
#' The data contains the following fields:
#' State <br>
#' Number of drivers involved in fatal collisions per billion miles<br>
#' Percentage Of Drivers Involved In Fatal Collisions Who Were Speeding<br>
#' Percentage Of Drivers Involved In Fatal Collisions Who Were Alcohol-Impaired<br>
#' Percentage Of Drivers Involved In Fatal Collisions Who Were Not Distracted<br>
#' Percentage Of Drivers Involved In Fatal Collisions Who Had Not Been Involved In Any Previous Accidents<br>
#' Car Insurance Premiums 	<br>
#' Losses incurred by insurance companies for collisions per insured driver<br>
#' 
#' read   https://github.com/fivethirtyeight/data/blob/master/bad-drivers/bad-drivers.csv
#'
#' ### **Download, Read, Explore/Inspect the Data, Manipulate (Change Column Titles), Check for Blanks, Save as csv, Overview Plots** 
library(tidyverse)
library(dplyr)
library(ggplot2)
library(car)  #for the scatterplotMatrix
#'
#'### **Download** a file from FiveThirtyEight
#'Check working directory first to make sure you agree with where it's going.
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08"

download.file("https://raw.githubusercontent.com/fivethirtyeight/data/master/bad-drivers/bad-drivers.csv",
              "bd.csv", mode = "wb")  #saves to working directory
#' Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
#' you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command
#'
#'### **Read_csv** in the "Path/File" 
bd <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08/bd.csv")   #could filter at this point
#'
#'### **Explore/Inspect the Data**
str(bd)
head(bd, n = 10)
tail(bd, n = 10)
sapply(bd,class)
summary(bd)
#'
#'### **Manipulate** (Use *'rename'* to Change Column Titles)   MANUALLY took ($) out of last two column headers, and shorten all headers in csv.
#' MANUALLY saved as bd2    
#' bd2 <- bd      
bd2 <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/Class_Task_08/bd2.csv")

#'
#'### **Check for blank cells**
#' it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
table(is.na(bd2$State))    #looking for 193 False's, the fully-populated list, with no NA's
table(is.na(bd2$Fatal)) 
table(is.na(bd2$Speeding)) 
table(is.na(bd2$Acohol)) 
table(is.na(bd2$NotDistracted)) 
table(is.na(bd2$NoPrev))
table(is.na(bd2$Premiums))
table(is.na(bd2$Losses))

#'
#'### **Save as a csv**
#' write_csv(bd2,"bd2.csv")  #check in excel to be sure you got what you wanted.  #'this is obviated by the manual column name changes
#'
#'### **Plot Overview Graphics and save the plots** Density for single variables, scatterplotMatrix to find intuitively-paired variables
bd2
library(car)
scatterplotMatrix(formula = ~ Fatal + Speeding + Acohol + NotDistracted + NoPrev + Premiums + Losses, data = bd2)  
#'
#'### **Data Limitations and Alternate Questions**:  
#'Need to understand more of the implications of NoPrevious and NotDistracted.  Seems like they would have a reverse effect.  <br>
#'Maybe an interesting ALTERNATE question would be: do Premiums correlated with Losses?


#'

#only list numerics, need to open the lower-right plots window

# ??How to save this as a png, can't use ggsave since it was not createsd in ggplot
#png("plot.png", width = 480, height = 240, res = 120) #from http://www.cookbook-r.com/Graphs/Output_to_a_file/
#plot()
#dev.off()
#dev.
#'        



