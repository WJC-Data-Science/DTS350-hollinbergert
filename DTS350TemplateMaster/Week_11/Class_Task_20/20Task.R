#' ---
#' title: "Task 20 : My Investment is Better Than Yours"
#' author: "TomHollinberger"
#' date: "11/3/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    code_folding:  hide
#'    results: 'hide'
#'    message: FALSE
#'    warning: FALSE
#' ---  

#' THIS RSCRIPT USES ROXYGEN CHARACTERS. <br> 
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  <br>
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.<br>
#'



#'#### You and a friend each purchased about $1,000 of stock in three different stocks
#'#### at the start of October last year, and you want to compare your performance up to this week. 
#'#### Use the stock shares purchased and share prices to demonstrate how each of you fared 
#'#### over the period you were competing (assuming that you did not change your allocations).

library(tidyquant)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(timetk)

#'### [ ] List the three stocks that your friend picks and the three that you pick.
#'#### My picks:  Lowes (LOW), Walmart (WMT), McDonalds (MCD)
#'#### Friend's picks: Home Depot (HD), Target (TGT), Restaurant Brands Inc (Burger King, Tim Horton, Popeye's) (QSR)

#'### [ ] Pull the price performance data using library(tidyquant).
#### and Bind it into My Portfolio, Friend's Portfolio, and All Portfolio
mystocks <- c("LOW","MCD","WMT") %>%
  tq_get(get = "stock.prices", 
                    from = "2019-10-01")
mystocks

frstocks <- c("HD","QSR","TGT") %>%
  tq_get(get = "stock.prices", 
         from = "2019-10-01")
frstocks   
#BOTH HAVE 828 ROWS

#Bind my and fr together
allstocks <- bind_rows(mystocks, frstocks)
allstocks  
#1656 rows

allstocks <-arrange(allstocks, date)
allstocks

#add a daily returns columns (will be used to calculate daily earnings)
allstocksgrp <- group_by(allstocks,symbol)
allstocksgrp
allstocksgrp <- tq_mutate(allstocksgrp, adjusted, mutate_fun = dailyReturn)
allstocksgrp
#Has these columns:  symbol date  open  high   low close  volume adjusted daily.returns
# 1565 rows

#'#### Create a separate baseline dataframe, using the first day's adjusted price.
baseline <- filter(allstocks, date == "2019-10-01")
baseline <- mutate(baseline, bsln = adjusted)
baseline  #in this order LOW,MCD,WMT,HD,QSR,TGT

#'#### Decide how many shares of each stock you will purchace with the $1000.
#' Used a scratch excel sheet and sumproduct to come close to 1000
#' Make a vector to become the shrs column
shrs <- c(2,1,5,2,5,2)
baseline$shrs <- shrs
(baseline <- select(baseline, symbol, bsln, shrs))
#Has these columns:  symbol bsln  shrs
#and only 6 rows  (the 6 symbols)

#'#### Join so that baseline price and shrs are populated/repeated for every row.
allstkwbsl <- left_join(allstocksgrp,baseline, by = "symbol")
allstkwbsl
#Now has these columns:  symbol date  open  high   low close  volume adjusted  daily.returns bsln  shrs
#and 1656 rows  (all days for all 6 symbols)

#'#### Add a VAL column = shrs x adjusted, 
#'#### Add an CUMEARN column = (adjusted - bsln) x shrs, 
#'#### Add a DLYEARN column = daily.return x shrs,
alstkwbslearn <- mutate(allstkwbsl, 
                        val = shrs * adjusted, 
                        cumearn = (adjusted - bsln)*shrs, 
                        dlyearn = daily.returns*shrs)
alstkwbslearn

#Plot of 6 separate daily earnings
alstkwbslearn %>%
  ggplot(aes(x = date, y = dlyearn, color = symbol)) +
  geom_line() +
  labs(title = "LOW,MCD,WMT,HD,QSR,TGT Line Chart", y = "Earnings", x = "") +
  theme_tq()

#Bundle into My vs Friends Portfolios
#Make a variable for My or Friends, first create it = symbol, then mutate-case-when 
alstkwbslearn <- mutate(alstkwbslearn, who = symbol)
alstkwbslearn
alstkwbslearn <- mutate(alstkwbslearn,who=case_when(
  who == "LOW" ~ "My",
  who == "WMT" ~ "My",
  who == "MCD" ~ "My",
  who == "HD" ~ "Fr",
  who == "TGT" ~ "Fr",
  who == "QSR" ~ "Fr"))
alstkwbslearn

#Create a dailyReturn grouped by portfolio
alstkwbslearnbyport <- group_by(alstkwbslearn, date, who)  
alstkwbslearnbyport
alstkwbslearndlyport <- summarise(alstkwbslearnbyport, portdlyearn = sum(dlyearn, na.rm = TRUE)) # Produce the daily earnings for each portfolio (My vs Fr)
alstkwbslearndlyport
tail(alstkwbslearndlyport)

#'### [ ] Build a visualization that shows who is winning each day of the competition.
#'## **PLOT 1 : "Who Won Each Day?** Portfolio Daily Earnings
#'## **INSIGHT 1** :  A very busy chart.  Need a zoom-in capability to feret-out who really won each day.  And the win changes hands frequently.  Daily is probably too small of a periodicity to see useful trends.

alstkwbslearndlyport %>%
  ggplot(aes(x = date, y = portdlyearn, color = who)) +
  geom_line() +
  labs(title = "My vs Friends Daily Earnings Line Chart", y = "Daily Earnings", x = "") +
  theme_tq()
ggsave("Who Won each Day.jpeg")

#'## **PLOT 1A : Who Won Each Day? INTERACTIVE and ZOOM-ABLE** Portfolio Daily Earnings
#'## **INSIGHT 1A** :  Zooming in just confirms that the win changes hands frequently. Daily is probably too small of a periodicity to see useful trends.


library(timetk)
library(dygraphs)

alstkwbslearndlyport_xts <- alstkwbslearndlyport %>%
  select(who, date, portdlyearn) %>%
  pivot_wider(names_from = who, values_from = portdlyearn) %>%
  tk_xts(date_var = date)  #caused an error when knitting 

dygraph(alstkwbslearndlyport_xts, main = "Daily Portfolio Earnings") %>%
  dySeries("My", label = "My Portfolio") %>%
  dySeries("Fr", label = "Friend's Portfolio") %>%
  dyAxis("y", label = "Daily Earnings", valueRange = c(-.75, +1.)) %>%
  dyLegend(width = 300) %>% 
  dyRangeSelector()
#'## [ ] In the previous visualization or with another visualization show which stock is helping the winner of the competition.
#'## **PLOT 2 : Which Stock is helping the winner of the competition?**  Separate cumulative earnings for each stock.  
#'## **INSIGHT 2** : The restaurant stocks (MCD and QSR) did not help either portfolio.  MCD and QSR suffered in March/April and didn't fully recover.  QSR was especially poor.  Home improvement and Department store stocks were in a tight cluster that earned around 10% over the period. 

alstkwbslearn %>%
  ggplot(aes(x = date, y = cumearn, color = symbol)) +
  geom_line() +
  labs(title = "LOW,MCD,WMT,HD,QSR,TGT Line Chart", y = "Cumulative Earnings", x = "") +
  theme_tq()
ggsave("Which Stock Helped Most.jpeg")



alstkwbslearncumport <- group_by(alstkwbslearn, date, who)  
alstkwbslearncumport
alstkwbslearncumport <- summarise(alstkwbslearncumport, portcumearn = sum(cumearn, na.rm = TRUE)) # Produce the sum for each portfolio (My vs Fr)
alstkwbslearncumport
tail(alstkwbslearncumport)

#'## **BONUS PLOT : Portfolio Cumulative Earnings**    Who won after the whole time period?
#'## **BONUS INSIGHT** : My portfolio pulled ahead in November/December and stayed ahead the entire rest of the time period.  In the end, My total cumulative earnings were ahead, $238 to $110.
alstkwbslearncumport %>%
  ggplot(aes(x = date, y = portcumearn, color = who)) +
  geom_line() +
  labs(title = "My vs Friends Cumulative Earnings Line Chart", y = "Cumulative Earnings", x = "") +
  theme_tq()
ggsave("Portfolio Cumulative Earnings.jpeg")


#'### [ ] Take notes on your reading of the new R package in the README.md or in a ‘.R’ script in the class task folder.
