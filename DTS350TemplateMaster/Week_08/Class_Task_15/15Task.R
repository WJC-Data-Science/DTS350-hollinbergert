#' ---
#' title: "Task 15 : Take Me Out to the Ballgame"
#' author: "TomHollinberger"
#' date: "10/15/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    code_folding:  hide
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_08/Class_Task_15/


library(tidyverse)
library(readr)
library(haven)
library(readxl)
library(downloader)  
library(dplyr)
library(foreign)  #for read.dbf
#' install Lahman and blscrapeR
library(Lahman)
library(blscrapeR)

  
#'[ ] Take notes on your reading of the specified ‘R for Data Science’ chapter in the README.md or in a ‘.R’ script in the class task folder.

  
#'[ ] Install the library(Lahman) and examine the available data sets available.


#'[ ] Find the 4-5 different data sets that you will need to show full college and player names as well as their annual earnings. You might want to draw a diagram to show how the data sets are related.
str(Schools)
str(CollegePlaying)
str(People)
str(Salaries)
str(Teams)

#'Find Primary Keys for each
Schools %>%
  count(schoolID) %>%
  filter(n > 1)
#' Result: <0 rows> (or 0-length row.names)  which means it's the primary key
#'   
CollegePlaying %>%
  count(playerID, schoolID, yearID) %>%
  filter(n > 1)
#' Result: <0 rows> (or 0-length row.names)  which means it's the COMPOSITE primary keylibrary(Lahman)
#'   
People %>%
count(playerID) %>%
  filter(n > 1)
#' Result: <0 rows> (or 0-length row.names)  which means it's the primary key
#'   
Salaries %>%
count(playerID, yearID, teamID) %>%
  filter(n > 1)
#' Result: <0 rows> (or 0-length row.names)  which means it's the COMPOSITE primary key
#'  
Teams %>%
count(yearID, teamID) %>%
  filter(n > 1)
#' Result: <0 rows> (or 0-length row.names)  which means it's the COMPOSITE primary key
#'    
#' Create a table for Inflation adjustment factors
#' [ ] Install the library(blscrapeR) and use the inflation_adjust(2017) function to get all earnings in 2017 dollars.
library(blscrapeR)

bls <- inflation_adjust(2017)
#'View(bls)
bls <- mutate(bls,salyr = year)
bls <- mutate(bls,divisortoget2017 = adj_value)
bls   #salyr will be the key to link to Salaries
#'
#' will eventually take then-year-sal and divide by divisortoget2017 from bls to get equivalent 2017-dollars.
#' 
#' Cut and Paste these into excel database schematic.  Column-to-text to extract the Vsar name.
#' Create the database diagram with the dataframe that you need to create to answer the question in the middle.
#'See 15Task DB Schematic.xls
#'  
#' 
#' Remove all variables except for Primary keys and desired-answer variables
tms <- select(Teams, teamID, yearID, name)
tms
schl <- select(Schools, schoolID, name_full, state)
schl
cpg <- CollegePlaying
cpg
sals <- select(Salaries, yearID, teamID, playerID, salary)
sals 
ppl <- select(People, playerID, nameFirst, nameLast)
ppl
bls
bls <- select(bls, salyr,divisortoget2017)
bls
bls$salyr <- as.numeric(bls$salyr)  #needs to be similare var type as other instances of salyr (num)
str(bls)

#' Join into a dataframe needed to answer the question 
#' 
#' Add the full team name to our salary data set   
saltm <- sals %>%
  left_join(tms) 
head(saltm) 
saltm <- mutate(saltm,salyr = yearID)  #chg yearID to salyr to deconflict with colyr
head(saltm)

#' Add divisortoget2017 to salary data set   
saltminfl <- saltm %>%
  left_join(bls) 
head(saltminfl)
saltminfl <- mutate(saltminfl, sal2017 = salary/divisortoget2017)  #apply the divisor to create equivalent 2017 salary
head(saltminfl)

#' Add the full school name to our college playing   
cpgschl <- cpg %>%
  left_join(schl) 
head(cpgschl)
cpgschl <- mutate(cpgschl,colyr = yearID)  #chg yearID to colyr to deconflict with salyr
head(cpgschl)
cpgschlmo <- filter(cpgschl, state == "MO")  #filter for only Missouri schools
head(cpgschlmo)


#'Join People with College Playing/School, natural join should key on playerID
pplcpgschlmo <- ppl %>%
  left_join(cpgschlmo) 
head(pplcpgschlmo) 



#'Join People/CollegePlaying/School with Salaries/Team, 
pplcpgschlmosaltm <- pplcpgschlmo %>%
  left_join(saltminfl, by = "playerID") 
head(pplcpgschlmosaltm) 
pplcpgschlmosaltm <- filter(pplcpgschlmosaltm, state == "MO")
head(pplcpgschlmosaltm)


players <- select(pplcpgschlmosaltm, nameFirst, nameLast, name_full, colyr, sal2017, name, salyr)
head(players)
playersinsalaryorder <- arrange(players, desc(sal2017),desc(salyr),desc(colyr))
playersinsalaryorder <-  select(playersinsalaryorder, nameFirst,nameLast,sal2017,name,salyr,name_full,colyr)
head(playersinsalaryorder)
         
#' 
#' 
#' [ ] Make a plot showing how professional baseball player earnings that played baseball at YOUR FAVORITE SCHOOL compared to the players from other Missouri schools.
#'
#'## **Which Missouri School Produces the Best Baseball Players?**
#'### Many Missouri schools have contributed to the game of baseball.  <br/>
#'#### **The Big 4** are Jefferson College, Maple Woods Community College, Missouri State University, and University of Missouri Columbia.
#'
p <- ggplot(data = playersinsalaryorder, mapping = aes(x = salyr, 
                                       y = sal2017, 
                                       color = name_full)) +
  geom_point() +
  labs(x = "Years of Professional Play",
       y = "Salary in 2017 dollars",
       title = "Major League Salaries and the Missouri Schools They Came From",
       color = "School") + 
  theme(plot.title = element_text(hjust = .5)) +
  theme_bw() +
  facet_wrap(~ name_full, nrow = 5, ncol = 5) +
  theme(legend.position = "bottom") 
p
ggsave("BBPlot1.png", width = 15, height = 10, units = "in")  #saves to the project folder, overwrites without asking 

#'

# Plotting the Big4 and Adding an Average Line:  First, do you have the right packages loaded to computed averages? Then calculate the averages:
library(dplyr)
Big4Players <- filter(playersinsalaryorder, name_full == "Jefferson College" | name_full == "Maple Woods Community College" | name_full == "Missouri State University" | name_full == "University of Missouri Columbia")
Big4Players

# pipe on page 5.13,  group_by and summarise on pg 5.11
averages <- Big4Players %>%    #pg 5.13
  group_by(name_full) %>% 
  summarise(avgsal = mean(sal2017, na.rm = TRUE))
averages

#' ### This plot shows the number of occurrences when a school produced a player, playing in a particular season.  The horizontal line shows the average for all players from that school. 
ggplot(data = Big4Players, mapping = aes(x = salyr, 
                                              y = sal2017, 
                                              color = name_full)) +
  geom_point() +
  labs(x = "Years of Professional Play",
       y = "Salary in 2017 dollars",
       title = "Major League Salaries and the Missouri Schools They Come From",
       subtitle = "The Big 4, with average salary",
              color = "School") + 
  theme(plot.title = element_text(hjust = .5)) +
  theme_bw() +
  facet_wrap(~ name_full, nrow = 1) +
  geom_hline(data = averages, mapping = aes( yintercept = avgsal, color = name_full))   #pg3.8
ggsave("BBPlot2.png", width = 8, units = "in")


#'### This plot zooms in on the top dollar bracket, to see which school produced the highest paid player.
ggplot(data = Big4Players, mapping = aes(x = salyr, 
                                         y = sal2017, 
                                         color = name_full)) +
  geom_point() +
  labs(x = "Years of Professional Play",
       y = "Salary in 2017 dollars",
       title = "Major League Salaries and the Missouri Schools They Come From",
       subtitle = "The Big 4 -- Zoomed-In on the Top Dollar Bracket",
       color = "School") + 
  theme(plot.title = element_text(hjust = .5)) +
  theme_bw() +
  facet_wrap(~ name_full, nrow = 1) +  
  coord_cartesian(ylim = c(20000000, 26000000))
ggsave("BBPlot3.png", width = 8, units = "in")


#' ### In summary,<br/> **Missouri State University** barely edges out Maple Woods Community College for the **highest paid individual** player.<br/><br/> But **Maple Woods Community College** takes the honors for the **highest average** salary. <br/><br/> And **University of Missouri Columbia** barely takes the prize for producing the **most players** who have contributed to the game.
#' [ ] Create a report in an .Rmd file with your code hidden but with reproducible data that explains your conclusions and includes your graphic. Save your .Rmd, .md, .html and .R script and image to your repository.


#' ### Notes on Chap 13
#'Chapter 13 notes 
#'primary key uniquely identifies each row in a table.
#'foreign key uniquely identifies a row in another table. 
#'Cool way of counting to see if a particular variable or combination are the key primary. 
#'Joins. Similar to SQL 
#'left join gives an additional variable which essentially adds a column .
#'could achieve the same thing with a mutate .
#'good diagrams describing left, right, inner, and full  joins .
#'You can name a character to be equal in a join , sort of like a conditional statement .
#'Merge can accomplish a similar process ,
#'Filtering joins include semi join which keeps all observations that match ,
#'and anti joins which drops all observations that match .
#'Set operations include intersect, union, and set difference .




