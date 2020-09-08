library(tidyverse)
library(dplyr)
iris

#1 Arrange the iris data by Sepal.Length and display the first six rows.
iris
sorted <- arrange(iris, Sepal.Length)
head(sorted)

#2 Select the Species and Petal.Width columns and put them into a new data set called testdat.
testdat <- select(iris,Species,Petal.Width)
testdat

#3 Create a new table that has the mean for each variable by Species.
# info on tables from https://www.cyclismo.org/tutorial/R/types.html
#use the pipe from 5.6.1
##this gets error message, just like what is in the textbook 5.6.1
byspecies <- (iris) %>%
  group_by(Species) %>%
  summarise(
    meanSL = mean(Sepal.Length, na.rm = TRUE),
    meanSW = mean(Sepal.Width, na.rm = TRUE),
    meanPL = mean(Petal.Length, na.rm = TRUE),
    meanPW = mean(Petal.Width, na.rm = TRUE)
  )
  
##
#THis works but doesn't create table
iris %>% 
  group_by(Species) %>% 
  summarise(meanSL = mean(Sepal.Length, na.rm = TRUE),
            meanSW = mean(Sepal.Width, na.rm = TRUE),
            meanPL = mean(Petal.Length, na.rm = TRUE),
            meanPW = mean(Petal.Width, na.rm = TRUE))

##

#4 Read about the ?summarize_all() function and get a new table with the means and standard deviations for each species.

iris %>% 
  group_by(Species) %>% 
  summarise(meanSL = mean(Sepal.Length, na.rm = TRUE),
            meanSW = mean(Sepal.Width, na.rm = TRUE),
            meanPL = mean(Petal.Length, na.rm = TRUE),
            meanPW = mean(Petal.Width, na.rm = TRUE),
            stdevSL = sd(Sepal.Length, na.rm = TRUE),
            stdevSW = sd(Sepal.Width, na.rm = TRUE),
            stdevPL = sd(Petal.Length, na.rm = TRUE),
            stdevPW = sd(Petal.Width, na.rm = TRUE))



            
?summarize_all()

##This works, but doesn't create a table, and has clunky variable names
# If you want to apply multiple transformations, pass a list of
# functions. When there are multiple functions, they create new
# variables instead of modifying the variables in place:
by_species %>%
  summarise_all(list(mean,sd))

??sd
??%in%

##Notes to self

#Start up Rstudio
#Start up NEW PROJECT  top right c/o Project, New project, New directory, 
#name it 3Task or 2CaseStudy etc, browse to course folder on e:drive, 
#checkbox create a git repository, create project.
#
#Open RMArkdown.
#File > New File > R Markdown
#Title it 3Task or 2CaseStudy etc, rightpanel=Document, Radio button = HTML. OK
#
#SAVE RMD save the nascent RMD -- File, Save, make filename same as title, OK,  
#Now the tab should say 3Task.rmd
#
#KNIT RMD knit the nascent RMD -- knit button on top bar, or 
#File > Knit > name it the same as Rscript and RMD, Output=HTML, Compile.
#THe HTML product will pop-up.  X out at top right.  
#GO back to RMD tab.  
#C/o Gear next to the knit icon / Output Options / Advanced / Keep markdown source file
#This refers to the md file, and clicking OK automatically changes the YAML (top section ofthe RMD)
#by adding "keep_md: yes".  It also opens the HTML product again, X out at top right.
#GO back to RMD tab. 
#
#Delete all of the boilerplate below the YAML.
#
#Insert Code Chunk using ctrl+alt+I or the C-Insert icon in the top bar (Insert, R)
#this inserts a grayed-out coule of lines where you can paste code that you copy from the Rscript tab.
#
#Run Code -- when you are in RMD, in the gray box, you can run that code by 
#clicking the Run icon on the top bar-right or ctrl+enter
#the results of the code show up just below the grayed box, and also in the console (bottom-left panel)
#
#
#Save, Knit, Render, Commit often to create fallback positions.
#
#Publish button top bar - right, manage / accounts / git/svn
#
#
#
#SNIPPET JPGS
#Preload some template lines in the rmd  ![Snippet1](1.jpg),![Snippet2](2.jpg),![Snippet3](3.jpg)
#you'll get lots of errors saying the it can't find the jpg.
#Go about your business, when you want to take a screen shot and paste it into the rmd,
#just take the snippet, save the snippet to the rmd project folder, and name it 1.jpg or 2.jpg,3.jpg,etc
#In a few seconds a thumbnail of the snippet will show up in the rmd screen under the ![Snippet2](2.jpg)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
##