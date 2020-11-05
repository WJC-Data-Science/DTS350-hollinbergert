#' ---
#' title: "Task 21 : Kroger Stock"
#' author: "TomHollinberger"
#' date: "11/5/2020"
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
#' _________________________________
#' _________________________________
#'
#' 
#'  [ ] Create an .Rmd file with 1-2 paragraphs summarizing your graphics and the choices you made in the data presentation.
#'  [ ] Compile your .md and .html file into your git repository.


library(tidyquant) # to get stock data
library(tidyverse) # for pipes
library(dplyr) # for data transformations
library(lubridate) # for date/time functions
library(timetk) # for converting dates to xts
library(dygraphs) # for interactive plots

x1 <- "KR"
end <- today()-days(3)
start <- end - years(5)

x1_prices <- tq_get(x1, get = "stock.prices", from = start, to = end)
x1_prices


#'##  [ ] Build the library(dygraphs) plot that shows the Kroger (KR) stock price performance over 5 years.
KR_stockPrices <- bind_rows(x1_prices) %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)
KR_stockPrices
#'## **Plot 1 Insights:**  This chart portrays Daily Stock Prices across a 5 year timespan, and shows that Kroger's has generally been in a slump, and has just crawled back to 5-year's-previous levels in the last 12 months.  However, there is a noticable downturn in the last two months.
dygraph(KR_stockPrices, main = "Daily Stock Price : KROGERS (KR)") %>%
  dySeries(x1, strokeWidth = 2) %>% # specific aspects of the other line
  dyRangeSelector() # include range selector



#'##  [ ] Imagine that you invested $10,000 in Kroger about two years ago on April 5th. Make a graph with dygraph that shows performance using dyRebased() to $10,000.
#'##  [ ]	Annotate the graphic with a note of the reason at two or more time points, or intervals, where the price had significant shifts.
x1 <- "KR"
end <- today()-days(3)
start <- end - years(2)

x1_prices2 <- tq_get(x1, get = "stock.prices", from = start, to = end)
x1_prices2

KR_stockPrices2 <- bind_rows(x1_prices2) %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)
KR_stockPrices2

#'  
#'## **Plot 2 Insights:**  This chart portrays the growth of $10,000 over the last two years.  A major drop occurred in March 2019 as Kroger reported poor quarterly earnings at the same time Walmart and Target reported robust sales.  The CoronaVirus increased sales from April thru August 2020.  But as restaurants open back up, the growth is fading away in September and October 2020. 
dygraph(KR_stockPrices2, main = "KROGERS (KR) : Growth of $10,000 from November 2018") %>%
  dyRebase(value = 10000,) %>% # shows relative stock performance for given starting value
  dyAnnotation("2019-03-07", text = "A", tooltip = "Poor Sales in the midst of WMT & TGT strong sales.") %>%
  dyShading(from = "2019-02-20", to = "2019-03-20") %>%
  #'  Nov 2019  https://www.fool.com/investing/2019/12/09/why-kroger-stock-gained-11-in-november.aspx
  dyAnnotation("2020-06-01", text = "B", tooltip = "Restaurants Closed due to COVID") %>%
  dyShading(from = "2020-04-06", to = "2020-08-19") %>%
  dyAnnotation("2020-10-01", text = "C", tooltip = "Restaurants Opening after COVID") %>%
  dyShading(from = "2020-09-04", to = "2020-10-23") %>%  
  #'  https://www.fool.com/investing/2020/09/17/kroger/
  dyRangeSelector()

