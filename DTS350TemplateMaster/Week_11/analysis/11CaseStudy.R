#' ---
#' title: "Case Study 11 : Interacting with Time"
#' author: "TomHollinberger"
#' date: "11/6/2020"
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
tickers_today <- c("CXW", "F", "GM", "JCPNQ", "KR", "WDC", "NKE","T", "WDAY", "WFC", "WMT")
#note: JCP is JCPNQ while they are in bankruptcy, and has no data until Nov2019
x1 <- tickers_today[1]
x2 <- tickers_today[2]
x3 <- tickers_today[3]
x4 <- tickers_today[4]
x5 <- tickers_today[5]
x6 <- tickers_today[6]
x7 <- tickers_today[7]
x8 <- tickers_today[8]
x9 <- tickers_today[9]
x10 <- tickers_today[10]
x11 <- tickers_today[11]

end <- today() - days(3)    #manually set date window, eg, a rolling two year retrospective, ending three days ago
start <- end - years(2)

x1_prices <- tq_get(x1, get = "stock.prices", from = start, to = end)
x2_prices <- tq_get(x2, get = "stock.prices", from = start, to = end)
x3_prices <- tq_get(x3, get = "stock.prices", from = start, to = end)
x4_prices <- tq_get(x4, get = "stock.prices", from = start, to = end)
x5_prices <- tq_get(x5, get = "stock.prices", from = start, to = end)
x6_prices <- tq_get(x6, get = "stock.prices", from = start, to = end)
x7_prices <- tq_get(x7, get = "stock.prices", from = start, to = end)
x8_prices <- tq_get(x8, get = "stock.prices", from = start, to = end)
x9_prices <- tq_get(x9, get = "stock.prices", from = start, to = end)
x10_prices <- tq_get(x10, get = "stock.prices", from = start, to = end)
x11_prices <- tq_get(x11, get = "stock.prices", from = start, to = end)

My_stockPrices <- bind_rows(x1_prices, x2_prices, x3_prices, x4_prices, x5_prices, x6_prices, x7_prices, x8_prices, x9_prices, x10_prices, x11_prices) %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)
My_stockPrices 

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




#' [ ] Make a library(ggplot2) graphic that helps you build a solid question around how an investor would use volume in their trading strategy.
# How to use volume to improve trading strategy
# https://www.investopedia.com/articles/technical/02/010702.asp
# KEY TAKEAWAYS
# Volume measures the number of shares traded in a stock or contracts traded in futures or options.
# Volume can be an indicator of market strength, as rising markets on increasing volume are typically viewed as strong and healthy.
# When prices fall on increasing volume, the trend is gathering strength to the downside. (BAD)
# When prices reach new highs (or no lows) on decreasing volume, watch out; a reversal might be taking shape. (BAD)
# Look for rising prices on rising volume.
# Look for reaching new price lows on decreasing volume (it will turn around)


My_stockVolume <- bind_rows(x1_prices, x2_prices, x3_prices, x4_prices, x5_prices, x6_prices, x7_prices, x8_prices, x9_prices, x10_prices, x11_prices)
AllMy_stockAdjVol <-  select(My_stockVolume, symbol, date, adjusted, volume)
AllMy_stockAdjVol 

#Template for standardizing the volume and adjusted columns for each individual stock, since we will be comparing their movements, but they have very different scales.
#Do this just prior to each graph

#Particular_stock <- filter(AllMy_stockAdjVol , symbol == "XYZ")
#Particular_stock$volstd <- scale(Particular_stock$volume)
#Particular_stock$adjstd <- scale(Particular_stock$adjusted)
#Particular_stock




adjvolCXW <- filter(AllMy_stockAdjVol , symbol == "CXW")
adjvolCXW 
adjvolCXW$volstd <- scale(adjvolCXW$volume)
adjvolCXW$adjstd <- scale(adjvolCXW$adjusted)
adjvolCXW 
#' ## Stock Purchase Recommendations based on **Volume Analysis**
#' ### CXW Recommendation:  Buy, due to low price and decreased volume.
adjvolCXW %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "CXW Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 



adjvolF <- filter(AllMy_stockAdjVol, symbol == "F")
adjvolF 
adjvolF$volstd <- scale(adjvolF$volume)
adjvolF$adjstd <- scale(adjvolF$adjusted)
adjvolF 
#' ### F Recommendation:  Don't Buy, due to price recently climbing and recently high volume.  
adjvolF %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "F Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolGM <- filter(AllMy_stockAdjVol, symbol == "GM")
adjvolGM 
adjvolGM$volstd <- scale(adjvolGM$volume)
adjvolGM$adjstd <- scale(adjvolGM$adjusted)
adjvolGM 
#' ### GM Recommendation:  Don't Buy, because of recently risen prices and decreasing volume.  
adjvolGM %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "GM Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolJCPNQ <- filter(AllMy_stockAdjVol, symbol == "JCPNQ")
adjvolJCPNQ 
adjvolJCPNQ$volstd <- scale(adjvolJCPNQ$volume)
adjvolJCPNQ$adjstd <- scale(adjvolJCPNQ$adjusted)
adjvolJCPNQ 
#' ### JCPNQ Recommendation:  Don't Buy.  They are in bankruptcy, and it's hard to tell what will happen.  Also, recent drop in prices while volume is stable.
adjvolJCPNQ %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "JCPNQ Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolKR <- filter(AllMy_stockAdjVol, symbol == "KR")
adjvolKR 
adjvolKR$volstd <- scale(adjvolKR$volume)
adjvolKR$adjstd <- scale(adjvolKR$adjusted)
adjvolKR 
#' ### KR Recommendation:  Buy, quickly.  Last 2 months were decreasing price and increasing volume, due to the lifting of Coronavirus restrictions and the opening of restaurants.
adjvolKR %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "KR Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 


adjvolWDC <- filter(AllMy_stockAdjVol, symbol == "WDC")
adjvolWDC 
adjvolWDC$volstd <- scale(adjvolWDC$volume)
adjvolWDC$adjstd <- scale(adjvolWDC$adjusted)
adjvolWDC 
#' ### WDC Recommendation:  Buy, because prices have been low for awhile, and volume has been starting to increase.  Could be ready to upswing.
adjvolWDC %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "WDC Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolNKE <- filter(AllMy_stockAdjVol, symbol == "NKE")
adjvolNKE 
adjvolNKE$volstd <- scale(adjvolNKE$volume)
adjvolNKE$adjstd <- scale(adjvolNKE$adjusted)
adjvolNKE 
#' ### NKE Recommendation:  Don't Buy, because prices are higher than ever and just truned down, and volume is down, too.
adjvolNKE %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "NKE Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 


adjvolT <- filter(AllMy_stockAdjVol, symbol == "T")
adjvolT 
adjvolT$volstd <- scale(adjvolT$volume)
adjvolT$adjstd <- scale(adjvolT$adjusted)
adjvolT 
#' ### T Recommendation:  Buy, because prices are at a 6-month low and volume has been up for 2 or 3 months.  Prices are about to heat up.
adjvolT %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "T Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolWDAY <- filter(AllMy_stockAdjVol, symbol == "WDAY")
adjvolWDAY 
adjvolWDAY$volstd <- scale(adjvolWDAY$volume)
adjvolWDAY$adjstd <- scale(adjvolWDAY$adjusted)
adjvolWDAY 
#' ### WDAY Recommendation:  Don't Buy, because prices are high and just turned down, and volume is coming down.
adjvolWDAY %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "WDAY Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 

adjvolWFC <- filter(AllMy_stockAdjVol, symbol == "WFC")
adjvolWFC 
adjvolWFC$volstd <- scale(adjvolWFC$volume)
adjvolWFC$adjstd <- scale(adjvolWFC$adjusted)
adjvolWFC 
#' ### WFC Recommendation:  Buy, because prices have been low, and volume has been high for 5 months.  Prices about to rebound.
adjvolWFC %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "WFC Stock Price and Volume",
         subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
         y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
         x = "") +
  theme_tq() 


adjvolWMT <- filter(AllMy_stockAdjVol, symbol == "WMT")
adjvolWMT 
adjvolWMT$volstd <- scale(adjvolWMT$volume)
adjvolWMT$adjstd <- scale(adjvolWMT$adjusted)
adjvolWMT 
#' ### WMT Recommendation:  Don't Buy, because prices are high, and volume is low after a recent peak.
adjvolWMT %>%
  ggplot() +
  geom_line(aes(x = date, y = volstd)) +
  geom_line(aes(x = date, y = adjstd), color = "dark green") +
  geom_ma(aes(x = date, y = volstd), n = 5, color = "black", size = 1.5, linetype = 1, alpha = .4) +
  geom_ma(aes(x = date, y = adjstd), n = 5, color = "green", size = 1.5, linetype = 1, alpha = .4) +
  geom_hline(yintercept = 0, color = "red") +
  labs(title = "WMT Stock Price and Volume",
       subtitle = "Stock Price (Green), Trading Volume (Black), Thick lines are 5-day moving average",
       y = "Vertical dimension is STANDARD DEVIATIONs from the mean",
       x = "") +
  theme_tq() 


