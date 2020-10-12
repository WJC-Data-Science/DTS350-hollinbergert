#' ---
#' title: "Case Study 7 : Clean Your Data"
#' author: "TomHollinberger"
#' date: "10/08/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_07/Class_Task_12/messy_data.xlsx


library(tidyverse)
library(readr)
library(haven)
library(readxl)
library(downloader)  
library(dplyr)
library(foreign)  #for read.dbf


#'
#'## [ ] Use the correct functions from library(haven) , library(readr), and library(readxl) to load the 6 data sets listed here.

#'If files are   
#' .rds   use read_rds 
#' .csv   use read_csv
#' .dta   use read_dta
#' .sav   use read_sav  from the haven package   https://haven.tidyverse.org/
#' .xlsx  use downloader


#' Links to files to download, 
#' these were right-click copylink from moodle page.
#' https://github.com/WJC-Data-Science/DTS350/blob/master/Height.xlsx     #Tubingen  xlsx format
#' https://github.com/WJC-Data-Science/DTS350/blob/master/germanconscr.dta   #German conscripts  Stata format
#' https://github.com/WJC-Data-Science/DTS350/blob/master/germanprison.dta   #Bavarian conscripts Stata format
#' https://github.com/WJC-Data-Science/DTS350/tree/master/Heights_south-east     #SESW Soldiers , this is dbf format
#' https://github.com/hadley/r4ds/raw/master/data/heights.csv                       #BLS csv format -- this already says raw, so use it directly in download code below
#' http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav  #National survey height Wisconson sav format

#' Place each link in the browser, it takes you to github, right-click on download, copylink, paste link (was 'raw' instead of 'blob') into download code immediately below this line.


#'follow-on files
#'http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/nsfh3mainroster1-04042005.sav   #National survey Household Wisconson
#'http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/Nsfh3main04202005.CBK           #National survey Codebook Wisconson
#'https://www.ssc.wisc.edu/nsfh/support.htm                                                       #National survey Q&A Wisconson


#' download the Tubingen .xlsx
tmpxlsx <- tempfile()
tmpxlsx
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Height.xlsx",tmpxlsx, mode = "wb")
a1xlsx <- read_xlsx(tmpxlsx)
a1xlsx
summary(a1xlsx)

#' Looked at Tubingen result and we need to skip one line because the first line is NA's and the 2nd line is the column headings.
#' 
tmpxlsx <- tempfile()
tmpxlsx
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Height.xlsx",tmpxlsx, mode = "wb")
a1xlsx <- read_xlsx(tmpxlsx, skip = 1)
a1xlsx
summary(a1xlsx)

#' download the German conscripts.dta
tmpdta <- tempfile()
tmpdta
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/germanconscr.dta",tmpdta, mode = "wb")
a2dta <- read_dta(tmpdta)
a2dta
summary(a2dta)


#' download the German Prisoner / Bavarian Conscripts.dta
tmpdta <- tempfile()
tmpdta
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/germanprison.dta",tmpdta, mode = "wb")
a3dta <- read_dta(tmpdta)
a3dta
summary(a3dta)

#' Download Souteast DBF, using code line from https://www.rdocumentation.org/packages/foreign/versions/0.8-69/topics/read.dbf that is: read.dbf(file, as.is = FALSE)
#' installed foreign pkg successfully
tmp <- tempfile()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Heights_south-east/B6090.DBF",
         tmp, mode = "wb")
a4dbf <- read.dbf(tmp)
str(a4dbf)
summary(a4dbf)


#' download the BLS.csv
tmpcsv <- tempfile()
tmpcsv
tempdir()
download("https://github.com/hadley/r4ds/raw/master/data/heights.csv",tmpcsv, mode = "wb")
a5csv <- read_csv(tmpcsv)
a5csv
summary(a5csv)


#' download the Wisconsin Height Survey.sav
tmpsav <- tempfile()
tmpsav
tempdir()
download("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav",tmpsav, mode = "wb")
a6sav <- read_sav(tmpsav)
a6sav
summary(a6sav)


#' End of download

#'
#' ## [ ] Tidy the Worldwide estimates .xlsx file.
#' ###[ ] Make sure the file is in long format with year as a column. See here for an example of the final format.
#' ###[ ] Use the separate() and mutate() functions to create a decade column.

a1long <- a1xlsx %>%
  pivot_longer(c(`1800`:`2011`), names_to = "year_actual", values_to = "height.cm") 
a1long
str(a1long)
summary(a1long)



a1long

unique(a1long$year_actual)  #confirmed from 1800 to 2011 inclusive, no years missing.
unique(a1long$`Continent, Region, Country`)   #confirmed 286 different geo-entities.  Differing hierarchy-levels Continent region country. Does not appear to be any typo-dupes.

#' Separate year_decade into century, decade, year, while keeping year_decade
a1longyrsep <- a1long %>%
  separate(year_actual, into = c("century", "decade", "year"), sep = c(2,3), remove = FALSE) 
a1longyrsep

#' change year_actual, century, decade, and year to a numeric
a1longyrsep$year_actual <- as.numeric(a1longyrsep$year_actual)
a1longyrsep$century <- as.numeric(a1longyrsep$century)
a1longyrsep$decade <- as.numeric(a1longyrsep$decade)
a1longyrsep$year <- as.numeric(a1longyrsep$year)
a1longyrsep  #year_actual, century, decade, and year are now all dbl's


#' Convert from centimeters to inches, and keep both columns
#' install measurements package, load library
library(measurements)
a1longyrsepinch <- a1longyrsep 
a1longyrsepinch
  
a1longyrsepinch$height.in <- conv_unit(a1longyrsepinch$height.cm, "cm", "inch")  
a1longyrsepinch

unique(a1longyrsepinch$height.cm)
unique(a1longyrsepinch$height.in)

#' Use mutate/floor to convert the value (the actual year) in the year_decade column to the decade.  Essentially, round down to the nearest tens.
a1longyrsepinch$year_actual
a1longyrsepinchdec <- a1longyrsepinch

a1longyrsepinchdec$year_actual
a1longyrsepinchdec$year_actual <- as.numeric(a1longyrsepinchdec$year_actual)
a1longyrsepinchdec$year_actual
# add_column(a1longyrsepinchdec, year_decade = 10*floor(a1longyrsepinchdec$year_actual/10))

a1longyrsepinchdec <- mutate(a1longyrsepinchdec, year_decade = 10*floor(year_actual/10))    #shows the decade column

a1longyrsepinchdec  #NOTE: NEED TO HAVE ASSIGNMENT OPERATOR IN THE PREVIOUS LINE, to make the new column show up.

a1longyrsepinchdec$year_actual  #looks good
unique(a1longyrsepinchdec$year_decade)  #OK


a1longyrsepinchdec
a1final <- a1longyrsepinchdec
a1final



                                                                     
                                                                     
#'
#'## Combine 5 Year / Height Databases
#'### [ ] Import the other five datasets into R and combine them into one tidy dataset.
#'### [ ] This dataset should have the following columns - birth_year, height.cm, height.in, and study_id.


#'
#' ### Clean a2dta  (GermanConscipt)
str(a2dta)
#' keep bdec = Year,  height = height.cm, mutate to (because rename didnt work) birth_year & height.cm, create height.in using conversion, create study as a constant.
a2dta
a2a <- a2dta 
a2a <-  select(a2a, bdec,height)
a2a 
#a2b <- rename(a2a, height.cm = height)  # DID NOT WORK
a2b <- mutate(a2a, height.cm = height)   #new column height.cm
a2b
a2b$height.in <- conv_unit(a2b$height.cm, "cm", "inch")  #new column height.in
a2b
a2c <- add_column(a2b,study = "GermanConscr")
a2c
a2d <- mutate(a2c, birth_year = bdec)
a2d
#a2e <- rename(a2d, "birth_year" = "bdec")  # DID NOT WORK
a2e <- select(a2d,birth_year,height.in,height.cm,study)  #select and reorder columns
a2e


#' ### Clean a3dta  (GermanPrisoner)
str(a3dta)
#' keep bdec & height , mutate to (because rename didnt work) as birth_year & height.cm, create height.in using conversion, create study as a constant.
a3dta
a3a <- a3dta 
a3a <- select(a3a, bdec, height)
a3a 
#a3b <- rename(a3a, height.cm = height)  # DID NOT WORK
a3b <- mutate(a3a, height.cm = height)   #new column height.cm
a3b
a3b$height.in <- conv_unit(a3b$height.cm, "cm", "inch")  #new column height.in
a3b
a3c <- add_column(a3b,study = "GermanPrisoner")
a3c
a3d <- mutate(a3c, birth_year = bdec)
a3d
#a3e <- rename(a32d, "birth_year" = "bdec")  # DID NOT WORK
a3e <- select(a3d,birth_year,height.in,height.cm,study)  #select and reorder columns
a3e

#'
#' ### Clean a4dbf  (Southeast)
str(a4dbf)
#' keep SJ & CMETER , mutate to (because rename didnt work) as birth_year & height.cm, create height.in using conversion, create study as a constant.
a4dbf
a4a <- a4dbf 
a4a <- select(a4a, SJ, CMETER)
a4a 
#a4b <- rename(a4a, height.cm = CMETER)  # DID NOT WORK
a4b <- mutate(a4a, height.cm = CMETER)   #new column height.cm
a4b
a4b$height.in <- conv_unit(a4b$height.cm, "cm", "inch")  #new column height.in
a4b
a4c <- add_column(a4b,study = "Southeast")
a4c
a4d <- mutate(a4c, birth_year = SJ)
a4d
#a4e <- rename(a42d, "birth_year" = "SJ")  # DID NOT WORK
a4e <- select(a4d,birth_year,height.in,height.cm,study)  #select and reorder columns
a4e


#' ### Clean a5csv  (BLS)
#' [ ] The BLS wage data does not have birth information. Let’s assume it is mid-twentieth century and use 1950.
str(a5csv)
#' keep Height, assume year is 1850; mutate to (because rename didnt work) height.in, create height.cm using conversion, create year as 1850, create study as a constant.
a5a <- a5csv 
a5a <- select(a5a, height)
a5a 
#a5b <- rename(a5a, height.in = height)  # DID NOT WORK
a5b <- mutate(a5a, height.in = height)   #new column height.in
a5b
a5b$height.cm <- conv_unit(a5b$height.in, "inch" , "cm")  #new column height.cm
a5b
a5c <- add_column(a5b,study = "BLS")
a5c
a5d <- mutate(a5c, birth_year = "1850")
a5d
a5e <- select(a5d,birth_year,height.in,height.cm,study)  #select and reorder columns
a5e


#' ### Clean a6sav  (Wisconsin)
str(a6sav)
#' from codebook, find 'height'.  keep DOBY, RT216F (feet), and RT216I (inches), calculate inches, convert to cm, mutate to (because rename didnt work) doby to birth_year, create study as a constant.
a6a <- a6sav 
a6a <- select(a6a, DOBY, RT216F, RT216I)
a6a 
#a6b <- rename(a6a, height.in = height)  # DID NOT WORK
a6b <- mutate(a6a, height.in = ((RT216F*12) + RT216I))   #new column height.in
a6b
# need to check for typos, first line has 35 inches in RT216I (could be 3.5)
summary(a6b$height.in)
unique(a6b$RT216F)
unique(a6b$RT216I)
unique(a6b$height.in)
#' Seeing these spurious values, 

#' I would turn Inches = 35, 85,25,50,45 into 3.5,8.5,2.5,5.0,4.5.
#' I would turn Inches = -1,-2 into 1,2.
#' I would turn Feet = -1 and -2 into NAs.
a6c <- mutate(a6b, RT216I=case_when(
  RT216I == 35 ~ 3.5,
  RT216I == 85 ~ 8.5,
  RT216I == 25 ~ 2.5,
  RT216I == 50 ~ 5.0,
  RT216I == 45 ~ 4.5,
  RT216I == -1 ~ 1,
  RT216I == -2 ~ 2,
  TRUE ~ RT216I))
a6c
unique(a6c$RT216I)   #looks good for corrected inches
#' Now for correcting feet

#' Not Sure we want to chng to 0
#a6d <- mutate(a6c, RT216F=case_when(
#  RT216F == -1 ~ 0,
#  RT216F == -2 ~ 0,
#  TRUE ~ RT216F))
#a6d
#unique(a6d$RT216F)   

#'DOESN'T WORK
#a6e <- na_if(a6c$RT216F,-1)
#a6e
#unique(a6e$RT216F)  #Error in a6e$RT216F : $ operator is invalid for atomic vectors

#' Look at those rows with -1 or -2 in Feet column
a6f <- filter(a6c, RT216F == -1 | RT216F == -2)
a6f
#' Results in 6 rows with -1 in feet, and 1 in inches, or -2 in feet and -2 in inches.  We should delete these rows.
#' So, we filter out and keep all that are NOT RT216F == -1 | RT216F == -2 
a6g <- filter(a6c, RT216F != -1) #can't do composite OR with not equal
a6h <- filter(a6g, RT216F != -2)
a6h
unique(a6h$RT216F)


#' recalc composit inches
a6i <- mutate(a6h, height.in = ((RT216F*12) + RT216I))   #new column height.in
a6i

#' recalc cm from in
a6i$height.cm <- conv_unit(a6i$height.in, "inch" , "cm")  #new column height.cm
a6i


# Check AGAIN for typos, first line has 35 inches in RT216I (could be 3.5)
summary(a6i$height.in)
unique(a6i$RT216F)
unique(a6i$RT216I)
unique(a6i$height.in)
# looks good range from 50" to 81"


# fix DOBY, it apparently is only the last 2 digits, but what about 19 vs 20 as the first two digits?
unique(a6c$DOBY)
#got a mesage that -2 = Refused, -1 = Don't Know. Which is also mentioned in the Codebook.
a6f <- filter(a6c, DOBY == -1 | DOBY == -2)
a6f
#' Results in 5 rows with -1 or -2 in DOBY.  We should delete these rows.

a6j <- filter(a6i, DOBY != -1) #can't do composite OR with not equal
a6k <- filter(a6j, DOBY != -2)
a6k
unique(a6k$DOBY)   # values 1 thru 70, so we'll just unite a "19 in front of them. Since DOBY is a dbl, we'll numerically add 1900.
summary(a6k$DOBY)
a6l <- mutate(a6k, birth_year = 1900+DOBY)
a6l
a6m <- add_column(a6l,study = "Wisconsin")
a6m
a6n <- select(a6m,birth_year,height.in,height.cm,study)  #select and reorder columns
a6n

#'
#'### Bind the 5 Tables together


#'Hint for wrangling the Five Datasets
#' these should be the only four columns that you keep from each dataset.
#select(birth_year, height.in, height.cm, study)
#'
#' then use the following to combine your five individual measures into one dataset.
#' alldata <- bind_rows(a2e, a3e, a4e, a5e, a6n)   #but got error that birth_year were various types.

#'check variable type for birth_year in each of the 5 tables, change all to numeric
str(a2e$birth_year)    #num
str(a3e$birth_year)    #num
str(a4e$birth_year)    #int
str(a5e$birth_year)    #char
str(a6n$birth_year)    #num

a2e$birth_year <- as.numeric(a2e$birth_year)
a3e$birth_year <- as.numeric(a3e$birth_year)
a4e$birth_year <- as.numeric(a4e$birth_year)
a5e$birth_year <- as.numeric(a5e$birth_year)
a6n$birth_year <- as.numeric(a6n$birth_year)

str(a2e$birth_year)    #num
str(a3e$birth_year)    #num
str(a4e$birth_year)    #num
str(a5e$birth_year)    #num
str(a6n$birth_year)    #num

#' combine all five againinto one dataset.
alldata <- bind_rows(a2e, a3e, a4e, a5e, a6n)   #no error this time

str(alldata)
summary(alldata)


#'
#'##[ ] Save the two tidy datasets to your repository - 
#' The world country estimates and the row-combined individual measurements.
#' I'll save as RDS based on this advice https://www.r-bloggers.com/2019/05/how-to-save-and-load-datasets-in-r-an-overview/

getwd()   #"E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_07/analysis"
saveRDS(a1xlsx, file = "a1xlsx.Rds")
saveRDS(alldata, file = "alldata.Rds")
#' when you need to openRDS /load this use: data.copy <- readRDS(file = "data.Rds")


#'
#' Plot of Height x Decade from .XLS data, highlighting Germany-related datapoints


unique(a1final$`Continent, Region, Country`)
#" Three values related to Germany:"Federal Republic of Germany (until 1990)"  "German Democratic Republic (until 1990)"  "Germany"      

#' Create Germany subset
a1final
a1germany <- filter(a1final, a1final$`Continent, Region, Country` == "Federal Republic of Germany (until 1990)" | `Continent, Region, Country` ==  "German Democratic Republic (until 1990)" | `Continent, Region, Country` ==  "Germany")
a1germany



str(a1longyrsepinchdec$century)
str(a1longyrsepinchdec$decade)

#' Plot with all datapoints, no highlighting
library(ggplot2)
ggplot(data = a1longyrsepinchdec, mapping = aes(x = (century*100) + (decade*10), y = height.in), alpha = 1/1000) + #can't get alpha to work
  geom_point()


#'
#' ## PLOT 1 : Plot of XLSX data, highlighting 3 Germany-related datapoints in Red.
#' ### [ ] Make a plot with decade on the x-axis and height in inches on the y-axis with the points from Germany highlighted based on the data from the .xlsx file.
library(ggplot2)
ggplot() + 
  geom_point(data = a1longyrsepinchdec, mapping = aes(x = (century*100) + (decade*10) - 10, y = height.in)) +
  geom_point(data = a1germany, mapping          = aes(x = (century*100) + (decade*10) - 10, y = height.in), color = "red")
#'
#' ## PLOT 1 INSIGHTS : XLSX dataset : Humans Getting Taller? Germans Getting Taller? 
#' The data was from a wide range of countries around the world.  From 1810 to 1970, the mean seems to increase from about 65 to 67.5 inches.  Also, the range increases, likely the result of a more robust ability to sample in the far reaches of the increasingly civilized world.  The Germany-related datapoints in red are falling in real numbers and also falling in position within each decade's distributiuon from 1800 to 1840's.  The low point in the 1840's is consistent with the particularly difficult time politically and economically for Germany.  After the 1840's, Germany's real numbers and position in the distribution have consistently increased.  
#'

#'
#' ## PLOT 2 : Small-Multiples Plots of the Five Studies
#'### [ ] Make a small-multiples plot of the five studies to examine the question of height distribution across centuries.
alldata
library(ggplot2)
ggplot() +
  geom_point(data = alldata, mapping = aes(x = (10*floor(birth_year/10)), y = (height.in), color = study))
#'
#' ## PLOT 2 INSIGHTS : 5 Studys  : Humans Getting Taller?  
#' The graph shows more inforamtion about the scope of the studies than whether humans have been geting taller.  The might be a slight increase inside the Southeast study from years 1760 to 1790.  And there is dfintiely a reduced variation.  Teh BLS study shows a similar mean, but wider variation.  The German Conscripts and German Prisoners dataset shows a lower mean and less variation, but this may be attributable to the type of population adn how that population was selected in the first place.  The Wisconsin dataset shows the widest variation and prhaps a higher mean.     

#' Small-multiples faceting doesn't help in comparison.
alldata
library(ggplot2)
ggplot() +
  geom_point(data = alldata, mapping = aes(x = (10*floor(birth_year/10)), y = (height.in), color = study)) +
  facet_wrap(vars(study), nrow = 1) 
#  geom_hline(data = alldata, mapping = aes( yintercept = mean(height.in), color = study)) 

#' DOES NOT WORK  
#'#' Try creating some group means with group = study
#'alldata
#'unique(alldata$study)
#'alldatagrpdmean <- group_by(alldata, study, decade)  
#'summarise(alldatagrpdmean, studymean = mean(height.in, na.rm = TRUE)) # Produce the mean for each study

#'alldatagrpdmean
#'
#' from Chap 5 example
#'by_yr <- group_by(alldata, birth_year)
#'summarise(by_yr, yrmean = mean(height.in, na.rm = TRUE))


