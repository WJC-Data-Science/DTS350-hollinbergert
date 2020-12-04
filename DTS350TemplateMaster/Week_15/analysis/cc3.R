#' ---
#' title: "Coding Challenge 3"
#' author: "TomHollinberger"
#' date: "12/3/2020"
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
#' sample filepath E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_15/analysis


library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyquant)
library(timetk)
library(DT)
library(dygraphs)
library(readr)
#' Check working directory
#'getwd() #"C:/Users/tomho/Documents"
#'already set by github   setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_15/analysis")

setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_15/analysis")
getwd()
#' Download the csv  go to github and copy the link and paste here...once, then # it out
#download.file("https://github.com/WJC-Data-Science/DTS350/raw/master/sales.csv", "sala.csv", mode = "wb")
#' Place it in the working directory folder.
#' Open csv in excel and filter each row to see what the column contents are (missing data = 99 for example, etc) .
#' Also look for opening lines to skip, comment flags, column names (header row), etc 
#' name	type	time	amount

#' WRANGLE THE DATA

#'Now we use the read_csv function to load the data.
cap1910 <- read_csv("cap1910.csv", skip = 2, col_names = FALSE)
cap1910    #looks good, all columns came over.
#' 151 x 3 dbl, chr, dbl


cap1911 <- read_csv("cap1911.csv", skip = 2, col_names = FALSE)
cap1911   
#' 151 x 3 dbl, chr, dbl


cap1912 <- read_csv("cap1912.csv", skip = 2, col_names = FALSE)
cap1912   
#' 151 x 3 dbl, chr, dbl


cap2001 <- read_csv("cap2001.csv", skip = 2, col_names = FALSE)
cap2001   
#' 151 x 3 dbl, chr, dbl    HAS EXTRA COL X4


cap2002 <- read_csv("cap2002.csv", skip = 3, col_names = FALSE)
cap2002   
#' !! NOTE !!  150 x 3 dbl, chr, dbl   HAS NA in X3  Missing column 1, fixed in csv

cap2003 <- read_csv("cap2003.csv", skip = 3, col_names = FALSE)
cap2003   
#' !! NOTE !!  150 x 3 dbl, chr, dbl   Onlyhas 2 columns Missing column 1, fixed in csv


#' Add date column (three variants)
cap1910 <- mutate(cap1910, month = "October", yr = "2019", calval = 1, mo = 10)
cap1910 <- mutate(cap1910, yrmo = make_date(yr,mo))
cap1910 <- select(cap1910, X2, X3, month, yr, calval, mo, yrmo)  #'Leave out X1 because can't bind rows because of X1 being dbl in some csvs and chr in others
#'Select only X2, X3, month, yr, calval, mo, yrmo
cap1910

cap1911 <- mutate(cap1911, month = "November", yr = "2019", calval = 2, mo = 11)
cap1911 <- mutate(cap1911, yrmo = make_date(yr,mo))
cap1911 <- select(cap1911, X2, X3, month, yr, calval, mo, yrmo)
cap1911

cap1912 <- mutate(cap1912, month = "December", yr = "2019", calval = 3, mo = 12)
cap1912 <- mutate(cap1912, yrmo = make_date(yr,mo))
cap1912 <- select(cap1912, X2, X3, month, yr, calval, mo, yrmo)
cap1912

cap2001 <- mutate(cap2001, month = "January", yr = "2020", calval = 4, mo = 1)
cap2001 <- mutate(cap2001, yrmo = make_date(yr,mo))
cap2001 <- select(cap2001, X2, X3, month, yr, calval, mo, yrmo)
cap2001

cap2002 <- mutate(cap2002, month = "February", yr = "2020", calval = 5, mo = 2)
cap2002 <- mutate(cap2002, yrmo = make_date(yr,mo))
cap2002 <- select(cap2002, X2, X3, month, yr, calval, mo, yrmo)
cap2002

cap2003 <- mutate(cap2003, month = "March", yr = "2020", calval = 6, mo = 3)
cap2003 <- mutate(cap2003, yrmo = make_date(yr,mo))
cap2003 <- select(cap2003, X2, X3, month, yr, calval, mo, yrmo)
cap2003

#"Can't bind rows because of X1 being dbl in some and chr in others
#"Select only X2, X3, month, yr, calval, mo, yrmo


#'Bind all 
capcomb <- bind_rows(cap1910, cap1911, cap1912, cap2001, cap2002, cap2003)
capcomb   #910 rows x 6 cols

#'Group all X2s by month and average X3 
capcombmoavg <- group_by(capcomb, yrmo)  
capcombmoavg
capcombmoavg <- summarise(capcombmoavg, moavg = mean(X3, na.rm = TRUE)) # Produce the mean for each month, all items
capcombmoavg

#' Gives different values than what's in the article.  All of a sudden, it gives the right numbers, except March.  Then ran again, and March was correct.


#' ## PART 1 -- RECREATE THE STATIC CHART

ggplot() +
  geom_point(data = capcombmoavg, mapping = aes(x = yrmo, y = moavg, fill = "black")) +  
  geom_line(data = capcombmoavg, mapping = aes(x = yrmo, y = moavg, color = "red"), lty = 2) +
  labs(
    title = "CPI food price averages") +
  scale_y_continuous("Average Prices") +
  scale_x_date("Time period") +
  theme_light() +
  theme(legend.position = "none")     

ggsave("CC3.png")  #saves to the project folder, overwrites without asking


#'## PART 2  RECREATE THE INTERACTIVE CHART 

#' Popups on the points. Using ggplotly   https://www.r-bloggers.com/2018/09/interactive-ggplot-with-tooltip-using-plotly/

library(plotly)
p1 <-   #same plot as above
  ggplot() +
  geom_point(data = capcombmoavg, mapping = aes(x = yrmo, y = moavg, fill = "black")) +  
  geom_line(data = capcombmoavg, mapping = aes(x = yrmo, y = moavg, color = "red"), lty = 2) +
  labs(
    title = "CPI food price averages") +
  scale_y_continuous("Average Prices") +
  #scale_x_date("Time period") +
  theme_light() +
  theme(legend.position = "none")     
p1
ggplotly(p1,tooltip = c("yrmo", "y"))  #now wrap it in plotly, select which variables you want to display and in what order.
ggsave("CC3interactive.png")  #saves to the project folder, overwrites without asking
#' 
#' 
#' 
#' 
#' 
#' ## PART 3 INVESTIGATE THE EFFECT OF CHANGING SOME FOOD ITEMS IN THE TRANSITION FROM JANUARY TO FEBRUARY.
#' 
#' use ANTI_JOIN to see which items are missing from which months.
#' Then investigate the values of those intermittemnt products to see if they were widely changing prices, if not, then it wouldn't have much impact.

#'In in Jan, Out of Feb
deltainjan <- anti_join(cap2001,cap2002, by = "X2")
deltainjan
#' 4 items in Jan but taken out of February
deltainjan <- group_by(deltainjan, month)   # in this case there is only Jan, which represents all prior months
deltainjanmoavg <- summarise(deltainjan, moavg = mean(X3, na.rm = TRUE)) # Produce the mean for THIS month, all items
deltainjanmoavg
#'  Average of the items unique to January-and-before is 7.11

#'Out of Jan, In in Feb
deltainfeb <- anti_join(cap2002,cap2001, by = "X2")
deltainfeb
#' 6 items in Jan but taken out of February
deltainfeb <- group_by(deltainfeb, month)   # in this case there is only Feb, which represents all future months
deltainfebmoavg <- summarise(deltainfeb, moavg = mean(X3, na.rm = TRUE)) # Produce the mean for THIS month, all items
deltainfebmoavg
#'  Average of the items unique to February-and-later is 4.09 
#'  INSIGHT : Average price put-in-February is less than the price taken-out-of-January.  
#'  It could have made a difference in making Feb and March overall averages appear smaller.
#'  
#'  LOOK AT THIS ISSUE ON A SUM BASIS, rather than Mean basis
#'  #'In in Jan, Out of Feb
deltainjan <- anti_join(cap2001,cap2002, by = "X2")
deltainjan
# 4 items in Jan but taken out of February  
deltainjan <- group_by(deltainjan, yrmo)   # in this case there is only Jan, which represents all prior months
deltainjanmosum <- summarise(deltainjan, moavg = sum(X3, na.rm = TRUE)) # Produce the mean for THIS month, all items
deltainjanmosum
#  Sum of the items unique to January and before is $ 28.4

#'Out of Jan, In in Feb
deltainfeb <- anti_join(cap2002,cap2001, by = "X2")
deltainfeb
# 6 items in Jan but taken out of February   
deltainfeb <- group_by(deltainfeb, yrmo)   # in this case there is only Feb, which represents all future months
deltainfebmosum <- summarise(deltainfeb, mosum = sum(X3, na.rm = TRUE)) # Produce the mean for THIS month, all items
deltainfebmosum
#  Sum of the items unique to February and later is $ 24.5

# Now compare to the basis (TOTAL SUM) of all items in February 
cap2002sum <- summarise(cap2002, capsum = sum(X3, na.rm = TRUE))
cap2002sum  #$ 343 total cost of the February marketbasket

# Now compare to the basis (TOTAL SUM) of all items in February 
cap2001sum <- summarise(cap2001, capsum = sum(X3, na.rm = TRUE))
cap2001sum  #$ 350 total cost of the January marketbasket

#So, the reduced monthly cost (from Jan to Feb) (28.4 - 24.5) = 3.9, which is a 1.137% (3.9/343) percent reduction of the total February marketbasket cost. 
#The corrected February marketbasket would be 343 + 3.9 = 346.9 (put back into Feb the cost delta), compared to the total January marketbasket cost of 350.  

#Graph faceted on Month, horizontal bar chart of foods

#'Bind uniques from Jan and Feb
deltainjanfeb <- bind_rows(deltainfeb, deltainjan)
deltainjanfeb   #10 rows x 7 cols

#'Bind averages of uniques from Jan and Feb
deltainjanfebmoavg <- bind_rows(deltainjanmoavg,deltainfebmoavg)
deltainjanfebmoavg

deltainjanfeb <- mutate(deltainjanfeb, moname = factor(month)) 
deltainjanfeb
deltainjanfeb <- mutate(deltainjanfeb, X2 = factor(X2)) 
deltainjanfeb
deltainjanfeb <- arrange(deltainjanfeb, moname, X2, X3)  
deltainjanfeb

ggplot(deltainjanfeb, aes(x = X3, y = X2, color = month)) +
  geom_point() +
  geom_vline(data = deltainjanfebmoavg, mapping = aes( xintercept = moavg, color = month)) +
  labs(
    title = "Food Item Price Points and Averages for Months, \n ONLY ITEMS UNIQUE TO JAN or FEB, \n but not both",
    subtitle = "4 items are January-unique, 6 items are February-unique") +
    scale_x_continuous("Price each and average for month") 
ggsave("CC3uniques.png")

#' INSIGHT: The February-Unique items have a lower average cost than the January-unique items, 
#'which would reduce the February overall marketbasket price.


#' INVESTIGATE ON AN APPLES-TO-APPLES BASIS
#' USE SEMI_JOIN to get all rows in A that have a match in B (i.e., throw out any that do not carryover across all 6 months), 
#' then run the original graph
cap1910abbr <- semi_join(cap1910, cap2002, by = "X2")
cap1910abbr    #147 line items

cap1911abbr <- semi_join(cap1911, cap2002, by = "X2")
cap1911abbr   #147 line items

cap1912abbr <- semi_join(cap1912, cap2002, by = "X2")
cap1912abbr   #147 line items

cap2001abbr <- semi_join(cap2001, cap2002, by = "X2")
cap2001abbr   #147 line items

#Now switch the logic and create 2002abbr and 2003abbrvia inner_join with cap2002 and already-abbreviated 1910abbr
cap2002abbr <- semi_join(cap2002, cap1910abbr, by = "X2")
cap2002abbr    #147 line items

cap2003abbr <- semi_join(cap2003, cap1910abbr, by = "X2")
cap2003abbr    #147 line items

#'Bind all 
capabbrcomb <- bind_rows(cap1910abbr, cap1911abbr, cap1912abbr, cap2001abbr, cap2002abbr, cap2003abbr)
capabbrcomb   #882 rows x 6 cols   26 less than the 910 original prior to throwing out uniques
#view(capabbrcomb)


#'Group all X2s by month and average X3 
capabbrcombmoavg <- group_by(capabbrcomb, yrmo)  
capabbrcombmoavg <- summarise(capabbrcombmoavg, moavg = mean(X3, na.rm = TRUE)) # Produce the mean for each month, all items that are present in all 6 months
capabbrcombmoavg


#' Now Plot as before, but only using items that are present in all months (147 as opposed to ~151)
ggplot() +
  geom_point(data = capabbrcombmoavg, mapping = aes(x = yrmo, y = moavg, fill = "black")) +  
  geom_line(data = capabbrcombmoavg, mapping = aes(x = yrmo, y = moavg, color = "red"), lty = 2) +
  labs(
    title = "CPI food price averages, \n USING ONLY ITEMS PRESENT IN ALL MONTHS",
    subtitle = "10 items (out of ~157) removed because they did not occur across all 6 months.") +
  scale_y_continuous("Average Prices") +
  scale_x_date("Time period") +
  theme_light() +
  theme(legend.position = "none")     

ggsave("CC3abbr.png")  #saves to the project folder, overwrites without asking


#' ## PART 4, CHART TRACKING INDIVIDUAL ITEMS WITH MOST AMOUNT OF CHANGE GROWTH FROM BEGINNING TO END
#' I'LL WRANGE DATA FOR A PRICE DELTA AND ALSO A PERCENT PRICE DELTA
cap1910
cap1910renamed <- rename(cap1910, Item = X2, Price1910 = X3)
cap1910renamed <- select(cap1910renamed, Item, Price1910)
cap1910renamed

cap1911renamed <- rename(cap1911, Item = X2, Price1911 = X3)
cap1911renamed <- select(cap1911renamed, Item, Price1911)
cap1911renamed

cap1912renamed <- rename(cap1912, Item = X2, Price1912 = X3)
cap1912renamed <- select(cap1912renamed, Item, Price1912)
cap1912renamed

cap2001renamed <- rename(cap2001, Item = X2, Price2001 = X3)
cap2001renamed <- select(cap2001renamed, Item, Price2001)
cap2001renamed

cap2002renamed <- rename(cap2002, Item = X2, Price2002 = X3)
cap2002renamed <- select(cap2002renamed, Item, Price2002)
cap2002renamed

cap2003renamed <- rename(cap2003, Item = X2, Price2003 = X3)
cap2003renamed <- select(cap2003renamed, Item, Price2003)
cap2003renamed

#Now combine all prices in each year for each item
cap1011 <- inner_join(cap1910renamed, cap1911renamed, by = "Item")
cap1011   #151 items

cap101112 <- inner_join(cap1011, cap1912renamed, by = "Item")
cap101112   #151 items

cap10111201 <- inner_join(cap101112, cap2001renamed, by = "Item")
cap10111201   #151 items

cap1011120102 <- inner_join(cap10111201, cap2002renamed, by = "Item")
cap1011120102   #NOTE 147 items, because of changes of item list between Jan and Feb

cap101112010203 <- inner_join(cap1011120102, cap2003renamed, by = "Item")
cap101112010203   #NOTE 147 items, because of changes of item list between Jan and Feb



cap10and3delta <- mutate(cap101112010203, DeltaPrice = (Price2003 - Price1910), PctDeltaPrice = ((Price2003 - Price1910)/Price1910))     
#delta = new - old,  pctdelta = (new-old)/old,  
cap10and3delta


#then do abs value to prep for greatest change PLUS or MINUS
cap10and3deltabs <- mutate(cap10and3delta, AbsDeltaPrice = abs(DeltaPrice), AbsPctDeltaPrice = abs(PctDeltaPrice))
cap10and3deltabs

#view(cap10and3deltabs)


#Filter for the Top10 and Top10Pct
Top10 <- cap10and3deltabs %>%
  filter(row_number(desc(AbsDeltaPrice)) <= 10)
Top10 <- arrange(Top10, desc(AbsDeltaPrice))
Top10

Top10pct <- cap10and3deltabs %>%
  filter(row_number(desc(AbsPctDeltaPrice)) <= 10)
Top10pct <- arrange(Top10pct, desc(AbsPctDeltaPrice))
Top10pct


#Change the Top10 into a chartable dataframe
Top10gathered <- gather(Top10, key = "year", value = "Price", - Item)
view(Top10gathered)  #100 rows

Top10gatheredshort <- filter(Top10gathered, year >= "pq")
view(Top10gatheredshort)  #60 rows

Top10gatheredshortyrmody <- Top10gatheredshort %>%
  mutate(
    yrmody = case_when(
      year == "Price1910" ~ "2019-10-01",
      year == "Price1911" ~ "2019-11-01",
      year == "Price1912" ~ "2019-12-01",
      year == "Price2001" ~ "2020-01-01",
      year == "Price2002" ~ "2020-02-01",
      year == "Price2003" ~ "2020-03-01"
      )   # would use TRUE ~ "something"   for all other cases
  )
view(Top10gatheredshortyrmody)

#Chart the Top10

p2 <-
ggplot() +
  geom_point(data = Top10gatheredshortyrmody, mapping = aes(x = yrmody, y = Price, group = Item, color = Item)) +  #group=country is like series=country in Excel
  geom_line(data = Top10gatheredshortyrmody, mapping = aes(x = yrmody, y = Price, group = Item, color= Item)) +
  coord_cartesian(ylim = c(0, 16)) +
    labs(title = "Items with the Largest Price Changes (+ or -) across 6 months", y = "Price", x = "") +
  theme_light()
p2
ggplotly(p2,tooltip = c("yrmody", "Price", "Item"))  
ggsave("Price Change Top 10.jpeg")


#Change the Top10PCT into a chartable dataframe
Top10pctselected <- select(Top10pct, Item, PctDeltaPrice)
view(Top10pctselected)  #10 rows

Top10pctselected <- Top10pctselected %>%
  rownames_to_column() %>%  
  as_data_frame() %>%
  select(rowname, Item, PctDeltaPrice)
Top10pctselected 


p3 <-
ggplot(Top10pctselected, aes(x = reorder(rowname, PctDeltaPrice), y = PctDeltaPrice)) +
  geom_col(aes(fill = Item)) +
  geom_text(aes(label = Item), nudge_y = .03, size = rel(3)) +
  coord_flip() +
  labs(title = "Items with the Largest Percentage Price Changes (+ or -) across 6 months", y = "Percent Price Change", x = "") +
  scale_colour_brewer(palette = "Set1") +
  theme(axis.title.y = element_blank(),            #deletes the axis titles
      legend.position = "none",                  #deletes the legend
      axis.text.y = element_blank()             #deletes the x axis ticks and numbers    axis.ticks.y = element_blank())
)

p3
ggplotly(p3,tooltip = c("PctDeltaPrice", "Item"))  
ggsave("Pct Price Change Top 10.jpeg")
