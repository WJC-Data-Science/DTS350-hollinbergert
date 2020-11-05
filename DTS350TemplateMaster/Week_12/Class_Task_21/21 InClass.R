## Dygraphs

library(tidyquant) # to get stock data
library(tidyverse) # for pipes
library(dplyr) # for data transformations
library(lubridate) # for date/time functions
library(timetk) # for converting dates to xts
library(dygraphs) # for interactive plots

x1 <- "DHR"
x2 <- "KMX"
x3 <- "CSCO"
end <- today()-days(3)
start <- end - years(2)

x1_prices <- tq_get(x1, get = "stock.prices", from = start, to = end)
x2_prices <- tq_get(x2, get = "stock.prices", from = start, to = end)
x3_prices <- tq_get(x3, get = "stock.prices", from = start, to = end)

My_monthlyReturns <- bind_rows(x1_prices, x2_prices, x3_prices) %>%
  group_by(symbol) %>%
  tq_transmute(adjusted, mutate_fun = monthlyReturn) %>%
  select(symbol, date, monthly.returns) %>%
  pivot_wider(names_from = symbol, values_from = monthly.returns) %>%
  tk_xts(date_var = date)
My_monthlyReturns   # to see it en route, cut one pipe symbol and do a headcall.



dygraph(My_monthlyReturns, main = "Stock Comparison Monthly Returns") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(3, "Set2"), strokeWidth = 2)

My_stockPrices <- bind_rows(x1_prices, x2_prices, x3_prices) %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)
My_stockPrices


dygraph(My_stockPrices, main = "Stock Price Comparison") %>%
  dySeries(x2, strokeWidth = 2) %>% # specific aspects of one line
  dySeries(x1, strokeWidth = 1, strokePattern = "dashed") %>% # specific aspects of the other line
  dySeries(x3, fillGraph = TRUE) %>%
  dyHighlight(highlightCircleSize = 2, 
              highlightSeriesBackgroundAlpha = 0.2,
              hideOnMouseOut = FALSE) %>% # to have each series highlighted
  dyOptions(axisLineColor = "red",
            gridLineColor = "lightblue") %>% # change gridlines, axes
  dyRangeSelector(dateWindow = c("2019-04-12","2020-04-12")) # include range selector

dygraph(My_stockPrices, main = "Straw Broom Chart") %>%
  dyRebase(value = 1000) %>% # shows relative stock performance for given starting value
  dyAnnotation("2020-03-11", text = "A", tooltip = "Pandemic Declared") %>%
  dyShading(from = "2020-02-20", to = "2020-04-07") %>%
  dyRangeSelector()

dygraph(My_stockPrices, main = "Straw Broom Chart Percent") %>%
  dyRebase(percent = TRUE) %>%
  dyShading(from = "2020-02-20", to = "2020-04-07") %>%
  dyAnnotation("2020-02-20", text = "Coronavirus Crash", attachAtBottom = TRUE, width = 60) %>%
  dyRangeSelector()


dyRebased()