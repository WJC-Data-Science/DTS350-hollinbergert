#' ---
#' title: "Day 6: InClass Examples"
#' author: "TomHollinberger"
#' date: "9/13/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'
#'# **Day 6 Examples:  ggplot geom types** 
#' 

#'For all of our examples, we need the tidyverse and ggplot2 libraries.
library(tidyverse)
library(ggplot2)

#'## Bar Graphs

#'For our bar graphs, we will use the data in mtcars.  
#'
#' ### QUESTION:  What is the data type for cyl? 
#' 
#' Run the following script.  This will make our **basic bar chart**.  
#'
#' ###  QUESTION: Do you notice anything strange with the x-axis?
?mtcars  #review the data
str(mtcars)


ggplot(mtcars, aes(x = cyl)) +
  geom_bar()

#' We want to have our values in cyl be categories, not integers, 
#' so we tell R to make those values in cyl **factors**.  
#' We will also adjust some of the objects in the graph.
#' ## FACTOR makes it a categorical (discrete) instead of a continuous

ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(width = 0.5, fill = "blue", alpha = 0.5) +
  theme_bw()
#'
#' ### Complete the code below so that the color is determined by the cylinder type.

#'ggplot(mtcars, aes(x = ______(cyl), fill = ___________)) +
#'  geom_bar() 
#'  
ggplot(mtcars, aes(x = factor(cyl), fill = cyl)) +
  geom_bar()
 
  
#' We will create a graph to show the **number of automatic and manual transmission** based on the cylinder type.
ggplot(mtcars, aes(x = factor(cyl), fill = factor(am))) +
  geom_bar() +
  theme_bw()

#' If we want **better labels** on our data:
library(dplyr)
data <- mtcars %>%
  mutate(am = factor(am, labels = c("auto", "man")),   #mutate replaces if you use same variable name before and after the =
         cyl = factor(cyl))   #factor, categorical, discrete
#'
#' ### QUESTION:  What did the mutate function do to our data set?

ggplot(data, aes(x = cyl, fill = am)) +   #these are now factors
  geom_bar() +
  theme_bw()

#' Note:  Altering our data set is important to get the data in a way we want it for our visualization.


#' We can put **bars side-by-side**

ggplot(data, aes(x = cyl, fill = am)) +
  geom_bar(position = position_dodge()) +  #makes it clustered side by side
  theme_bw()


#' We can make the **bars horizontal**
ggplot(data, aes(x = cyl, fill = am)) +
  geom_bar(position = position_dodge()) + 
  coord_flip() +
  theme_bw()


#' ## Bar Graph Example: 
#' Now we will look at the **each car** and their mpg

#' First create a new data set so we have the data we want for displaying.
df <- mtcars %>%
  rownames_to_column() %>%  #originally rownumbers are car types, this changes 
  as_data_frame() %>%
  mutate(cyl = as.factor(cyl)) %>%
  select(rowname, wt, mpg, cyl)
df

#' ### Basic bar plot
ggplot(df, aes(x = rowname, y = mpg)) +
  geom_col() +
  theme(axis.text.x = element_text(size = rel(.5), angle = 90))  #text labels up and down


#' ### Reorder (sort) row names by mpg values
ggplot(df, aes(x = reorder(rowname, desc(mpg)), y=mpg)) +  #reorder rowname by mpg
  geom_col() +
  theme(axis.text.x = element_text(size = rel(.5), angle = 90))

#' ### Horizontal bar plot
#' Change **fill color by groups** and add text labels
ggplot(df, aes(x = reorder(rowname, mpg), y = mpg)) +
  geom_col(aes(fill = cyl)) +
  geom_text(aes(label = mpg), nudge_y = 2, size = rel(2)) +
  coord_flip() +
  scale_fill_viridis_d()

#'  Conclusion: fewer cyl = better mpg
#'  
#' ## Line Plots
#' For this type of graph, we will use data from economics data frame.
View(economics)
?economics

ggplot(data = economics, aes(x = date, y = pop, size = unemploy/pop)) + 
  geom_line() 

ggplot(data = economics, aes(x = date, y = psavert)) +
  geom_line()

ggplot(data = economics, aes(x = date)) +    #two lines
  geom_line(aes(y = psavert), color = "darkred") +
  geom_line(aes(y = uempmed), color = "steelblue", linetype = "twodash")

#' ### Alternate:  
data_combined <- economics %>%
  select(date, psavert, uempmed) %>%
  gather(key = "variable", value = "value", -date)  #like reshape.  keep date, this puts psave and unemp in the same chart
head(data_combined)
tail(data_combined)

ggplot(data_combined, aes(x = date, y = value)) +   # now we get the legend
  geom_line(aes(color = variable, linetype = variable)) +
  scale_color_manual(values = c("darkred", "steelblue"))


#' ## Box Plots
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_boxplot()

ggplot(mtcars, aes(factor(cyl), mpg)) +    #add color, and side-by-side of auto&manual
  geom_boxplot(aes(color = factor(am)))

ggplot(mtcars, aes(factor(cyl), mpg, color = factor(am))) +    #adds dots to boxplot
  geom_boxplot() +
  geom_jitter()


