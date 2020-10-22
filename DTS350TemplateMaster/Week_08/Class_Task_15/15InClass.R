library(tidyverse)
library(nycflights13)

# our tables:  airlines, airports, planes, weather, flights
head(airlines)
head(airports)
head(planes)
head(weather)
head(flights)

# Sometimes it is good to check that your key is a primary key and uniquely identifies observations.
#' will NOT be primary if it shows up more than once.
#' 
planes %>%
  count(tailnum) %>%
  filter(n > 1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, tailnum) %>%
  filter(n > 1)
#' none here

# If we want to make a primary key, we can use mutate() and row_number() to make a surrogate key.


## Joins

# To make things easier to see, we will narrow down our variables in our data

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)  #make it smaller first
flights2

# Add the full airline name to our data set
flights2 %>%
  select(-origin, -dest) %>%    #
  left_join(airlines, by = "carrier")

# A natural join 
flights2 %>%
  left_join(weather)

# Careful with natural joins that you don't join something that isn't the same.
# Combine flights data with airports data.
flights2 %>%
  left_join(airports, c("dest" = "faa"))

flights2 %>%
  left_join(airports, c("origin" = "faa"))

# Filtering joins

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

# Now to find all the flights that went with those destinations.
flights %>%
  semi_join(top_dest)

# Are there any flights that don't have a plane?
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

