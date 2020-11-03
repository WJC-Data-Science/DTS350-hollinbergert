## Day 20:  tidyquant and interactives

library(tidyquant)
library(ggplot2)
library(tidyverse)
library(lubridate)

tq_get("NFLX", get = "stock.prices")

# If I were to run the code below, I would get 1.2 million data values 
sp_500 <- tq_index("SP500") %>%
  tq_get(get = "stock.prices")

# The following code transforms that 1.2 million values to 60,000 monthly values
sp_500 %>%
  group_by(symbol) %>%
  tq_transmute(adjusted, mutate_fun = monthlyReturn)

## Exercise:  Get the data for apple "AAPL" from Nov. 3, 2000 until now.
aapl_prices <- tq_get("AAPL", get = "stock.prices", from = "2000-03-02")

aapl_prices

## Exercise Get the data for apple and amazon "AMZN" from Nov. 3, 2000 until Oct. 3, 2010.
amzn_prices <- tq_get("AMZN", get = "stock.prices", from = "2000-03-02", to = "2010-10-03")
library(dplyr)
My_stocks <- bind_rows(aapl_prices, amzn_prices)
tail(My_stocks)

aapl_prices %>%
  ggplot(aes(x = date, y = close)) +
  geom_line() +
  labs(title = "AAPL Line Chart", y = "Closing Price", x= "") +
  theme_tq()

My_stocks %>%
  ggplot(aes(x = date, y = close, color = symbol)) +
  geom_line() +
  labs(title = "AAPL and AMZN Line Chart", y = "close price", x = "") +
  theme_tq()

My_stocks %>%
  ggplot(aes(x = date, y = close, color = symbol)) +
  geom_barchart(aes(open = open, high = high, low = low, close = close)) +
  theme_tq()

## Use the dataset FANG which is FB, AMZN, NFLX, GOOG
end <- as_date("2016-12-31")
start <- end - weeks(6)
data("FANG") 

FANG

FANG %>%
  filter(date >= start - days(2 * 15)) %>%
  ggplot(aes(x = date, y = close, group = symbol)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "FANG Candlestick Chart", 
       subtitle = "Experimenting with Mulitple Stocks",
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(start, end)) +
  facet_wrap(~ symbol, ncol = 2, scale = "free_y") + 
  theme_tq()


## We can use the package timetk for plotting time series:  plot_time_series()
library(timetk)

FANG %>%
  filter(symbol == "FB") %>%
  plot_time_series(date, adjusted, .interactive = FALSE)

FANG %>%
  group_by(symbol) %>%
  plot_time_series(date, adjusted, 
                   .facet_ncol = 2,
                   .interactive = FALSE)
FANG %>%
  mutate(year = year(date)) %>%
  plot_time_series(date, adjusted,
                   .facet_vars = c(symbol, year),
                   .color_var = year,
                   .facet_ncol = 4,
                   .facet_scales = "free",
                   .interactive = FALSE)

FANG %>%
  plot_time_series(date, log(adjusted),
                   .color_var = year(date),
                   .facet_vars = contains("symbol"),
                   .facet_ncol = 2,
                   .facet_scales = "free",
                   .y_lab = "Log Scale",
                   .interactive = FALSE)

## We can easily plot a seasonality plot
FANG %>%
  filter(symbol == "GOOG") %>%
  plot_seasonal_diagnostics(date, adjusted, .interactive = FALSE)

## Interactives: 
## DT
## plotly
## timetk
## dygraphs

# DT:
library(DT)
datatable(iris)

# timetk
FANG %>%
  filter(symbol == "FB") %>%
  plot_time_series(date, adjusted)

# dygraphs: we must have our data as xts
library(dygraphs)

FANG_xts <- FANG %>%
  select(symbol, date, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  tk_xts(date_var = date)

dygraph(FANG_xts)




dygraph(FANG_xts, main = "FANG data") %>%
  dySeries("FB", label = "Facebook") %>%
  dySeries("GOOG", label = "Google") %>%
  dySeries("AMZN", label = "Amazon") %>%
  dySeries("NFLX", label = "Netflix") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyAxis("y", label = "Adjusted", valueRange = c(10, 2000)) %>%
  dyLegend(width = 300) %>% 
  dyRangeSelector()


#'###END OF IN CLASS EXAMPLES




#from  https://github.com/business-science/tidyquant/blob/master/vignettes/TQ01-core-functions-in-tidyquant.Rmd

data("FANG")
FANG

#For a detailed walkthrough of the compatible functions, 
#see the next vignette in the series, 
#[R Quantitative Analysis Package Integrations in tidyquant]
#(TQ02-quant-integrations-in-tidyquant.html).

## 3.1 Transmute Quantitative Data, tq_transmute 

#Transmute the results of `tq_get()`. 
#Transmute here holds almost the same meaning as in `dplyr`, 
#only the newly created columns will be returned, but with `tq_transmute()`, 
#the number of rows returned can be different than the original data frame. 
#This is important for changing periodicity. 
#An example is periodicity aggregation from daily to monthly, and print last-day-of-month.

FANG %>%
  group_by(symbol) %>%
  tq_transmute(select = adjusted, mutate_fun = to.monthly, indexAt = "lastof")
#
#Let's go through what happened. `select` allows you to easily choose what 
#columns get passed to `mutate_fun`. In example above, `adjusted` selects the 
#"adjusted" column from `data`, and sends it to the mutate function, `to.monthly`, 
#which mutates the periodicity from daily to monthly. 
#Additional arguments can be passed to the `mutate_fun` by way of `...`. 
#We are passing the `indexAt` argument to return a date that matches the first date in the period. 

### Working with non-OHLC data

#Returns from FRED, Oanda, and other sources do not have open, high, low, close (OHLC) format. 
#However, this is not a problem with `select`. 
#The following example shows how to transmute WTI Crude daily prices to monthly prices. 
#Since we only have a single column to pass, 
#we can leave the `select` argument as `NULL` which selects all columns by default. 
#This sends the price column to the `to.period` mutate function. 
#Results i the WTI Price at the last day of each month.

wti_prices <- tq_get("DCOILWTICO", get = "economic.data") 
wti_prices %>%    
    tq_transmute(mutate_fun = to.period,  #rollup i.e., aggregation into monthly.
                 period     = "months",
                 col_rename = "WTI Price")


## 3.2 Mutate Quantitative Data, tq_mutate 

#Adds a column or set of columns to the tibble with 
#the calculated attributes (hence the original tibble is returned, 
#mutated with the additional columns). 
#An example is getting the `MACD` from `close`, which mutates 
#the original input by adding MACD and Signal columns. 
#Note that we can quickly rename the columns using the `col_rename` argument.


FANG %>%
    group_by(symbol) %>%
    tq_mutate(select     = close, 
              mutate_fun = MACD, 
              col_rename = c("MACD", "Signal"))

#Note that a mutation can occur if, and only if, 
#the mutation has the same structure of the original tibble. 
#In other words, the calculation must have the same number of 
#rows and row.names (or date fields), 
#otherwise the mutation cannot be performed.

### Mutate rolling regressions with rollapply

#A very powerful example is applying __custom functions__ 
#across a rolling window using `rollapply`. 
#A specific example is using the `rollapply` function 
#to compute a rolling regression. 
#This example is slightly more complicated so it will be broken down into three steps:

#1. Get returns
#2. Create a custom function
#3. Apply the custom function accross a rolling window using `tq_mutate(mutate_fun = rollapply)`

#_Step 1: Get Returns_

#First, get combined returns. 
#The asset and baseline returns should be in wide format, 
#which is needed for the `lm` function in the next step

fb_returns <- tq_get("FB", get  = "stock.prices", from = "2016-01-01", to   = "2016-12-31") %>%
tq_transmute(adjusted, periodReturn, period = "weekly", col_rename = "fb.returns")
xlk_returns <- tq_get("XLK", from = "2016-01-01", to = "2016-12-31") %>%
    tq_transmute(adjusted, periodReturn, period = "weekly", col_rename = "xlk.returns")
returns_combined <- left_join(fb_returns, xlk_returns, by = "date")
returns_combined

tq_mutate_fun_options()
#_Step 2: Create a custom function_

#Next, create a custom regression function, 
#which will be used to apply over the rolling window in Step 3. 
#An important point is that the "data" will be passed to the 
#regression function as an `xts` object. The `timetk::tk_tbl` function 
#takes care of converting to a data frame for the `lm` function to work 
#properly with the columns "fb.returns" and "xlk.returns".

regr_fun <- function(data) {
    coef(lm(fb.returns ~ xlk.returns, data = timetk::tk_tbl(data, silent = TRUE)))
}


#_Step 3: Apply the custom function_

#Now we can use `tq_mutate()` to apply the custom regression function 
#over a rolling window using `rollapply` from the `zoo` package. 
#Internally, since we left `select = NULL`, the `returns_combined` 
#data frame is being passed automatically to the `data` argument of 
#the `rollapply` function. All you need to specify 
#is the `mutate_fun = rollapply` and any additional arguments 
#necessary to apply the `rollapply` function. We'll 
#specify a 12 week window via `width = 12`. 
#The `FUN` argument is our custom regression function, `regr_fun`. 
#It's extremely important to specify `by.column = FALSE`, 
#which tells `rollapply` to perform the computation using the data 
#as a whole rather than apply the function to each column independently. 
#The `col_rename` argument is used to rename the added columns.

returns_combined %>%
    tq_mutate(mutate_fun = rollapply,
              width      = 12,
              FUN        = regr_fun,
              by.column  = FALSE,
              col_rename = c("coef.0", "coef.1"))
returns_combined


#As shown above, the rolling regression coefficients were added to the data frame.



## 3.3 _xy Variants, tq_mutate_xy and tq_transmute_xy

#Enables working with mutation functions that require 
#two primary inputs (e.g. EVWMA, VWAP, etc).

### Mutate with two primary inputs

#EVWMA (exponential volume-weighted moving average) 
#requires two inputs, price and volume. 
#To work with these columns, we can switch to the xy variants,
#`tq_transmute_xy()` and `tq_mutate_xy()`. 
#The only difference is instead of the `select` argument, 
#you use `x` and `y` arguments to pass the columns needed 
#based on the `mutate_fun` documentation.

FANG %>%
    group_by(symbol) %>%
    tq_mutate_xy(x = close, y = volume, 
                 mutate_fun = EVWMA, col_rename = "EVWMA")







