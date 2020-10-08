#' ---
#' title: "Task 13: Same Data Different Format and Tidy"
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

#'
#'[ ] Use the appropriate functions in library(readr), library(haven), library(readxl) to read in the five files found on GitHub.
#'[ ] Use read_rds(url("WEBLOCATION.rds")) to download and read the .rds file type.
#'[ ] Use the library(downloader) R package and use the download(mode = "wb") function to download the xlsx data as read_xlsx() cannot read files from the web path.
#'[ ] Use the tempfile() function to download and save the file.
#'Files are   
#' .rds   use read_rds 
#' .csv   use read_csv
#' .dta   use read_dta
#' .sav   use read_sav  from the haven package   https://haven.tidyverse.org/
#' .xlsx  use downloader


#' download the .rds
#' DIDN'T WORK
#' tmp <- tempfile()
#' tmp
#'tempdir()
#'download(url("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS", tmp))
#'dowrdsz <- read_rds(tmp)
#'dowrdsz
#'summary(dowrdsz)


#'This Worked
#' Download the RDS.  To get the link, I went thru these steps, click link in moodle to github repo, double clicked on filelink, which opens another page with a download button, I rightclicked on the download button and copylink. Paste in this r-script codeline. 
dowrds <- read_rds(url("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS"))
dowrds
summary(dowrds)




#'Movie1 <- read_rds(url("https://github.com/WJC-Data-Science/DTS350/raw/master/Boxoffice_Movie_Cost_Revenue.RDS"))
#' Movie2 <- read_dta("https://github.com/WJC-Data-Science/DTS350/raw/master/Boxoffice_Movie_Cost_Revenue.dta")

#'This worked  but in github, had to click on the file, then open new page, and rightclick the raw button and copylink
#' download the .csv
tmpcsv <- tempfile()
tmpcsv
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv",tmpcsv, mode = "wb")
dowcsv <- read_csv(tmpcsv)
dowcsv
summary(dowcsv)


#'This worked  but in github, had to click on the file, then open new page, and rightclick the raw button and copylink
#' download the .dta
tmpdta <- tempfile()
tmpdta
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.dta",tmpdta, mode = "wb")
dowdta <- read_dta(tmpdta)
dowdta
summary(dowdta)

#' download the .sav
tmpsav <- tempfile()
tmpsav
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.sav",tmpsav, mode = "wb")
dowsav <- read_sav(tmpsav)
dowsav
summary(dowsav)

#' download the .xlsx
tmpxlsx <- tempfile()
tmpxlsx
tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.xlsx",tmpxlsx, mode = "wb")
dowxlsx <- read_xlsx(tmpxlsx)
dowxlsx
summary(dowxlsx)

#'[ ] Check that all five files you have imported into R are in fact the same with all_equal(). You might need to include convert = TRUE in the function. Read about the function for more information.
#'dowrds  dowcsv  dowdta   dowsav   dowxlsx
#' Compare all 5, using dowrds as the baseline, and using convert = TRUE to have all_equal convert the variable types to be similar
all_equal(dowrds, dowcsv, convert = TRUE)   # answer is TRUE, so dowrds & dowcsv are all completely the same.
all_equal(dowrds, dowdta, convert = TRUE)   # answer is TRUE, so dowrds & dowcsv & dowdta  are all completely the same.
all_equal(dowrds, dowsav, convert = TRUE)   # answer is TRUE, so dowrds & dowcsv & dowdta & dowsav are all completely the same.
all_equal(dowrds, dowxlsx, convert = TRUE)  # answer is TRUE, so dowrds & dowcsv & dowdta & dowsav & dowxlsx are all completely the same.

#'check out the data
str(dowrds)  #three vars  contest_period (char), variable (char), value (dbl)
unique(dowrds$contest_period)  #there are 100 timeslots  "January-June1990" six month brackets, rolling forward one month at a time, thru April-September1998.
unique(dowrds$variable)
summary(dowrds$value)


#'[ ] Use one of the files to make a graphic showing the performance of the Dart, DJIA, and Pro stock selections.
ggplot(dowrds, aes(contest_period, value)) +
  geom_point(aes(colour = variable)) +
  labs(
    x = "Contest Period",
    y = "Dow Value",
    colour = "variable"
  )

#But need to date-ize the x axis conest_period to then be able to produce a connected scatterplot https://www.r-graph-gallery.com/connected_scatterplot_ggplot2.html 





#'[ ] Include a boxplot, the jittered returns, and the average return in your graphic

averages <- dowrds %>%    #pg 5.13
  group_by(variable) %>% 
  summarise(avgvalue = mean(value))
averages

ggplot(dowrds, aes(factor(variable), value)) +    
  geom_boxplot() +
  geom_jitter() +
  geom_hline(data = averages, mapping = aes( yintercept = avgvalue, color = variable)) +
  facet_wrap(~ variable, nrow = 1) +
theme(axis.text.x = element_blank())          




#'[ ] Tidy the data.
#'[ ] The contest_period column is not “tidy”. We want to create a month_end and year_end column from the information it contains.
#'Strip off the Year -- position-delimited
dowrds2 <- dowrds %>%
  separate(contest_period, into = c("Beg_End", "year_end"), sep = -4)  #position-delimited 4th from end, pull off last 4 digits
head(dowrds2)

#'Strip off the End Month -- character-delimited
dowrds3 <- dowrds2 %>%
  separate(Beg_End, into = c("month_beg", "month_end"), sep = "-")  #position-delimited 4th from end, pull off last 4 digits
head(dowrds3)

# Fix typos:  (seen in a table in future steps) Dec. needs to become December, Feuary needs to become February.
dowrds3 <- dowrds3 %>%
  mutate(month_end = replace(month_end, month_end == "Dec.", "December"))
dowrds3 <- dowrds3 %>%
  mutate(month_end = replace(month_end, month_end == "Febuary","February"))

head(dowrds3)  




#'[ ] Save your “tidy” data as an .rds object.
dowrds4 <- select(dowrds3,"month_end","year_end","variable","value")
dowrds4
write_rds(dowrds4,"E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_07/Class_Task_13/dowrds4.rds")



#'[ ] Create a plot that shows the six-month returns by the year in which the returns are collected.
#' By month and year on the x axis, values on the y, 3 tracks corresponding to the 3 variables?



library(DataCombine)

# Create original data
ABData <- data.frame(a = c("London, UK", "Oxford, UK", "Berlin, DE",
                           "Hamburg, DE", "Oslo, NO"),
                     b = c(8, 0.1, 3, 2, 1))

# Create replacements data frame
Replaces <- data.frame(from = c("January","February","March","April","May","June","July","August","September","October","November","December"), to = c(01,02,03,04,05,06,07,08,09,10,11,12))

# Replace patterns and return full data frame
dowrds4

dowmonbr <- FindReplace(data = dowrds4, Var = monthnbr, replaceData = Replaces,
                       from = "from", to = "to", exact = FALSE)
dowmonbr

# Replace patterns and return the Var as a vector
ABNewVector <- FindReplace(data = ABData, Var = "a", replaceData = Replaces,
                           from = "from", to = "to", vector = TRUE)






#'[ ] Create a table using code of the DJIA returns that matches the table shown below (“spread” the data).
#' https://www.guru99.com/r-dplyr-tutorial.html

#' Gives a table, but need to solve the Month alpha sort vs chron sort problem
x <- c("January","February","March","April","May","June","July","August","September","October","November","December")

dowrds4Chron <- arrange(dowrds4, factor(month_end, levels = x))
dowrds4Chron

dowrds4ChronDJIA <- dowrds4Chron %>%
  filter(variable == "DJIA")
dowrds4ChronDJIA

spread(dowrds4ChronDJIA,year_end,value)




#'-----Doesn't Work
x <- c("January","February","March","April","May","June","July","August","September","October","November","December")
dowrds4DJIA <- dowrds4Chron %>%
  filter(variable == "DJIA")
dowrds4DJIA
dowrds4DJIAChron <- arrange(dowrds4DJIA, factor(month_end, levels = x))
dowrds4DJIAChron
spread(dowrds4DJIAChron,year_end,value)

#'----Doesn't Work
spread(dowrds4DJIAChron,year_end,value)
x <- c("January","February","March","April","May","June","July","August","September","October","November","December")
dowrds4DJIA <- dowrds4Chron %>%
  filter(variable == "DJIA")
dowrds4DJIA
dowrds4DJIAChron <- arrange(dowrds4DJIA, factor(month_end, levels = x))
dowrds4DJIAChron
spread(dowrds4DJIAChron,year_end,value)



#'[ ] Include your plots in an .Rmd file with short paragraph describing your plots. Make sure to display the tidyr code in your file.
#'[ ] Push your .Rmd, .md, and .html to your GitHub repo
#'
#'
#' Scratch and Wasted Effort
#'
#'







#' from Top 50 ggplot2 ...
#' but need to put dates in the yy-mm-dd format
dowrds4
dowrds4 <- dowrds4 %>%
  dowrds4
unite(yymmdd,5:8, sep = "_")   #apparently uses column poitions, not column names






#' DOESN'T WORK 
dowrds4 <- mutate(dowrds4, monthnbr = month_end)
dowrds4
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "January", 01))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "February", 02))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "March", 03))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "April", 04))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "May", 05))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "June", 06))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "July", 07))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "August", 08))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "September", 09))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "October", 10))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "November", 11))
mutate(dowrds4, monthnbr = replace(monthnbr, monthnbr == "December", 12))
head(dowrds4)  







library(ggplot2)
library(lubridate)
theme_set(theme_bw())

#' DOWRDS4 is already in long form
#' df <- economics_long[economics_long$variable %in% c("psavert", "uempmed"), ]
#' df <- df[lubridate::year(df$date) %in% c(1967:1981), ]

economics_long
economics

# labels and breaks for X axis text
brks <- dowrds4$month_end[seq(1, length(dowrds4$month_end), 12)]
lbls <- lubridate::month(brks)

# plot
ggplot(dowrds4, aes(x=month_end)) + 
  geom_line(aes(y=value, col=variable)) + 
  labs(title="Time Series of Returns Percentage", 
       subtitle="Drawn from Long Data format", 
       caption="Source: Economics", 
       y="Returns %", 
       color=NULL) +  # title and caption
  scale_x_date(labels = lbls, breaks = brks) +  # change to monthly ticks and labels
  scale_color_manual(labels = c("DARTS", "DJIA","PROS"), 
                     values = c("DARTS"="Red", "DJIA" = "Green","PROS" = "Blue")) +  # line color
  theme(axis.text.x = element_text(angle = 90, vjust=0.5, size = 8),  # rotate x axis text
        panel.grid.minor = element_blank())  # turn off minor grid


#' Doesn't Work ---------
library(DataCombine)

# Create original data
ABData <- data.frame(a = c("London, UK", "Oxford, UK", "Berlin, DE",
                           "Hamburg, DE", "Oslo, NO"),
                     b = c(8, 0.1, 3, 2, 1))

# Create replacements data frame
Replaces <- data.frame(from = c("January","February","March","April","May","June","July","August","September","October","November","December"), to = c(01,02,03,04,05,06,07,08,09,10,11,12))

# Replace patterns and return full data frame
dowrds4

dowmonbr <- FindReplace(data = dowrds4, Var = monthnbr, replaceData = Replaces,
                        from = "from", to = "to", exact = FALSE)
dowmonbr

# Replace patterns and return the Var as a vector
ABNewVector <- FindReplace(data = ABData, Var = "a", replaceData = Replaces,
                           from = "from", to = "to", vector = TRUE)


