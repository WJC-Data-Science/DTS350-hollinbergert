#' ---
#' title: "Task 12 : Tidy Data"
#' author: "TomHollinberger"
#' date: "10/06/2020"
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
library(dplyr)
library(readxl)
library(devtools)
library(downloader)

tmp <- tempfile()

tmp

tempdir()
download("https://github.com/WJC-Data-Science/DTS350/raw/master/messy_data.xlsx",tmp, mode = "wb")

grades <- read_xlsx(tmp)

grades
summary(grades)


#'_________________________
#'
#'
#'
grades <- read_xlsx(tmp, skip = 2, col_names = FALSE)
grades

grades1 <- select(grades,1:17)
grades1


grades1 <- add_column(grades, v = "CS241", .after = "...2")
grades1

grades2 <- add_column(grades1, w = "CS450", .after = "...5")
grades2

grades3 <- add_column(grades2, x = "MATH325", .after = "...8")
grades3

grades4 <- add_column(grades3, y = "MATH335", .after = "...11")
grades4

grades5 <- add_column(grades4, z = "MATH425", .after = "...14")
grades5

grades6 <- grades5 %>%
unite(pnl1,3,4,5,6, sep = "_")   #apparently uses column poitions, not column names, AND the individual columns are deleted, leaving only the united column, and ...6 column numbers are rewickered.
grades6$pnl1
str(grades6)

grades7 <- grades6 %>%
  unite(pnl2,4:7, sep = "_")   #apparently uses column poitions, not column names
grades7$pnl2
str(grades7)

grades8 <- grades7 %>%
  unite(pnl3,5:8, sep = "_")   #apparently uses column poitions, not column names
grades8$pnl3
str(grades8)

grades9 <- grades8 %>%
  unite(pnl4,6:9, sep = "_")   #apparently uses column poitions, not column names
grades9$pnl4
str(grades9)


grades10 <- grades9 %>%
  unite(pnl5,7:10, sep = "_")   #apparently uses column poitions, not column names
grades10$pnl5
str(grades10)

grades11 <- grades10 %>%
  pivot_longer(c(pnl1,pnl2,pnl3,pnl4,pnl5), names_to = "pnlnbr", values_to = "CMSF") 
grades11

grades12 <- grades11 %>%
  separate(CMSF, into = c("Course Number","Major at Begin of Term","Semester","Final Grade"), sep = "_")
grades12

#'DOESNT WORK
#'grades13 <- grades12 
#'  gsub("pnl3","",grades13)
#'grades13
#'

#'----
#'
#'?gsub
#'DOESNT WORK
#'grades13 <- grades12 %>%
#'na.omit(grades13, cols=c("Course Number","Major at Begin of Term","Semester","Final Grade"))
#'grades13

#'----
#'
#'DOESNT WORK
#
#'grades13 <- grades12 %>%
#'  complete("Course Number","Major at Begin of Term","Semester","Final Grade")
#'grades13
#'----
#'
grades13 <- grades12 %>%
  filter(`Final Grade` != "NA")
grades13


#'----
#' ## Top 20 Rows of Data
head(grades13, 20)

#' ## Visualization :  Grade Distribution for Five R and Python Courses
ggplot(grades13, aes(x = `Final Grade`)) +
  geom_bar(position = position_dodge()) +  #makes it clustered side by side
  theme_bw() +
  facet_wrap(~ `Course Number`, nrow = 1) +
  coord_cartesian(ylim = c(0,150) ) +
  scale_y_continuous(breaks = seq(from = 0, to = 200, by = 50)) 
#'
#' ## Insight :  
#' Lots of A's in these courses.  Also, CS241 and MATH325 have a higher proportion of A's and F's.  Assuming these are the intro courses, that would make sense because of students who are new to the material washing out of the course.  That also explains the higher proportion of A's because other students come in already knowing the material.  The grade distribution and the total counts of the higher level classes (CS450 & MATH425) have fewer A's and F's, as would be expected for tougher, completely-new-to-all-students material and a cadre of students from whom the weaker students have already been washed out.  We would need to percentize each course's grade distribution in and of itself, then compare to other non R or Python courses to say whether the courses are effecting the students worse or better than other courses.





#'</br></br>
#'
#' ##### Scratch Material after this point


#'
ggplot(grades13, aes(x = `Final Grade`, fill = `Course Number`)) +
  geom_bar(position = position_dodge()) +  #makes it clustered side by side
  theme_bw() +
  coord_cartesian(ylim = c(0,150) ) +
  scale_y_continuous(breaks = seq(from = 0, to = 200, by = 50)) 
#'
#' 
#'  
#'   
#' BUT they aren't scaled well. And maybe facet


#' 
#'
#'  Need to percentize this  https://sebastiansauer.github.io/percentage_plot_ggplot2_V2/
#'  Still Not percentized

ggplot(grades13, aes(`Final Grade`)) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels=scales::percent) +
  facet_wrap(~ `Course Number`, nrow = 1) +
  ylab("relative frequencies")



#'Let's try faceted pie charts'


pie <- ggplot(grades13, aes(x = "", fill = `Final Grade`)) +
  geom_bar(width = 1)  +
  facet_wrap(~ `Course Number`, nrow = 1) 
pie + coord_polar(theta = "y", start = 0)

#'Still percentized to the base of MATH325
#'
#' Try a tree map from the Top 50   DOESN"T WORK
#' 




#'library(treemapify)
#'treeMapCoordinates <- treemapify(grades13,
#'  area = `Final Grade`,
#'  fill = `Course Number`,
#'  label = `Final Grade`,
#'  group = `Course Number`)
#'  
#'treeMapPlot <- ggplotify(treeMapCoordinates)
#' print(treeMapPlot)


#'??ggplotify  #   DOESN'T EXIST'



