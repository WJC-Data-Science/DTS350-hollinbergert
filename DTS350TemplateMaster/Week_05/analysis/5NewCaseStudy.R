#' ---
#' title: "Case Study 5: Reducing Gun Deaths"
#' author: "TomHollinberger"
#' date: "9/22/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
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
#' # Case Study 5: **Reducing Gun Deaths**
#' _________________________________
#' _________________________________
#' 
#' ## **Brief summary** of the FiveThirtyEight article.
#' There is no single database. The numbers are confusingly subsetted.<br>
#' The obvious elephant in the room is Male-Suicides, but the other dimensions, such as Race, Gender, Police, Homocidal Intent, and the author's ulterior motive divert attention away from that. 
#' 
#' ### 30,000 total gun deaths per year, of that,
#' #### 21,334 are Suicides, of that, 
#' ##### ..18,134 (85%) are male, of that
#' ###### ....9,600 (45% are males over 45)
#' #### 12,000 are Homicides, of that
#' ##### ..6,000 are young men, of that
#' ###### ....4,000 are young black men
#' ##### ..1,700 are Women via Domestic Violence
#' ##### ..1,000 are police-involved shootings
#' ##### ..39 are police being shot
#' ##### ..82 are by Terrorists
#' ##### ..Rare, No Total Given for Mass-Shootings
#' #### 560 are Accidents
#' #### 240 are Undetermined
#'
#'
#'
#' ##Create one plot that provides similar insight to their visualization in the article. It does not have to look like theirs. <br>
#' Data Source : **guns-data/full_data**
#' ### **My Question**: How do variable vary from month-to-month, and does that inform a marketing approach for public service announcments.<br> 
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
#' **Download, Read, Explore/Inspect the Data, Manipulate (Change Column Titles), Check for Blanks, Save as csv, Overview Plots** 
library(tidyverse)
library(dplyr)
library(ggplot2)

#' **Download** a file from FiveThirtyEight
#'Check working directory first to make sure you agree with where it's going.
getwd()   #Good to go:  "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/analysis"
#'
#' download.file("https://raw.githubusercontent.com/fivethirtyeight/guns-data/master/full_data.csv",
#'               "gdfd.csv", mode = "wb")  #saves to working directory
#' Breadcrumbs:  FiveThirtyEight, scroll down to bottom, DAta, click on the file-of-interest info button to view what it's about, 
#' you are now in GitHub, click on the csv filename, click on raw, copy that browser link into your Rscript download command
#'
#'**Read_csv** in the "Path/File" 
gdfd <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_05/analysis/gdfd.csv")   #could filter at this point
#'
#'**Explore/Inspect the Data**
#'Looked at csv and put Col A header in "ID"
str(gdfd)
head(gdfd, n = 10)
tail(gdfd, n = 10)
sapply(gdfd,class)
summary(gdfd)
#'
#'**Manipulate** (Use *'rename'* to Change Column Titles) (NO NEED TO RENAME IN THIS CASE)(change to numerics)
#gdfd2 <- rename(gdfd,new varname = oldvarname, etc...)
#' it's easy to write this if you copy the first line of the file (the old column names) and paste into this code line, then add the new column names, along with = signs and commas.
# the result in the console has the old column titles, but when you call the new file's name it shows the new column titles.
gdfd2 <- gdfd
#'
#'**Change to numerics**
#' id <- as.numeric(id)   #Error   cannot coerce type 'closure' to vector of type 'double'
year <- as.numeric(gdfd2$year)
month <- as.numeric(gdfd2$month)
police <- as.numeric(gdfd2$police)
age <- as.numeric(gdfd2$age)
hispanic <- as.numeric(gdfd2$hispanic)
#'
#'
#'**Check for blank cells**
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
#'
#'**Save as a csv**
write_csv(gdfd2,"gdfd2.csv")  #check in excel to be sure you got what you wanted.
#'
#' 
#'### View All-Combinations (Yates)  (All Variables except takeout year, hispanic, and age(replaced by agecat with four 25year-wide bins)
#' 
gdfd3 <- mutate(gdfd2, agecat = ceiling(age/25))   #creates age categories for age <26 <51 <76 <101
gdfd3
gdfd4 <- select(gdfd3, police, month, intent, agecat, sex, race, education, place)  
gdfd4
by_all <- group_by(gdfd4, police, month, intent, agecat, sex, race, education, place)
yates <- summarize(by_all,
                   count = n())
yates    #has 10,835 rows (combinations various levels of the 8 variables)
#' view(yates)  #then click on column header of Count to sort high to low, and see the most frequently occuring population-sector
#  Also click on filter and see thumbnail distributions
#'
#'
#' ## **Plots and Insights**
#'
#'_____________________
#' _____________________
#' #### Plot 1:  Bar Chart,  Totals for Three years        
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = year), position = "dodge") 
#' #### Insight 1:  Year -- Very similar numbers from year to year.  No trending up or down.
#'
#'
#'
#' _____________________
#' _____________________
#' #### Plot 2: Age Category Clustered Bar Chart,  agecatf x month    Chap3 page 3.31
agecatf <- as.factor(gdfd4$agecat)   #first need to change agecat to a factor
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = agecatf), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 2:  Age Categories -- 1st) 25 to 50 years old, 2nd) 50 to 75 years old.    All age categories peak in Jul/Aug, with a secondary spike in Dec/Jan.  Largest month-to-month increase is from Feb to Mar.
       
#'
#'_____________________
#' _____________________
#' #### Plot 3: Race Clustered Bar Chart,  race x month 
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = race), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 3:  Race -- 1st) White, 2nd) Black.    All Race Categories peak in Jul/Aug (similar monthly profile as Age Categories)
#'
#'
#'_____________________
#' _____________________
#' #### Plot 4: Intent Clustered Bar Chart,  intent x month  
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = intent), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 4:  Intent Categories -- 1st) Suicide, 2nd) Homicide.    Interesting differences in the month-to-month tracks of Homicides vs Suicides.  Both peak in Jul, but Homicides has a secondary peak in Dec/Jan, whereas Suicides are low in Dec.  
#'
#'_____________________
#' _____________________
#' #### Plot 5: Police Clustered Bar Chart,  police x month    
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = police), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 5:  Police Involved -- Shows the same month-to-month track as Homicides.  Both peak in Jul, and have a secondary peak in Dec/Jan.  
#'
#'
#' _____________________
#' _____________________
#' #### Plot 6: Place Clustered Bar Chart,  place x month  
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = place), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 6:  Place -- 1st) Home, 2nd) Street.    Shows the same month-to-month track as Homicides.  Both peak in Jul, and have a secondary peak in Dec/Jan.
#'
#'
#'_____________________
#' _____________________
#' #### Plot 7: Education Clustered Bar Chart,  education x month  
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = education), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 7:  Education -- 1st) HS/GED, 2nd) Tie: Less than HS, Some College.    All age categories peak in Jul/Aug, with a secondary spike in Dec/Jan.  Largest month-to-month increase is from Feb to Mar.
#'
#'
#'
#'_____________________
#' _____________________
#' #### Plot 7: Gender Clustered Bar Chart,  gender x month  
ggplot(data = gdfd4) +
  geom_bar(mapping = aes(x = month, fill = sex), position = "dodge") +
  scale_x_continuous(breaks = 1:12)
#' #### Insight 7:  Gender -- 1st) Male, 2nd) Female.    Both genders peak in Jul/Aug, with a secondary spike in Dec/Jan.  Notice an anomaly for Females in October.
#'
#'_____________________
#' _____________________
#' ## **Consolidated Insight**<br>
#' All variables track similar year-long, month-to-month profiles.  That is, a peak in Jul/Aug and a secondary peak in Dec/Jan.  (Interestingly there is a consistent low in February.)<br>
#' From an intervention standpoint, that means that it isn't necessary to tailor or differentiate time-phased marketing strategies for the various races, ages, genders, etc.<br>
#' Just tailor the volume of it from month to month, based on the year-long, month-to-month profile. And target the high-occurence subgroups:
#' 
#' ### High Occurrences:
#' #### Months:  1) Jul/Aug, 2) Dec/Jan
#' #### Gender:  1) Males, 2) Female
#' #### Age:    1) 25-50 year olds,  2) 50-75 year olds
#' #### Race:    1) White, 2) Black
#' #### Intents: 1) Suicides, 2) Homicides
#' #### Education:  1) HS/GED, 2) Less Than HS, and Some college
#' #### Place:  1) In the home, 2) on the street
#'
#'
