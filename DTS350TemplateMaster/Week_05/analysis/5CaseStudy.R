#' ---
#' title: "Case Study 5: Reducing Gun Deaths"
#' author: "TomHollinberger"
#' date: "9/22/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 5
#'    number_sections: true
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.

#'[ ] Provide a brief summary of the FiveThirtyEight article.
#'[ ] [ ] Create one plot that provides similar insight to their visualization in the article. It does not have to look like theirs.
#'[ ] [ ] Write a short paragraph summarizing their article.
#'[ ] Address the client’s need for emphasis areas of their commercials for different seasons of the year.
#'[ ] [ ] Provide plots that help them know the different potential groups (variables) they could address in different seasons (2-4 visualizations seem necessary).
#'[ ] [ ] Write a short paragraph describing each image.
#'[ ] Compile your .md and .html file into your git repository.
#'[ ] Find two other student’s compiled files in their repository and provide feedback using the issues feature in GitHub. (If they already have three issues find a different student to critique.)
#'[ ] Address 1-2 of the issues posted on your project and push the updates to GitHub.

#' _________________________________
#' _________________________________
#'
#' # Case Study 5: Reducing Gun Deaths
#' _________________________________
#' _________________________________
#' 
#' ## Brief summary of the FiveThirtyEight article.
#' There is no single database. The numbers are confusingly subsetted.  It is hard to distinguish likely targets for intervention. 
#' ## 30,000 total gun deaths per year, of that,
#' ### 21,334 are Suicides, of that, 
#' #### 18,134 (85%) are male, of that
#' ##### 9,600 (45% are males over 45)
#' ### 12,000 are Homicides, of that
#' #### 6,000 are young men, of that
#' ##### 4,000 are young black men
#' #### 1,700 are Women via Domestic Violence
#' #### 560 are accidents
#' #### 240 are Undetermined
#' #### 1,000 are police-involved shootings
#' #### 39 are police being shot
#' #### 82 are by Terrorists
#' #### Rare, No Total Given for Mass-Shootings


#' ##Create one plot that provides similar insight to their visualization in the article. It does not have to look like theirs. <br>
#' ### Data Source : **guns-data/full_data**
#' ### **My Question**:  What are the most frequent "intents", because they are likely clusters for intervention.<br> 
#' from fivethirtyeight, via github, guns-data/full_data.csv
#' The data contains the following fields:<br>
#'   ..   id = col_double(), 1 thru 100798<br>
#'   ..   year = col_double(), 2012 thru 2014<br>
#'   ..   month = col_double(), 1 thru 12<br>
#'   ..   intent = col_character(), Homocide, Suicide, Accidental, Undetermined, <br>
#'   ..   police = col_double(),  0 or 1  1= police-involved <br>
#'   ..   sex = col_character(), M or F <br>
#'   ..   age = col_double(),  numeric years <br>
#'   ..   race = col_character(), White, Black, Asian/Pacific Islander, Native American, Hispanic<br>
#'   ..   hispanic = col_double(),  100 if not Hispanic above, 9023 occurences of Hispanic.  998 ??   261, 211(very common), 210(very common), 222, 281, 282, <br>
#'   ..   place = col_character(),  Home, Street, Other, Trade/service area, Industrial/construction, etc....<br>
#'   ..   education = col_character()  BA+, Some College, HS/GED, Less THan HS, NA  <br>
#'
#' 
#' ### **Download, Read, Explore/Inspect the Data, Manipulate (Change Column Titles), Check for Blanks, Save as csv, Overview Plots** 
library(tidyverse)
library(dplyr)
library(ggplot2)

#'### **Download** a file from FiveThirtyEight
#'Check working directory first to make sure you agree with where it's going.
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/analysis"

#' download.file("https://raw.githubusercontent.com/fivethirtyeight/guns-data/master/full_data.csv",
#'               "gdfd.csv", mode = "wb")  #saves to working directory
#' Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
#' you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command
#'
#'### **Read_csv** in the "Path/File" 
gdfd <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/analysis/gdfd.csv")   #could filter at this point
#'
#'### **Explore/Inspect the Data**
#'Looked at csv and put Col A header in "ID"
str(gdfd)
head(gdfd, n = 10)
tail(gdfd, n = 10)
sapply(gdfd,class)
summary(gdfd)
#'
#'### **Manipulate** (Use *'rename'* to Change Column Titles) (NO NEED TO RENAME IN THIS CASE)
#gdfd2 <- rename(gdfd,new varname = oldvarname, etc...)
#' it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
gdfd2 <- gdfd
#'
#'### **Check for blank cells**
table(is.na(gdfd2$id))    #looking for 100798 False's, the fully-populated list, with no NA's
table(is.na(gdfd2$year)) 
table(is.na(gdfd2$month)) 
table(is.na(gdfd2$intent))   #there is one blank.
table(is.na(gdfd2$police)) 
table(is.na(gdfd2$sex))
table(is.na(gdfd2$age))      #there are 18 blanks
table(is.na(gdfd2$race))
table(is.na(gdfd2$hispanic))
table(is.na(gdfd2$place))      #there are 1384 blanks
table(is.na(gdfd2$education))  #there are 1422 blanks

#'
#'### **Save as a csv**
write_csv(gdfd2,"gdfd2.csv")  #check in excel to be sure you got what you wanted.
#'

#' from Bar Chart in Top 50 <br>
#' prep the freq table <br>
freqtable <- table(gdfd2$intent)
gdfdintent <- as.data.frame.table(freqtable)
head(gdfdintent, 12)
str(gdfdintent)    #Var1 is factor,  Freq is integer

g <- ggplot(gdfdintent, aes(Var1, Freq))
g + geom_bar(stat = "identity", width = .05, fill = "tomato2") +   #Error in default + theme : non-numeric argument to binary operator
  labs(title = "Gun Deaths", 
       subtitle = "by Intent",
       caption = "Source: gdfdintent") +
  theme(axis.text.x = element_text(angle = 65, vjust = .06))

#' 
#' 
#' Yates  (All Combinations)
#' first need to create categories for age <26 <51 <76
gdfd3 <- mutate(gdfd2, youngold = ceiling(age/25))
view(gdfd3)

by_all <- group_by(gdfd3, intent, police, sex, race, youngold)
yates <- summarize(by_all,
                   count = n())

yates    #has 192 rows (combinations)

view(yates)  #then click on column header of Count to sort high to low, and see the most frequently occuring population-sector


#' YatesPLUS  (All Combinations including place and education)
#' first need to create categories for age <26 <51 <76
gdfd3 <- mutate(gdfd2, youngold = ceiling(age/25))
view(gdfd3)

by_allplus <- group_by(gdfd3, intent, police, sex, race, youngold, place, education)
yatesplus <- summarize(by_allplus,
                   count = n())

yatesplus    #has 2280 rows (combinations)

view(yatesplus)  #then click on column header of Count to sort high to low, and see the most frequently occuring population-sector



#'  
#'      
#'    
#'        

#'### **Plot Overview Graphics and save the plots** Density for single variables, scatterplotMatrix to find intuitively-paired variables

#' from Bar Chart in Top 50
#' prep the freq table
freqtable <- table(gdfd2$month)
gdfdmo <- as.data.frame.table(freqtable)
head(gdfdmo, 12)
str(gdfdmo)    #Var1 is factor,  Freq is integer


library(ggplot2)
theme_set(theme_classic)

#' Plot using Top 50 Bar Chart
g <- ggplot(gdfdmo, aes(Var1, Freq))
g + geom_bar(stat = "identity", width = .05, fill = "tomato2") +   #Error in default + theme : non-numeric argument to binary operator
  labs(title = "Gun Deaths", 
       subtitle = "by Month",
       caption = "Source: gdfdmo") +
  theme(axis.text.x = element_text(angle = 65, vjust = .06))


#' Plot using Top 50 Historgan on a categorical variable
gdfd2

g <- ggplot(gdfd2, aes(month))
g + geom_bar(aes(fill=year), width = .05) +     #Error in default + theme : non-numeric argument to binary operator
  theme(axis.text.x = element_text(angle = .65, vjust = .06)) +
  labs(title = "Gun Deaths", 
       subtitle = "by Month",
       caption = "Source: gdfd2")




#'
#'### **Data Limitations and Alternate Questions**:  
#'Not sure what the percentage variables (the last three) are saying.  Will need to read and analyze more thoroughly.<br>
#'Need to figure out how to plot multiple binary dummy variables (the first 9 variables) <br>
#'Maybe an interesting ALTERNATIVE question would be: What winning 'market-share' does each ingredient enjoy?  E.g. if Chocolate shows up in 43% of candy products lines, what if that were weighted by winning.
#'___________________________
#'___________________________
#'