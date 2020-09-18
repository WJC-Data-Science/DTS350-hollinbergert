#' ---
#' title: "3CaseStudy"
#' author: "TomHollinberger"
#' date: "9/8/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'  
#' ---
# /* watch out for copy and pasted dblquotemarks, also need space after #' */

#'## **Case Study 3**
#'### [1 ] Download the **CensusAtSchool.csv** file from Moodle and import into an R script.
library(tidyverse)  #has function to read files
#First, need to go into excel and strip-off the last two lines, which are file path 
df_orig <- read_csv("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_03/3CaseStudy/CensusAtSchool.csv")

str(df_orig)

#'### [2 ] Create a new data frame called **df_inch** which converts all of the measurements given in centimeters to inches.
df_orig
df_inch <- df_orig
df_inch <- mutate(df_inch,Height = Height/2.54, Foot_Length = Foot_Length/2.54, Arm_Span = Arm_Span/2.54 )
# have to put df_inch <- in front of mutate, for it to stick in the dataframe.
head(df_inch, n = 10)


#'### [3 ] Create a new data frame called **df_environment** which selects scores > 750 : 
#' from the original data set only those rows that list **at least a 750 score** 
#' in **any** of the importance columns and has the rows ordered from **youngest to oldest**.
df_environment <- filter(df_inch, Importance_reducing_pollution >= 750 | Importance_recycling_rubbish >=750 |	Importance_conserving_water	>=750 | Importance_saving_enery >=750 | Importance_owning_computer >=750 |	Importance_Internet_access >=750)
#Would be nice if I could filter ColName starts with import and CellValue >=750"
#View(df_environment)
df_environment <- (arrange(df_environment, Ageyears))
df_environment
head(df_environment, n = 10)

#'### [4 ] Create a new data frame called **df_extra** which does not include any of the importance columns from the origonal data set.
df_extra <- select(df_orig, Country,	Region,	Gender,	Ageyears,	Handed,	Height,	Foot_Length,	Arm_Span,	Languages_spoken,	Travel_to_School,	Travel_time_to_School,	Reaction_time,	Score_in_memory_game,	Favourite_physical_activity)
#would be nice to be able to "filter if NOT start with Import..."
#easy to copy and paste column headers from excel, then insert commas
head(df_extra, n = 10)


#'### [5 ] Create a new data frame called **df_numbers** which comes from the original data set and...
#'gives for each country the number of males in the sample from that country.
#'the number of females in the sample from that country.
#'the average score of all of the importance columns for each country. (Decide on a convention for the empty responses.)

df_numbers <- df_orig
df_numbers <- group_by(df_numbers,Country,Gender)
df_numbers <- summarise(df_numbers, count = n(), mean(Importance_reducing_pollution), mean(Importance_recycling_rubbish), mean(Importance_conserving_water), mean(Importance_saving_enery), mean(Importance_owning_computer), mean(Importance_Internet_access))
head(df_numbers, n = 10)


#'### [6 ] Create a new data frame called **df_gender** which comes from the original data set and... 
#'gives for each country and each gender the average score of each of the importance columns.
#'the standard deviation for each importance column order the columns so it is 
#'country, gender, importance_reducing_pollution, mean_reducing_pollution, 
#'standdev_reducing_pollution, importance_recycling_rubbish, 
#'mean_recycling_rubbish, standdev_recycling_rubbish, etc.
df_orig
df_CountryGenderImportances <- select(df_orig, Country, Gender, Importance_reducing_pollution, Importance_recycling_rubbish, Importance_conserving_water, Importance_saving_enery,	Importance_owning_computer,	Importance_Internet_access)
head(df_CountryGenderImportances, n = 10)

df_CountryGenderGrp <- group_by(df_CountryGenderImportances, Country, Gender)
df_CountryGenderGrp
df_CountryGenderGrpSum <- summarise(df_CountryGenderGrp)
#View(df_CountryGenderGrp)
df_CountryGenderGrpSum <- summarise(df_CountryGenderGrp,
#                       Count_reducing_pollution = sum(!is.na(Importance_reducing_pollution)), 
                       Mean_reducing_pollution = mean(Importance_reducing_pollution, na.rm = TRUE),
                       Standdev_reducing_pollution = sd(Importance_reducing_pollution, na.rm = TRUE),
#                       Count_recycling_rubbish = sum(!is.na(Importance_recycling_rubbish)),                     
                       Mean_recycling_rubbish = mean(Importance_recycling_rubbish, na.rm = TRUE),
                       Standdev_recycling_rubbish = sd(Importance_recycling_rubbish, na.rm = TRUE),
#                       Count_conserving_water = sum(!is.na(Importance_conserving_water)),
                       Mean_conserving_water = mean(Importance_conserving_water, na.rm = TRUE),
                       Standdev_conserving_water = sd(Importance_conserving_water, na.rm = TRUE),
#                       Count_saving_enery = sum(!is.na(Importance_saving_enery)),
                       Mean_saving_enery = mean(Importance_saving_enery, na.rm = TRUE),
                       Standdev_saving_enery = sd(Importance_saving_enery, na.rm = TRUE),
#                       Count_owning_computer = sum(!is.na(Importance_owning_computer)),
                       Mean_owning_computer = mean(Importance_owning_computer, na.rm = TRUE),
                       Standdev_owning_computer = sd(Importance_owning_computer, na.rm = TRUE),
#                       Count_Internet_access = sum(!is.na(Importance_Internet_access)),
                       Mean_Internet_access = mean(Importance_Internet_access, na.rm = TRUE),
                       Standdev_Internet_access = sd(Importance_Internet_access, na.rm = TRUE))
df_CountryGenderGrpSum
#View(df_CountryGenderGrpSum)
#Note: No responses for NZ Male or Female for Rubbish, Energy, Computers, or Internet

#'### [7 ] Create any other data frames or visualizations that you think might help you 
#'determine areas of strength or weakness in the importance categories.

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_reducing_pollution)) +
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_recycling_rubbish)) +
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_conserving_water)) + 
  facet_wrap(~ Country, nrow = 1)
  
ggplot(data = df_CountryGenderGrp) +    
  geom_boxplot(mapping = aes(x = Gender, y = Importance_saving_enery)) +
  facet_wrap(~ Country, nrow = 1)
  
ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_owning_computer)) + 
  facet_wrap(~ Country, nrow = 1)
    
ggplot(data = df_CountryGenderGrp) +  
  geom_boxplot(mapping = aes(x = Gender, y = Importance_Internet_access)) +
  facet_wrap(~ Country, nrow = 1)
#' How to stitch these together in one chart?  So that distinct variables are the groups(data series)
#' https://stackoverflow.com/questions/14785530/ggplot-boxplot-of-multiple-column-values

#' Observations:
#' Males, across the board, and especially in USA, gave lower scores, and are less concerned about environemntal matters.
#' Males are generally more concerned (gave higher scores) to computer-related issues.
#'     

#'## [8 ] Create an .Rmd file that has two sections:
#'###  Section 1: Gives the **first 10 rows** of each of the data frames you created
head(df_orig, n = 10)
head(df_inch, n = 10)
head(df_environment, n = 10)
head(df_extra, n = 10)
head(df_numbers, n = 10)
head(df_CountryGenderImportances, n = 10)
head(df_CountryGenderGrp, n = 10)
head(df_CountryGenderGrpSum, n = 10)


#'### Section 2: Includes a **summary** of your findings to the question which includes at least **one visualization** to support your findings.
#' 
#'### Observations:
#'1. Males, across the board, and especially in USA, gave lower scores, and are less concerned about environmental matters.
#'2. Males are generally more concerned (gave higher scores) to computer-related issues.
#'  

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = (Importance_reducing_pollution+Importance_recycling_rubbish+Importance_conserving_water+Importance_saving_enery+Importance_owning_computer+Importance_Internet_access)/6)) +
  facet_wrap(~ Gender, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
geom_boxplot(mapping = aes(x = Gender, y = Importance_reducing_pollution)) +
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_recycling_rubbish)) +
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_conserving_water)) + 
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +    
  geom_boxplot(mapping = aes(x = Gender, y = Importance_saving_enery)) +
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +
  geom_boxplot(mapping = aes(x = Gender, y = Importance_owning_computer)) + 
  facet_wrap(~ Country, nrow = 1)

ggplot(data = df_CountryGenderGrp) +  
  geom_boxplot(mapping = aes(x = Gender, y = Importance_Internet_access)) +
  facet_wrap(~ Country, nrow = 1)
#' How to stitch these together in one chart?  So that distinct variables are the groups(data series)
#' https://stackoverflow.com/questions/14785530/ggplot-boxplot-of-multiple-column-values

   
