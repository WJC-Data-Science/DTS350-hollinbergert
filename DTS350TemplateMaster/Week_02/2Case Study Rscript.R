## Case Study 2 Plots

#First: load packages, inspect the data, transform the data

#tidyverse and dplyr are alreay installed, just need to load
library(tidyverse) # for ggplot2
library(dplyr) # for getting data frame the way we want it
#install, then load gapminder
library(gapminder)
?gapminder
str(gapminder)
#tibble [1,704 x 6] (S3: tbl_df/tbl/data.frame)
#$ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#$ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#$ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
#$ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
#$ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372 12881816 13867957 16317921 22227415 ...
#$ gdpPercap: num [1:1704] 779 821 853 836 740 ...
a <- gapminder
#Find and inspect Kuwait before deleting its row.
(filter(a, country == "Kuwait"))   #12 rows equal to Kuwait
(filter(gapminder, country != "Kuwait"))    #1692 rows without not equal to Kuwait
dfa <- filter(gapminder, country != "Kuwait")
#change population figures to "per 100,000k by dividing by 100000
#caution: mutate overwrites the variable if you use the same variable name on both sides of the equal sign.
dfa <- mutate(dfa, pop = pop/100000) 
#Inspect data one more time
str(dfa)
#tibble [1,692 x 6] (S3: tbl_df/tbl/data.frame)
#$ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
#$ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
#$ year     : int [1:1692] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
#$ lifeExp  : num [1:1692] 28.8 30.3 32 34 36.1 ...
#$ pop      : num [1:1692] 84.3 92.4 102.7 115.4 130.8 ...
#$ gdpPercap: num [1:1692] 779 821 853 836 740 ...
#Interesting, the number of rows is lower (1704 to 1692) because of Kuwait removed.
#But the number of levels (countries) is the same at 142.
#pop now has smaller numbers because of mutate (divide by 100,000)

#dfa (Gapminder sans Kuwait, and with pop100k) is now ready for use in plotting

# Plot 1
#[ ] Use library(tidyverse) to load ggplot2 and dplyr and the theme_bw() to duplicate the first plot.
#[ ] Use scale_y_continuous(trans = “sqrt”) to get the correct scale on the y-axis.
#[ ] Use ggsave() and save each plot as a .png with a width of 15 inches

ggplot(dfa) + 
  geom_point(mapping = aes(x = lifeExp, y = gdpPercap, color=continent, size = pop)) +
  facet_grid(cols = vars(year)) +  
  scale_y_continuous(trans = "sqrt", labels = scales::comma, "GDP per capita") +    #be careful about cut/paste of quote marks
  scale_x_continuous("Life Expectancy") +
  scale_size_continuous("Population (100k)") +
  scale_color_discrete("Continent") +
  theme_bw()
ggsave("CS2Plot1.png", width = 15, units = "in")  #saves to the project folder, overwrites without asking  

#for commas in large numbers, use scale_y_continuous(labels=scales::comma)   
#from https://stackoverflow.com/questions/3993301/how-to-format-number-values-for-ggplot2-legend
 

 


# Plot 2
#[ ] Build weighted average data set using 
#weighted.mean() and GDP with summarise() and group_by() 
?weighted.mean()   #xm <- weighted.mean(x, wt)
# https://statisticsglobe.com/weighted-mean-in-r-example
#that will be the black continent average line on the second plot.
#[ ] Use theme_bw() to duplicate the second plot. You will need to use the new data to make the black lines and dots showing the continent average.
#[ ] Use ggsave() and save each plot as a .png with a width of 15 inches.


#first, need to create wtd average for each continent.


graphAdata <- group_by(dfa, year, continent)
graph2data <- (summarize(graphAdata, wtgdp = weighted.mean(gdpPercap, pop, na.rm = TRUE), contsumpop = sum(pop, na.rm = TRUE)))
# this gets a warning:  "`summarise()` regrouping output by 'year' (override with `.groups` argument)
graph2data
View(graph2data)


#Two dataframes on the same ggplot 
# 1) dfa for color line with points for each country, 
# 2) graph2data for black line with points for each continent, with y = sum for continent & points sized to popln 
#https://stackoverflow.com/questions/27003562/plotting-two-different-data-frames-on-same-figure-in-ggplot2
ggplot() +
  geom_point(data = dfa, mapping = aes(x = year, y = gdpPercap, group = country, color=continent)) +  #group=country is like series=country in Excel
  geom_line(data = dfa, mapping = aes(x = year, y = gdpPercap, group = country, color=continent)) +
  geom_point(data = graph2data, mapping = aes(x = year, y = wtgdp, size = contsumpop),color = "black") +  #group=country is like series=country in Excel
  geom_line(data = graph2data, mapping = aes(x = year, y = wtgdp, color=continent)) +
  facet_grid(cols = vars(continent)) +  
  scale_x_continuous("Year") +
  scale_size_continuous("Population (100k)") +
  scale_y_continuous("GDP per capita") +
  scale_color_discrete("Continent") +
  theme_bw()
ggsave("CS2Plot2.png", width = 15, units = "in")  #saves to the project folder, overwrites without asking
#ggsave("E:/000 DTS 350 Data Visualization/2Case Study/CS2Plot1.png", width = 15, units = "in")

