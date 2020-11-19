---
title: "25Task: Animated Maps"
author: "TomHollinberger"
date: "11/19/2020"
output: 
 html_document: 
   keep_md: yes
   toc: TRUE
   toc_depth: 6
   code_folding:  hide
   results: 'hide'
   message: FALSE
   warning: FALSE
   echo: FALSE
---  
---  
THIS RSCRIPT USES ROXYGEN CHARACTERS.  
YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS DONE IN A RSCRIPT.
E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_13/analysis/


```r
# Get data:
library(gapminder)
library(ggplot2)
library(gganimate)
```

```
## Warning: package 'gganimate' was built under R version 4.0.3
```

```r
library(gifski) # for gif output
```

```
## Warning: package 'gifski' was built under R version 4.0.3
```

```r
library(USAboundaries)
```

```
## Warning: package 'USAboundaries' was built under R version 4.0.3
```

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(sf)
```

```
## Warning: package 'sf' was built under R version 4.0.3
```

```
## Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 6.3.1
```

```r
#install(rnaturalearth)
#install(rnaturalearthdata)
library(rnaturalearth)
```

```
## Warning: package 'rnaturalearth' was built under R version 4.0.3
```

```r
library(rnaturalearthdata)
```

```
## Warning: package 'rnaturalearthdata' was built under R version 4.0.3
```

```r
library(maps)
```

```
## Warning: package 'maps' was built under R version 4.0.3
```

```r
#Earthquakes  Magnitude 5 or greater, occurring in the last 30 days (2020-10-19 -- 2020-11-16)
# from https://earthquake.usgs.gov/earthquakes/feed/v1.0/csv.php

getwd()
```

```
## [1] "E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_15/Class_Task_25"
```

```r
library(readr)
eqs5 <- read_csv("5eqs.csv",                #requires library(readr)
                 col_names = TRUE)
```

```
## Parsed with column specification:
## cols(
##   .default = col_double(),
##   time = col_datetime(format = ""),
##   magType = col_character(),
##   net = col_character(),
##   id = col_character(),
##   updated = col_datetime(format = ""),
##   place = col_character(),
##   type = col_character(),
##   status = col_character(),
##   locationSource = col_character(),
##   magSource = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

```r
head(eqs5)
```

```
## # A tibble: 6 x 23
##     seq time                  lat   lng depth   mag magType   nst   gap  dmin
##   <dbl> <dttm>              <dbl> <dbl> <dbl> <dbl> <chr>   <dbl> <dbl> <dbl>
## 1     1 2020-10-19 20:54:39  54.6 -160.  31.1   7.6 mww        NA    36 0.225
## 2     2 2020-10-19 21:05:57  54.4 -160.  22.7   5.7 mb         NA   135 0.393
## 3     3 2020-10-19 21:06:20  54.5 -160.  26.2   5.7 mb         NA   150 0.334
## 4     4 2020-10-19 21:14:14  54.3 -160.  16.8   5   mb         NA    93 0.49 
## 5     5 2020-10-19 21:22:28  54.4 -160.  22.6   5.2 mb         NA   127 0.502
## 6     6 2020-10-19 21:32:21  54.4 -160.  26.6   5.5 mb         NA   116 0.463
## # ... with 13 more variables: rms <dbl>, net <chr>, id <chr>, updated <dttm>,
## #   place <chr>, type <chr>, horizontalError <dbl>, depthError <dbl>,
## #   magError <dbl>, magNst <dbl>, status <chr>, locationSource <chr>,
## #   magSource <chr>
```

```r
tail(eqs5)
```

```
## # A tibble: 6 x 23
##     seq time                   lat   lng depth   mag magType   nst   gap  dmin
##   <dbl> <dttm>               <dbl> <dbl> <dbl> <dbl> <chr>   <dbl> <dbl> <dbl>
## 1   119 2020-11-16 15:08:13  27.6  130.   10     5   mb         NA    82 1.68 
## 2   120 2020-11-16 20:18:34 -28.4  -71.1  44.1   5   mb         NA   115 0.217
## 3   121 2020-11-16 22:45:26  -7.03 156.   67.2   5.5 mww        NA    24 4.54 
## 4   122 2020-11-17 01:44:09  -2.68  99.3  10     5.9 mww        NA    23 3.45 
## 5   123 2020-11-17 22:22:07 -14.9  168.   10     5.1 mb         NA   124 0.748
## 6   124 2020-11-18 04:42:00  -1.81 100.   53.5   5.3 mww        NA    43 2.20 
## # ... with 13 more variables: rms <dbl>, net <chr>, id <chr>, updated <dttm>,
## #   place <chr>, type <chr>, horizontalError <dbl>, depthError <dbl>,
## #   magError <dbl>, magNst <dbl>, status <chr>, locationSource <chr>,
## #   magSource <chr>
```

```r
#World Map    This did work, and now it doesn't : FRUSTRATING!   And no error message.
world_map_data <- ne_countries(scale = "medium", returnclass = "sf")
world_map <- map('world', fill = TRUE, plot = FALSE) %>% st_as_sf()

#ggplot() +
#  geom_sf(data = world_map, fill = NA) +
#  theme_bw() 


#Earthquake Pops  This works
#ggplot(eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
#  geom_point() +
#  theme_bw() +
  # gganimate specific bits:
#  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
#  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
#  enter_fade() +
#  exit_fade() +
#  ease_aes('sine-in-out') +
#  shadow_mark(alpha = .3) +
#  guides(colour = FALSE)
```

## PLOT1 : EARTHQUAKES AROUND THE WORLD LAST MONTH
### This animated plot shows 124 earthquakes popping around the world in the last 30 days.
### The size of the circles are relative to the magnitude of the earthquake.
### The circles are somewhat transparent so you can see the build-up of successive earthquakes in the same local.
### The animation uses transition_time, which aparently can't be slowed down.  But animates in sequence according to the time of occurrence 
### It is sort of possible to see spatial patterns in the sequencing of the earthquakes.  For example, you can see a sequence of successive quakes going up and down the island chains north of Australia.  


```r
ggplot() +
  geom_sf(data = world_map, fill = NA) +
  geom_point(data = eqs5, aes(lng, lat, size = mag * 10, color = "red")) +
  theme_bw() +
  # gganimate specific bits:
  labs(title = 'time: {frame_time}', x = 'Longitude', y = 'Latitude') +
  transition_time(time) +    #tansition_time doesn't accept state_length or transition_length arguments, so not sure how to create a slower cycling
  enter_fade() +
  exit_fade() +
  ease_aes('sine-in-out') +
  shadow_mark(alpha = .3) +
  guides(colour = FALSE)
```

![](25Task_files/figure-html/unnamed-chunk-2-1.gif)<!-- -->

