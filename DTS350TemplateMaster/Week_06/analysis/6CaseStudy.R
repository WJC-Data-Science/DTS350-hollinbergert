#' ---
#' title: "Case Study 6 : Diamonds Are A Girl's Best Friend"
#' author: "TomHollinberger"
#' date: "10/04/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.

library(tidyverse)
library(ggplot2)
library(dplyr)

#'
#'## [ ] Make visualizations to give the distribution of each of the x, y, and z variables in the diamonds data set.
#'
#'### **Graph the X dimension** with ggplot
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = x), binwidth = .25, boundary = 0, color = "white") +
  labs(
    x = "The 'X' dimension",
    y = "Count",
    title = "Number of Diamonds in X dimension Brackets") +
    coord_cartesian(xlim = c(3,10) ) +
    scale_x_continuous(breaks = seq(from = 3.0, to = 10, by = .5)) +
    scale_y_continuous(breaks = seq(from = 0, to = 6000, by = 1000))
#'   
#' ### **Count the X dimension** frequencies with dplyr  -- 
#' #### Insights: Looks like some spurious data in 8 rows where X is between -.125 and +.125 -- likely ZERO.
#' #### Insights: Also some higher than normal values in 10.3 (2 obs), and 10.75 range.
diamonds %>%
  count(cut_width(x,1,boundary = 0))  #keep adjusting the cut_width until 10 buckets can hold the full range: only then can you see the total range of values.
  options(tibble.print_max = Inf) 

#' More detailed count, to see more than 10 buckets.  From the previous code, you know the range is 10.  If you want .25 bin width, you'll need to increase the head-count to 40 
diacount <- count(diamonds, cut_width(x,.25,boundary = 0))
head(diacount, 23)  #goes up to a max of 20, unless you use options tibble...
#' To Print more than 10 rows of a tibble from : https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html
#' options(tibble.print_max = n, tibble.print_min = m)  #if there are more than n rows, print only the first m rows. Use options(tibble.print_max = Inf) to always show all rows.
#' Print All Columns 
#' options(tibble.width = Inf) # will always print all columns, regardless of the width of the screen.

diamonds %>%
  count(cut_width(x,.25, boundary = 0)) 
options(tibble.print_max = Inf)  #this appears to be a toggle on forever situation.

#'
#'### **Graph the Y dimension** with ggplot
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = .25, boundary = 0, color = "white") +
  labs(
    x = "The 'Y' dimension",
    y = "Count",
    title = "Number of Diamonds in Y dimension Brackets") +
  coord_cartesian(xlim = c(3,10) ) +
  scale_x_continuous(breaks = seq(from = 3.0, to = 10, by = .5)) +
  scale_y_continuous(breaks = seq(from = 0, to = 6000, by = 1000))
#'
#' ### **Count the Y dimension** frequencies with dplyr  -- 
#' #### Insights: Looks like some spurious data in 7 rows where y is between -.125 and +.125 -- likely ZERO.
#' #### Insights: Also some higher than normal values in 10.3, 10.5, 31.75, and 59 range.
diamonds %>%
  count(cut_width(y,.25))
#'
#'
#'### **Graph the Z dimension** with ggplot
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = z), binwidth = .25, boundary = 0, color = "white") +
  labs(
    x = "The 'Z' dimension",
    y = "Count",
    title = "Number of Diamonds in Z dimension Brackets") +
  coord_cartesian(xlim = c(0,10) ) +
  scale_x_continuous(breaks = seq(from = 0, to = 40, by = .5)) +
  scale_y_continuous(breaks = seq(from = 0, to = 6000, by = 1000))
#'
#' ### **Count the Z dimension** frequencies with dplyr  -- 
#' #### Insights: Looks like some spurious data in 20 rows where y is between -.125 and +.125 -- likely ZERO.
#' #### Insights: Also a higher than normal value in 31.75 range.
diamonds %>%
  count(cut_width(z,.25, boundary = 0))
#'
#'### **Zoom In on y axis, Zoom out on x-axis** 
#'Zoom-in on the y axis to see the small counts, Zoom-out to full extent of x-axis values
#'
#'#### Insight: Gives a better appreciation of potential outliers.
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = z), binwidth = .25, boundary = 0, color = "white") +
  labs(
    x = "The 'Z' dimension",
    y = "Count",
    title = "Number of Diamonds in Z dimension Brackets") +
  coord_cartesian(xlim = c(0,35) ) +
  coord_cartesian(ylim = c(0,60) ) 
#'
#' ## [ ] Explore the distribution of price. Is there anything unusual or surprising?
#' ### **Graph Price** : a Frequency Distribution of Price with ggplot
#' #### Insight: Initial count to see extent shows prices ranging from zero to $20000.
#' #### Insight: Most frequent occurrences in the 2000 and below range.  A small bump in the $5000 range.
diamonds %>%
count(cut_width(price,1000, boundary = 0))


ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 500, boundary = 0, color = "white") +   #boundary = 0 sets the bins' edges at 1000's aot the centers at 1000's,
  labs(
    x = "Price",
    y = "Count",
    title = "Number of Diamonds in Price Brackets") +
  coord_cartesian(xlim = c(0,20000) ) +
  scale_x_continuous(breaks = seq(from = 0, to = 20000, by = 2000)) +
  scale_y_continuous(breaks = seq(from = 0, to = 10000, by = 1000)) +
  theme(axis.text.x = element_text(angle = 0))

#'
#' ### **Count Price** frequencies with dplyr  -- 
#' #### Insights: Looks like some spurious data in 20 rows where y is between -.125 and +.125 -- likely ZERO.
#' #### Insights: Also a higher than normal value in 31.75 range.
diamonds %>%
  count(cut_width(price,1000, boundary = 0))  #boundary = 0 sets the bins' edges at 1000's aot the centers at 1000's, from https://www.rdocumentation.org/packages/ggplot2/versions/3.3.2/topics/cut_interval
#'
#'
#'## [ ] Can you determine what variable in the diamonds dataset is most important for predicting the price of a diamond? 

#' ### **BOXPLOT Price vs Cut** : shows very little correlation.  Flat, wobbling means.
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
#'
#' ### **BOXPLOT Price vs Color** : shows a slight positive correlation, shallow up-slope of means.
ggplot(data = diamonds, mapping = aes(x = color, y = price)) +
  geom_boxplot()
#'
#' ### **BOXPLOT Price vs Clarity** : actually shows a slight negative correlation, shallow down-slope of means   
ggplot(data = diamonds, mapping = aes(x = clarity, y = price)) +
  geom_boxplot()
#'
#' ### **BOXPLOT Price vs Carat** (20 brackets w/ equal numbers of obs in each) : Shows the STRONGEST CORRELATION WITH PRICE.  For smaller carats, it shows an extremely strong positive correlation betweeen carat and price. For large carats, it shows a flat (lesser) correlation.  
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))
#'
#'
#'## How is that variable (CARAT) correlated with cut? 
#'### Why does the combination of those two relationships lead to lower quality diamonds being more expensive?
#' ### **BOXPLOT Cut vs Carat** : For smaller carats, it shows an extremely strong positive correlation between carat and cut. 
#' For large carats, it shows a flat (lesser) correlation.  
#' As a result, the effect of carats is masking (or collinear with) the effect of cut. SO we need to regress the effect of carats out.
ggplot(data = diamonds, mapping = aes(x = carat, y = cut)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))


#'
#' ## **Regression** to Sort Out the Collinear Effects of Carat and Cut on Price.
library(modelr)  #from textbook section 7.7

mod <- lm(log(price) ~ log(carat), data = diamonds)  #not sure why log-log, but the residuals will be sans the effect of carats.

diamonds2 <- diamonds %>%
  add_residuals(mod) %>%   #adds a column called resid to the dataframe
  mutate(resid = exp(resid))  #exponentiates resid, to reverse the effect of the log-log in the regression model, leaves it in the same column
#'
#'**Graph: Carats vs Resids  **
#'This plot shows residuals tapering smaller (thus a tighter model of/by other non-carat variables, as carats get bigger.  Probably meaning that carats' collinear effect was mostly in the smaller carats. 
ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))  #this plot shows residuals tapering smaller (a tighter model of by other non-carat variables, as carats get bigger.  Probably meaning that carats' collinear effect was mostly in the smaller carats. 

#'
#'### **Graph: Cuts vs Resids  **
#'#### It shows a positive correlation, with the residual (price without the effect of carat) increasing as cut (quality) increases.
ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid)) #using a boxplot because cut is not continuous.  It shows a positive correlation of residual (price without the effect of carat) increasing as cut (quality) increases.
#'  
#'
#'
#'## [ ] Make a visualization of carat partitioned by price.
ggplot(data = diamonds, mapping = aes(x = price, y = carat)) + 
  geom_boxplot(mapping = aes(group = cut_width(price, 1000))) +
  coord_flip() +
  labs(
    x = "Price Brackets",
    y = "carats",
    title = "Distribution of Carat sizes in Price Brackets") +
    scale_x_continuous(breaks = seq(from = 0, to = 20000, by = 1000)) +
  theme(panel.grid.major.y = element_blank())   #takes out the major horizontal white lines

#'
#'### **Graph : Distribution of Prices by Carat Brackets**
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 4, boundary = 0))) +  #same number of obs in each of 4 brackets
#  coord_flip() +
  labs(
    x = "Carat Size Brackets",
    y = "Prices",
    title = "Distribution of Prices for Carat",
    subtitle = "4 carat-brackets with the same number of observations in each") +
    scale_x_continuous(breaks = seq(from = 0, to = 6, by = .5)) +
  scale_y_continuous(breaks = seq(from = 0, to = 20000, by = 2000)) +
  theme(panel.grid.minor.y = element_blank())   #takes out the minor horizontal white lines

#'
#'## [ ] How does the price distribution of very large diamonds compare to small diamonds? Does the data agree with your expectations?
#'### Insight :  The price range for smaller carats (the smallest quartile of carat sizes) is small. As diamonds become larger, and median price rises, the buyers become more sophisticated/discerning,
#'and the variables of cut, color, and clarity become important co-considerations.  
#'These additional variables now influence the price, causing a wider range of price outcomes seen in Carats 1.5 thru 5 (the 4th quartile of carat sizes).
#'
#'### **Graph: Price Distribution of Large Diamonds (4th Quartile of Carat Size)**
#'#### Insights : Large-sized diamonds have a very wide price-variability, compared to small diamonds. Range is about $19000.  Skewed right, with a Median of about $8,500.
large <- diamonds %>%
  filter(carat > 1.04)  #this is the break at Q3 from summary
ggplot(data = large, mapping = aes(x = price, color = "white")) + 
  geom_histogram(binwidth = 100, boundary = 0, color = "white") +
  labs(
    x = "Price",
    y = "Number of Observations",
    title = "Large Size (>75th pctl) :  Distribution of Prices") +  
  theme_bw() 
#'
#'
#'### **Graph: Price Distribution of Small Diamonds**
#'#### Insights : Small-sized diamonds have a narrow price-variability, compared to large diamonds.  Range is about $1500. Not very skewed, with a median of about $750
small <- diamonds %>%
  filter(carat < .4)   #this is Q1 from summary
ggplot(data = small, mapping = aes(x = price, color = "white")) + 
  geom_histogram(binwidth = 100, boundary = 0, color = "white") +
  labs(
    x = "Price",
    y = "Number of Observations",
    title = "Small Size (<25th pctl) :  Distribution of Prices") +  
  theme_bw() 


#'
#'
#'## [ ] Visualize a combined distribution of cut, carat, and price.
#'### **Smoke-Trail Graph** :  The horizontal trail of smoke give a sense of the relationship of Carats and Prices for each Cut (facet).
#'The height of the smoke-trail shows the size (Carat).  Surprisingly, lower quality cuts often have larger sizes (carats) than high quality cuts. 
#'The slope and tightness of the smoke-trail indicates the strength of relationship between Carats and Price.
#'Comparing one facet to another, you can see that Better Cuts (Premium and Ideal) have a wider distribution of prices, than Good and Fair Cuts.   

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = price, y = carat), alpha = 3 / 100) +
  facet_wrap(~ cut, ncol = 1) +
  labs(
    x = "Price",
    y = "Size (Carat)",
    title = "Price by Size, for each Cut") +  
  theme(panel.grid.minor.y = element_blank())   #takes out the minor horizontal white lines


#' ### **Graph: Price vs Carat SCATTERPLOT** : shows a strong correlation in the lower carats (weights), but become very broad in the higher carats and higher price.
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()
#'
#'
#' ### **Graph: Price vs Face Area (X+Y)/2** : This proxy calculation for area takes out the geometric effect of multiplying x & y.
#' ### It shows the STRONGEST correlation -- meaning IT'S ABOUT THE SIZE.
ggplot(data = diamonds, mapping = aes(x = (x+y)/2, y = price)) +
  geom_point() +
  coord_cartesian(xlim = c(3,11) ) +
  scale_x_continuous(breaks = seq(from = 3, to = 11, by = 2))
#'
#'## **Bottomline**
#'In reality the driver is carats (size) because that's what people see/understand the most.  It has the curb appeal.  The naked-eye can't really discern between cut, color, or clarity unless they know what to look for and are within a foot or two, which most observers will never be.  The people who care about cut, color, and clarity are salesmen and investors.  Not people who are in love and just want to prove it with a visible expression; i.e., a big diamond.  

