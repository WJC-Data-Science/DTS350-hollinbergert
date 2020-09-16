#' ---
#' title: "Task 5: InClass Examples"
#' author: "TomHollinberger"
#' date: "9/9/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'
#'# **Day5 InClass Examples: Data Import, Parsing, and ggplot2** 
#'
#' _________________________________
#'   
#'## **Data Import**
#'Here are the primary functions we will use for data import:
#'readr::read_csv()
#'readr::read_delim()
#'readxl::read_excel()
#'Usually the argument for the function is simply the path to the file you want to load.
#'We will mainly use read_csv(). You just need the file name, and then you have the following options:
#'  We have the following options for our read_csv() function:
#'skip = n: skips the first n lines in the file
#'comment = "#": drop all the lines that start with #
#'col_name = FALSE: If your file doesn't have column names, this puts the data starting with that first line in row 1 of the tibble. The column names are then x1, x2, . .
#'col_name = c("a", "b"): File doesn't have column names, but you supply them in the character vector
#'na = ".": Tells what character(s) are used for missing values in the file.
#' Start by loading libraries
library(tidyverse)
library(dplyr)
#'### Example:
#'  First we will download an example csv file from the Urban Institute's Education data portal. Make sure you know where the file is going to download. You might want to run getwd() to see what your working directory is.
#'NOTE: If you are using a PC, you need an extra argument in your download.file() function:
#' THESE 2 LINES OF CODE WAS RUN ONCE WITH ctrl+shift+K, then #'d it out, because it doesn't need to be downloaded every time: 
#'download.file("https://educationdata.urban.org/csv/ipeds/colleges_ipeds_completers.csv",
#'                "colleges_ipeds_completers.csv", mode = "wb")
#'Now we use the read_csv function to load the data.
ipeds <- read_csv("colleges_ipeds_completers.csv")
#' Parsed with column specification:
#' cols(
#'   unitid = col_double(),
#'   year = col_double(),
#'   fips = col_double(),
#'   race = col_double(),
#'   sex = col_double(),
#'   completers = col_double()
#' )
#'We now have a tibble that can be used with ggplot2 to make visualizations and dplyr to modify the data set.
#'When we have a dataset that we want to save to use for later, we can use the write_csv() function to save it. For example, let's create a new data set called ipeds_2011 which contains only the 2011 data from our data set. Then save this data set in the working directory.
ipeds_2011 <- ipeds %>%
  filter(year == 2011)
head(ipeds_2011, n = 10)
write_csv(ipeds_2011, "colleges_ipeds_completers_2011.csv")
getwd()
#' ________________________________________
#'### Exercise:
#'### [1] Filter the ipeds data frome to years 2014-2015 for the state of California (Hint: fips code of 6). Be sure to save this to a new object.  **Done, See Code Below**
ipeds_CA_201415 <- ipeds %>%
  filter(year == 2014 | year == 2015, fips == 6)
head(ipeds_CA_201415,n = 10)
tail(ipeds_CA_201415,n = 10)
#'### [2] Write your new data frame to a file called "ipeds_completers_ca.csv".  **Done, See Code Below**
write_csv(ipeds_CA_201415, "ipeds_completers_ca.csv")
getwd()
#' 
#'## **The readxl Package**
#'We need to load the readxl package.
#' install.packages("readxl")

library(readxl)
#'If we have data saved as .xls or .xlsx, we use the readxl package.
#'________________________________________
#'### Example:
#'  For this example, we will download data from the HUD FHA Single Family LPortfolio Snap Shot.
#' THESE 2 LINES OF CODE WAS RUN ONCE WITH ctrl+shift+K, then #'d it out, because it doesn't need to be downloaded every time: 
#' download.file("https://www.hud.gov/sites/dfiles/Housing/documents/FHA_SFSnapshot_Apr2019.xlsx",
#'              "sfsnap.xlsx", mode = "wb")
#'This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("sfsnap.xlsx")
#' [1] "Title Page"                  "Report Generator April 2019"
#' [3] "Purchase Data April 2019"    "Refinance Data April 2019"  
#' [5] "Definitions"
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
purchases <- read_excel("sfsnap.xlsx", sheet = "Purchase Data April 2019")
#' ________________________________________
#'### Exercise:
#'### [3] Use the read_excel() function to load in the table on the "Refinance Data April 2019" sheet into a data frame called "refinances".   **Done, See Code Below**
refinances <- read_excel("sfsnap.xlsx", sheet = "Refinance Data April 2019")

#' 
#' _________________________________
#'   
#'   
#'## **Parsing**
#'
#'### Example 1:
#'
#' watch out for copy and pasted dblquotemarks, also need space after 
#'   Enter the following code:
money <- c("4,554,25", "$45", "8025.33cents", "288f45")
#'### [4] Use as.numeric(money), and what is your output?  ***You get NA's because some are not numeric***
as.numeric(money)
#'
#'
#'### [5] Use parse_number(money) and compare your output.  ***You get the number-content of these items, the number content is parsed-out***
parse_number(money)

#'
#' These are the types of parsing functions:<br>
#' parse_logical<br>
#' parse_integer<br>
#' parse_date<br>
#' parse_datetime<br>
#' parse_time<br>
#' parse_double<br>
#' parse_character<br>
#' parse_factor<br>
#' 
#' ________________________________________
#' 
#'### Example 2:
#'
#' What happens with the next code?  *** Two Parsing Failures  3a has a trailing character, and 5.4 has a decimal value the 2nd item also creates an NA but isn't listed as a problem.  WHy?? ***
my_string <- c("123", ".", "3a", "5.4")
parse_integer(my_string, na = ".")
#' 
#' If there are a lot of problems, you will need to use problems() to see them all.
#' 
#' 
#' _________________________________
#'   
#'## **Parsing a File**
#' When we read in a csv file, readr will automatically guess the type of each column. We can help it get the right data type, or we can override it entirely.
#' 
#'### Example 3:
#'   Run the code:

challenge <-  read_csv(readr_example("challenge.csv"))

#' *Warning: 1000 parsing failures.*

#' See problems(...) for more details.
#' There were some problems. Run the following:

problems(challenge)
head(challenge)
tail(challenge)

#'### [6] Can you figure out the problems?  ***They are dates stored in a character vector.  We should use a date parser.***
  
#'   Readr reads in 1000 rows to determine what data type to assign. But sometimes it gets it wrong.
#' We want to fix the data type of the y column. If y were just a vector of values, 
#' we would use parse_date(y), but since we are reading in a file, we use col_date(). 
#' Every parse_xyz() function has a corresponding col_xyz() function that we use when we read in files.

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()  #was previously incorrectly guessed to be y = col_logical()
  )
)
#' It is best to specify the col_types for each file.
#'
#' 
#' _________________________________
#'   
#'## **ggplot2**
#' We are going to learn more about labels in our plots.
#' Let's use our plot from our last class:
p <- ggplot(data = iris, mapping = aes(x=Sepal.Width, 
                                         y = Sepal.Length, 
                                         color = Species,
                                         shape = Species),
              size = 5) +
  geom_point() +
  scale_color_brewer(palette = "Set1") 
p


#'## **Labelling the inside of the chart**
#' Labels inside a chart uses library(directlabels). So install that and load it.
#' You can use this library in two different ways: - geom_dl() and - direct.label()
#' need to install first
library(directlabels)
p %>%  direct.label()

#'  or

p + geom_dl(method = "smart.grid", mapping = aes(label = Species)) + theme(legend.position = "none") 

#' Direct labels are nice for line plots. The ?geom_dl() can be helpful.
#' Another technique that is often used is from the package ggrepel. Install and load that package.
#' For these examples, we will use the mpg dataset.
#' 
#'### Example 4:
#'   Consider the following code:

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(cty)) == 1)
best_in_class

#'### [7] What does this code do?  ***It groups by class in descending order(highest first), then takes the first row in each class.  Thus selecting the car with the highest mpg in each class.***
#' 
#' _________________________________
#'   
#'  We can use the data in best_in_class to make labels on our graph.

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5) 

#' That doesn't look very nice. We can use `ggrepel to improve things.
#' Now run the next code and compare the plot to the previous one.

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class, nudge_x = 1.5, nudge_y = 1) 

#'### [8] What did the **ggrepel** part of the code do to the chart? ***It keeps the labels away from each other and any datapoints.***
#'### [9] Compare this chart to the one that doesn't have **nudge_x** and nudge_y. What did the nudge do?  ***It moves labels a declared distance from where they were placed by the system.  The no-nudge default is to place them touching the data point on a random side.***
ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class, nudge_x = 0, nudge_y = 0) 

#'### [10] Remove the border around the car labels by changing geom_label_repel to **geom_text_repel**  .  .  .  ***Done***
ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_text_repel(aes(label = model), data = best_in_class, nudge_x = 1.5, nudge_y = 1) 

#'### [11] Make the labels **color coded**, according to the color of the class of car. ***Added 'color = class' in aes***
ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_text_repel(aes(label = model, color = class), data = best_in_class, nudge_x = 1.5, nudge_y = 1) 


#'### [12] Bonus: move the best in class labels so they **don't cover up data points**.  ***Max'd out nudge_x to 40.  THis vertically aligns the labels on the right side for easy read-down.***
ggplot(mpg, aes(displ, cty)) +
geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_text_repel(aes(label = model, color = class), data = best_in_class, nudge_x = 40, nudge_y = 1) 
#'
#'
#'
#' ________________________________________
#' 
#'## **Altering Non-Data Elements of the chart**
#'
#' Recall our plot p that we defined previously.
p <- ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                       y = Sepal.Length, 
                                       color = Species,
                                       shape = Species),
            size = 5) +
  geom_point() +
  scale_color_brewer(palette = "Set1")
p
#'
#' As we mentioned last class, we can use theme() to change things like axis font and formatting, legends, gridlines, background color, etc.
#' Try to notice structure of the arguments used in theme, and notice how each line alters the chart.
p + theme(
  legend.position = "bottom",             # puts the legend on the bottom
  panel.grid.major.x = element_blank(),   #takes out the major vertical white lines
  panel.grid.minor.x = element_blank(),   #takes out the minor vertical white lines
  axis.ticks.length = unit(6, "pt"))      #puts tickmarks of a certain length on the axis
#' when adding theme, you don't need the p to get it to plot to the lower right screen window

#'
#'### Example 5:
#' 
#'   Alter the code above so that:
#'   
#'### [13] the legend is at the top of the chart.  ***Changed position to "top"***
p + theme(
legend.position = "top",             # puts the legend on the top
panel.grid.major.x = element_blank(),   #takes out the major vertical white lines
panel.grid.minor.x = element_blank(),   #takes out the minor vertical white lines
axis.ticks.length = unit(6, "pt"))      #puts tickmarks of a certain length on the axis
#'
#'### [14] the y minor gridlines are removed.  ***Added: panel.grid.minor.y = element_blank(), ***
p + theme(
  legend.position = "top",                #puts the legend on the top
  panel.grid.minor.y = element_blank(),   #NEW takes out the minor HORZONTAL (y) white lines
  panel.grid.major.x = element_blank(),   #takes out the major vertical white lines
  panel.grid.minor.x = element_blank(),   #takes out the minor vertical white lines
  axis.ticks.length = unit(6, "pt"))      #puts tickmarks of a certain length on the axis
#'
#'
#'
#'
#' ________________________________________
#' 
#'### Helper functions in theme:
#' .	element_text(color, size, face, family, angle, hjust, vjust). Modify appearance of texts
#' .	element_line(color, size, linetype). Modify the appearance of line elements
#' .	element_blank() turns the item off
#' .	unit() Change tick length


#' ________________________________________
#'### Example 6:
#'   We will change our graph so that the orientation of the x-axis text is 35 degrees and the title is centered.
p +
  labs(title = "Comparing 3 Species of Iris") +
  theme(plot.title = element_text(hjust = .5),
        axis.text.x = element_text(angle = 35))
#' 
#'### [15] Make the title font larger using size = rel(2) inside the element_text function. ***Added size = rel(2) to the element_text***
p +
  labs(title = "Comparing 3 Species of Iris") +
  theme(plot.title = element_text(hjust = .5, size = rel(2)),
        axis.text.x = element_text(angle = 35))#'
#'
#'### [16] Make the title right justified. ***Change to hjust = 1 , the max right-side value***
p +
  labs(title = "Comparing 3 Species of Iris") +
  theme(plot.title = element_text(hjust = 1, size = rel(2)),
        axis.text.x = element_text(angle = 35))#'#'
#'
#' ________________________________________

