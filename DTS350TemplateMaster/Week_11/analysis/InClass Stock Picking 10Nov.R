#' ---
#' title: "InClass 10 November : Stock Performance"
#' author: "TomHollinberger"
#' date: "11/10/2020"
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



#' ### DYGRAPHS DESCRIPTION : 
#' The dygraphs are laid out in a three tier arrangment for easy comparison of growth of a dollar, percent growth, and actual stock price.  
#' They are syncronized so that a zoom-in on one will automatically be reflected in the other two.
#' There is a Reset Zoom function that turns-on in the upper left after a zoom has occurred.
#' The legend has been set to width=100, so that it sits in a vertical column for easier reading.
#' There is a range-selector at the bottom, which is also syncronized between the three graphs.
#' The range selector is enlarged and has a red topline for easy "where am I" interpretation.
#' There is a rolling average selector in the lower left, which is initially set to 5 to help smooth the lines for easier reading.
#' Data lines are set to magnify when hovered on, and other datalines fade.  
#' There are also datadots and crosshairs that appear as the mouse hovers.  These aid in reading across to axis values associated with particular datapoints.
#' Grid color is set to gold, so as to not visually interfere with the datalines or the crosshairs.
#' The period start date is built-in via formula to the main title.  Note: In this unique case, JCPenney data is incomplete, which hampers the value-growth and percentage growth calculations.
#'
#' ### GGPLOT DESCRIPTION :  
#' Based on internet research on how to use stock sales volume to inform stock purchases, a template graph was developed.    
#' This template is applied to each individual stock.  These individual graphs help compare a particular stock sales volume to its share price over time.  
#' In order to facilitate comparison of stock price and sales volume behaviors, which are usually on vastly different numeric scales, the price and volume amounts were standardized using the "scale" function.
#' The graphs now show standard deviations from the mean price or mean volume on the vertical dimension.  A red horizontal zero line shows the mean.
#' At a glance, the reader can see whether they are above or below average price or volume, and the magnitudes are now on comparable scales.  
#' The daily data is very busy, so 5-day moving average lines are added, using geom_ma, in their corresponding color, but with some transparency.
#' Visual interpretation and professional judgment can then be applied to make a buy/don't buy recommendations.  
#' Patterns and relationships between Price and Volume are mentioned in https://www.investopedia.com/articles/technical/02/010702.asp and can be easily identified in the graphs.



######

#' [ ] Use library(dygraphs) to build interactive visualizations of the stock performances over the last 5 years.
# Load packages
library(quantmod)
library(tidyquant) # to get stock data
library(tidyverse) # for pipes
library(dplyr) # for data transformations
library(lubridate) # for date/time functions
library(timetk) # for converting dates to xts
library(dygraphs) # for interactive plots

#install this plugin to enable crosshairs
dyCrosshair <- function(dygraph, 
                        direction = c("both", "horizontal", "vertical")) {
  dyPlugin(
    dygraph = dygraph,
    name = "Crosshair",
    path = system.file("plugins/crosshair.js", 
                       package = "dygraphs"),
    options = list(direction = match.arg(direction))
  )
}

#install this plugin to enable UNZOOM
dyUnzoom <-function(dygraph) {
  dyPlugin(
    dygraph = dygraph,
    name = "Unzoom",
    path = system.file("plugins/unzoom.js", package = "dygraphs")
  )
}

# Tickers and Pull Data
#Manually enter tickers
tickers_today <- c("QQQ", "MO", "KO", "ABB", "LH", "PFE", "CINF")
#note: JCP is JCPNQ while they are in bankruptcy, and has no data until Nov2019
x1 <- tickers_today[1]
x2 <- tickers_today[2]
x3 <- tickers_today[3]
x4 <- tickers_today[4]
x5 <- tickers_today[5]
x6 <- tickers_today[6]
x7 <- tickers_today[7]


end <- today() - days(3)    #manually set date window, eg, a rolling two year retrospective, ending three days ago
start <- end - years(2)
#end <- "2020-10-30"    
#start <- "2019-10-30"


x1_prices <- tq_get(x1, get = "stock.prices", from = start, to = end)
x2_prices <- tq_get(x2, get = "stock.prices", from = start, to = end)
x3_prices <- tq_get(x3, get = "stock.prices", from = start, to = end)
x4_prices <- tq_get(x4, get = "stock.prices", from = start, to = end)
x5_prices <- tq_get(x5, get = "stock.prices", from = start, to = end)
x6_prices <- tq_get(x6, get = "stock.prices", from = start, to = end)
x7_prices <- tq_get(x7, get = "stock.prices", from = start, to = end)


My_stockPrices <- bind_rows(x1_prices, x2_prices, x3_prices, 
                            x4_prices, x5_prices, x6_prices, 
                            x7_prices) %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)
#My_stockPrices 

invamt <- 100  #manually input the initial investment amount

#' ## Three Useful **dyGraphs of Stock Performance**, grouped for syncronized zooming
dygraph(My_stockPrices, main = paste("Value of an initial $",invamt,", invested on", start), group = "stock2") %>%  #this assumes no missing values, which would delay the start of accumulation calcs.
  dyRebase(value = invamt) %>%
  dyRangeSelector() %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyLegend(width = 100) %>%
  dyRoller(rollPeriod = 5) %>%
  dyRangeSelector(dateWindow = c(start, end),height = 100, strokeColor = "red") %>%   #or "yyy-mm-dd" or with no RangeSelector(dateWindow) command,or RangeSelector()  it inherits the extent of the "get"
  dyCrosshair(direction = "both") %>%
  dyUnzoom() %>%
  dyOptions(gridLineColor = "Gold")

dygraph(My_stockPrices, main = paste("Percent Growth since",start), group = "stock2") %>%
  dyRebase(percent = TRUE) %>%
  dyRangeSelector() %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyLegend(width = 100) %>%
  dyRoller(rollPeriod = 5) %>%
  dyRangeSelector(dateWindow = c(start, end),height = 100, strokeColor = "red") %>% 
  dyCrosshair(direction = "both") %>%
  dyUnzoom() %>%
  dyOptions(gridLineColor = "Gold")
  
dygraph(My_stockPrices, main = "Stock Price, Adjusted End of Day", group = "stock2") %>%
  dyRangeSelector()  %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyLegend(width = 100) %>%
  dyRoller(rollPeriod = 5) %>%
  dyRangeSelector(dateWindow = c(start, end),height = 100, strokeColor = "red") %>% 
  dyCrosshair(direction = "both") %>%
  dyUnzoom() %>%
  dyOptions(gridLineColor = "Gold")

#how to plot in viewer multi-tiered   CAN ONLY BE SEEN IN RMD, must knit first
# from https://github.com/rstudio/dygraphs/issues/59



