# Notes on dygraphs
# from http://rstudio.github.io/dygraphs/index.html

library(dygraphs)
lungDeaths <- cbind(mdeaths, fdeaths)
dygraph(lungDeaths)


dygraph(lungDeaths) %>% dyRangeSelector()


dygraph(lungDeaths) %>%
  dySeries("mdeaths", label = "Male") %>%
  dySeries("fdeaths", label = "Female") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector(height = 20)


hw <- HoltWinters(ldeaths)
predicted <- predict(hw, n.ahead = 72, prediction.interval = TRUE)

dygraph(predicted, main = "Predicted Lung Deaths (UK)") %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dySeries(c("lwr", "fit", "upr"), label = "Deaths") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"))


#'  Best source is http://rstudio.github.io/dygraphs/gallery-series-options.html
#'  Series Options :  Series colors, changing sloped lines to step functions, filling under graphlines, putting points on lines, changing point shapes, treating different variable series differently, line stokes and types (dashed, thick), can treat groups of series differently,
#'  Series highlighting: bold line on hover, and others fade.
#'  Axis Options: can set axis ranges, can turn on grid, color the axis lines and gridlines, a second y axis, with independent ticks,
#'  Labels & Legends: Main plot title, axis labels, the ticker box is the legend,  legend values can be always shown even without hover, follow allows legen to follow the mouse across the datapoints (not very good), legend width to avoid wrap-around, 
#'  Timezone: USes timezone of the client workstation, or you can change it ,
#'  CSS Styling: change the color of title, axis stuff, etc.
#'  Range Selector:  full-width, or can set the starting zoom-extent, Shiny date windows??
#'  Candlestick Charts:  Uses candlestick ofr O,H,L, and C.  USes line for additionals like Mean.  Can compress to zoom to yearly
#'  Synchronization: can group graphs (facets) and then zoom all together using a click and paint.
#'  Straw Broom: to compare cumulative performance of 2 stocks, can facet by Closing Value, Percent Return, Raw Price (ala None).
#'  Roll PEriods:  Rolling Average of last X periods.
#'  Annotating & Shading:  Small A,B,C box, with a tooltip on hover, can place a note permanently at bottom, etc, Shaded vertical bands can be colored, horizontal shading,
#'  Events & Limits: Event lines (vertical lines denoting event), Limit lines (horizontal denoting thresholds),  
#'  Upper/Lower Bars:  Error Bars and bands, lwr, fit, upr which are predicted from HoltWinters.  Plot an actual and predicted.
#'  Plug Ins: Unzoom adds a rest zoom button,  Crosshairs palces a vertical line down to the axis for whichevr point you hover on.  
#'  Custom Plotters: need to wrap ewach plotter.  Plotters for Bar charts, Multicolumn barcharts, Series like filled line and barchart, very confusing
#'  Colored Ribbon:  Horizontal bottom bar that has red or green strip depending on pos or neg slope of the overarching graph.  Can be vertically stretched to be a wallpaper behind the whole chart.  Good for visualizing categorical variables    
#'           