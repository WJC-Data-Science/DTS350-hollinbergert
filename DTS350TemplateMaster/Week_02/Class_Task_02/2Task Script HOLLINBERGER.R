library(tidyverse)
?iris
str(iris)
head(iris)
tail(iris)

#Driving question:  Do different species have different sized Sepals (length, width, and overall area of sepal)?
# Answers:  
# Setosa has larger-sized sepals (area), though they are shorter length.  
# Versicolor has the smallest sepals (area), of medium length.  
# Virginica has small/medium-sized sepals (area), which are the longest of all species.
# Setosa has a wider variation of sizes (area), but a tighter variation of length.

ggplot(data = iris) +
  geom_point(mapping = aes(x = Sepal.Length, y = Sepal.Width*Sepal.Width, color = Species, shape = Species, size = Sepal.Width*Sepal.Length)) +
  facet_wrap(~ Species, nrow = 1)

#WARNING MESSAGE NOTE:
#This code works fine and gives the desired chart, 
#but there's a Warning message "No symbol named 'Sepal.Length' in scope".  
#Similar warning for all variables.




#differnt geom's see cheatsheet for aes levels that each geom understands
?geom_point  #to find aes levels

#streamline with global mapping ch3 streamline put x and y assignments up in the ggplot line




#######
#Task 2 Code excerpts from Chap 4 of Textbook with Comments about new concepts



1 / 200 * 30
#> [1] 0.15
(59 + 73 + 2) / 3
#> [1] 44.7
sin(pi / 2)
#> [1] 1

#object_name <- value
x <- 3 * 4
x
#[1] 12

this_is_a_really_long_name <- 2.5
this_is_a_really_long_name

this_is_a_really_long_name <- 3.5
this_is_a_really_long_name


r_rocks <- 2 ^ 3
#r_rock
#> Error: object 'r_rock' not found   missing s
#R_rocks
#> Error: object 'R_rocks' not found   case sensitive
r_rocks


seq(1,10)

x <- "hello world"



y <- seq(1, 10, length.out = 5)
y
#[1]  1.00  3.25  5.50  7.75 10.00
#length.out slices the whole sequence into that-many equal segments.


####
#Task 2 Code excerpts from Chap 1 of Modern Dive

2 + 1 == 3
#[1] TRUE

2 + 1 = 3
#Error in 2 + 1 = 3 : target of assignment expands to non-language object

# Boolean  == < > <=  >=  != (not equal to).

4 + 2 >= 3
#[1] TRUE


3 + 5 <= 1
#[1] FALSE

#Logical operators: & representing "and" as well as | representing "or." 

(2 + 1 == 3) & (2 + 1 == 4)
#[1] FALSE

(2 + 1 == 3) | (2 + 1 == 4)
#[1] TRUE


#Functions, also called commands:

seq(from = 1, to = 1)
#[1] 1

seq(from = 2, to = 5)
#[1] 2 3 4 5


install.packages("ggplot2")   #need quotes
library(ggplot2)             #don't need quotes

#install nycflights13
library(nycflights13)
library(dplyr)
library(knitr)

flights

airlines

planes

weather

airports

flights
# A tibble: 336,776 x 19    Row count then Column count
  
View(flights)  # use uppercase V.  Opens in a new tab, When done, jump back to Top Tab
glimpse(flights)

airlines
kable(airlines)   #puts data into boxed columns


airlines$name   #lists only airline column data

glimpse(airports)  #shows data values, need to go widescreen

?flights
