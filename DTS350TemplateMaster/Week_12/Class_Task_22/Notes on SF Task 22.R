#' ---
#' title: "NOTES on Simple Features SF : 22 InClass : Spatial Information"
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
#' 
#' 
#'   https://dcl-2017-04.github.io/curriculum/
#'   
#'Spatial Data in R
#'Spatial packages

install.packages("sf")

#'Loading data
library(tidyverse)
library(sf)


#'Spatial Visualization
#'Setup :  Since sf is so new, support for it in ggplot2 is also very new. 
#'That means you’ll need to install the development version of ggplot2 from GitHub. 
#'That’s easy to do using the devtools package:
install.packages("devtools")
devtools::install_github("tidyverse/ggplot2")

library(tidyverse)
library(sf)
library(maps)
####DON"T NEED THIS NEXT LINE IF YOU ARE USING USABOUNDARIES  See line 95  my_counties <- us_counties(states = "MO")
nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
states <- sf::st_as_sf(map("state", plot = FALSE, fill = TRUE))

####LOWER 48 STATES, NEED TO FILTER OUT AK, HI, PR, DC

#'The easiest way to get started is to supply an sf object to geom_sf():
ggplot() +
  geom_sf(data = nc)

#'Notice that ggplot2 takes care of setting the aspect ratio correctly.
#'You can supply other aesthetics: for polygons, fill is most useful:
ggplot() +
  geom_sf(aes(fill = AREA), data = nc, colour = "white")  
#####USE fill = NA for no fill


#'When you include multiple layers, ggplot2 will take care of ensuring that they 
#'all have a common CRS so that it makes sense to overlay them.
ggplot() +
  geom_sf(data = states) + 
  geom_sf(data = nc)
#### CODELINE ORDER IS IMPORTANT, THEY LAYER UP.  WITH THE FIRST LINE BEING IN THE BACK

#'You can combine geom_sf() with other geoms. In this case, x and y positions 
#'are assumed be in the same CRS as the sf object (typically these will be longitude and latitude).
ggplot() +
  geom_sf(data = nc) +
  annotate("point", x = -80, y = 35, colour = "red", size = 4)
####BUT these are relative to the map grid.  Good for spotting on a map, but not useful for placing absolutley on the sheet of paper.

#'You want to zoom into a specified region of the plot by using xlim and ylim
ggplot() +
  geom_sf(data = nc) +
  annotate("point", x = -80, y = 35, colour = "red", size = 4) + 
  coord_sf(xlim = c(-81, -79), ylim = c(34, 36))
####LOWER 48 STATES, NEED TO FILTER OUT AK, HI, PR, DC

#'You want to override to use a specific projection. If you don’t specify 
#'the crs argument, it just uses the one provided in the first layer. 
#'The following example uses “USA_Contiguous_Albers_Equal_Area_Conic”. 
#'The easiest way to supply the CRS is as a EPSG ID. I found this ID (26919) with a little googling.
ggplot() +
  geom_sf(data = states) +
  coord_sf(crs = st_crs(26919))

#'USAboundaries   ####THIS GIVES US THE GEOMETRY WE NEED WITHOUT HAVING TO USE THE nc <- read_sf(system.file("shape/nc.shp", package = "sf"), 
install.packages("USAboundaries")
library(USAboundaries)
contemporary_states <- us_states()
my_counties <- us_counties(states = "MO")
ggplot(data = my_counties) +
  geom_sf(fill = NA) +
  labs(title = "Missouri Counties") +
  theme_bw()



# The counties of North Carolina    #NOT NEEDED IF YOU ARE USING USA BOUNDARIES
nc <- read_sf(system.file("shape/nc.shp", package = "sf"), 
              quiet = TRUE,  
              stringsAsFactors = FALSE
)


#'Converting data -- 
#'If you get a spatial object created by another package, 
#'us st_as_sf() to convert it to sf. For example, you can 
#'take data from the maps package (included in base R) and convert it to sf:
library(maps)
#> 
#> Attaching package: 'maps'
#> The following object is masked from 'package:purrr':
#> 
#>     map
nz_map <- map("nz", plot = FALSE)
nz_sf <- st_as_sf(nz_map)


#'Data structure
head(nc)

head(nz_sf)

nc$geometry


#' Use plot() to show the geometry. You’ll learn how to use 
#' ggplot2 for more complex data visualizations later.
plot(nc$geometry)

#'Manipulating with dplyr
#install.packages("lwgeom")
library(lwgeom)

nz_sf %>%
  mutate(area = as.numeric(st_area(geom))) %>%
  filter(area > 1e10)

str(nc$geometry[[1]])

plot(nc$geometry[[1]])

n <- nc$geometry %>% map_int(length)
table(n)

interesting <- nc$geometry[n == 3][[1]]
plot(interesting)

str(interesting)

#'Coordinate system
#'To correctly plot spatial data, you need to know 
#'exactly what the numeric positions mean, i.e. what 
#'are they in reference to? This is called the 
#'coordinate reference system or CRS. Often spatial data 
#'is described in terms of latitude and longitude. You can check this with:
st_is_longlat(nc)

#'To get the datum and other coordinate system metadata, use st_crs():
st_crs(nc)


