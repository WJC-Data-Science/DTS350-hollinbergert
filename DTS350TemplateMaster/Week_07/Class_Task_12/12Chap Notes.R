#' ---
#' title: "Chap 12 : Tidy Data"
#' author: "TomHollinberger"
#' date: "10/06/2020"
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
#'Tables show the same underlying data in different ways.
#'Here are predefined-in-tidyverse Tables
table1  #it's tidy
#'  country      year  cases population
#'  <chr>       <int>  <int>      <int>


#'
table2  #not tidy, it has cases and population in the same TYPE column
#'country      year type            count
#' <chr>       <int> <chr>           <int>
#' 
table3 #not tidy it has cases/population in the rate column
#'country      year rate             
#'* <chr>       <int> <chr>       
#'
table4a  # not tidy: it has two year columns and cases in both year columns, but no popln data
#' country     `1999` `2000`
#'* <chr>        <int>  <int>
  
table4b  #not tidy: it has two year columns and popln in both year columns, but no case data
#'country         `1999`     `2000`
#'* <chr>            <int>      <int>
#'
#'
#'

#'Variables in columns
#'Observations in rows
#'values in cells
#'Nothing Missing, Nothing Extra.
#'No dupes, no blanks
#'Put each dataset in a tibble
#'
#' Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)

#'
#'# Compute SUM OF cases per year.  INTERSTING use of count and weight (wt) to get a sum
table1 %>% 
  count(year, wt = cases)


# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)



#' Visualise changes over time -- Slope Chart with three countries, before adn after (1999 to 2000)
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))



#'PIVOTING
#'
#'Most data is untidy
#'
#'
#'12.3.1 LONGER -- when offending column names are actually values (e.g.,1999, 2000).  Need to create an omnibus column (Year) and put the values in the new year column.  AND need to create a new column for the original cell contents (CASES) of the offending columns (1999,2000) to go to.

#' STEP 1:  GIVEN:
table4a  #known but unspoken to contain cases data in cells
table4b  #known but unspoken to contain population data in cells

#' STEP 2:  Take Tablea and make a cases column
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
#' 1999, 2000 are known columns, that need to become values in an omnibus YEAR column.
#' NOTE: the offending values were cases in the offending 1999 and 2000 columns.  THey need to go to a new Cases column.
#'
#'Note, backticks for Column names that are numbers.  How to type a backtick?
#'
#' STEP 3:  Take Tableb and make a population column
table4b %>% 
pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")


#' STEP 4:JOIN the Two Tables together    
library(dplyr)


tidy4a <- table4a %>%     #repeat of previous step, saving to tidy4a
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>%     #repeat of previous step, saving to tidy4b
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
tidy4a4b <- left_join(tidy4a, tidy4b)    #join  
tidy4a4b    #result

#'tidy4a     country     year       cases
#'tidy4b     country     year     population
#'tidy4a4b   country     year   cases   population
#'
#'12.3.2 WIDER
#'
#'table2 has cases and population in the same (COUNT)column and distinguishes cases from puiplotaion numbers by a (TYPE) column,
#' need to go wider by splitting the TYPE COLUMN into columns for each of its known but not spoken levels (CAses,Population), then put values in their respective columns.
table2wider <-table2 %>%
  pivot_wider(names_from = type, values_from = count)
table2wider    #new improved with  country  year  cases  population

#'12.4.1 SEPARATING
table3  #has 785/19900000   cases/population data in a single cell & column called rate


table3sep1 <- table3 %>% 
  separate(rate, into = c("cases", "population"))   #sdefault delimiter is any non-alphanumeric
table3sep1
#'  We could specify the delimiter
table3sep2 <- table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")
table3sep2


#'USING SEPARATE to also convert column type for the new columns.
table3sepconvert <- table3 %>% 
separate(rate, into = c("cases", "population"), convert = TRUE)
table3sepconvert   # case and population are now integers


#' USING SEPARATE to also tell it where to split (by position number).
table3sepsplit <- table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)  #cut after the 2nd char of the original YEAR column, if you were splitting into three new columns you could give it 2 new split positions and could use negative number for splitting

table3
table3sepsplit   # 19  and 99,  20 and 00



#' UNITE 
table5   # has century and year split into 2 separate columns.  country     century year  rate  

table5united <- table5 %>%
  unite(newyear, century, year, sep = "")   #1 is new column, #2&3 are the to-be-combined columns.  the sep="" ensures that you don't get the default undersore between the two combined elements.
table5united  


#'
#'from 12.3.3Exercises
stocks <- tibble(
	  year   = c(2015, 2015, 2016, 2016),
	  half  = c(   1,    2,     1,    2),
	  return = c(1.88, 0.59, 0.92, 0.17)
	)
stocks
#'      year  half return
#'     <dbl> <dbl>  <dbl>
#'   1  2015     1   1.88
#'   2  2015     2   0.59
#'   3  2016     1   0.92
#'   4  2016     2   0.17
	stockswide <- stocks %>% 
	  pivot_wider(names_from = year, values_from = return) #takes the names from YEAR col for the new columns, puts in new cell values from RETURN col.
	stockswide
#'	      half `2015` `2016`
#'	     <dbl>  <dbl>  <dbl>
#'	  1     1   1.88   0.92
#'  	2     2   0.59   0.17
	
#'now go long	
	
		  
  stockslong <- stockswide %>% 
	  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")
    stockslong
 
#'    half year  return   #year has become a character , used to be dbl
#'   <dbl> <chr>  <dbl>
#'1     1 2015    1.88
#'2     1 2016    0.92
#'3     2 2015    0.59
#'4     2 2016    0.17
     
  #'(Hint: look at the variable types and think about column names.)

#'pivot_longer() has a names_ptype argument, e.g. names_ptype = list(year = double()). 
#'
#'
#'
#'
#'
#'12.5 MISSING VALUES
    #'Explicilty flagged with NA   -- known unknowns
    #'Implicitly: just blank       -- unknown unknowns
    #'
    #'You can make implicit missing values explicit by REHAPING (going wider then longer).  THey are not symetrical, so longer doesn't undo wider.
#'
#'Staring Tibble     
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),  #2015,Q4 is explicitly missing, 2016,Q1 is implicitly missing
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks
#'year   qtr return
#'<dbl> <dbl>  <dbl>
#'  1  2015     1   1.88
#'2  2015     2   0.59
#'3  2015     3   0.35
#'4  2015     4  NA   
#'5  2016     2   0.92
#'6  2016     3   0.17
#'7  2016     4   2.66
#'        
#' Now Pivot Wider
stockswider <- stocks %>% 
  pivot_wider(names_from = year, values_from = return)
stockswider
#'      qtr `2015` `2016`
#'     <dbl>  <dbl>  <dbl>
#' 1     1   1.88   NA     #NOTICE it shows the implicitly missing 2016,Q1
#' 2     2   0.59   0.92
#' 3     3   0.35   0.17
#' 4     4   NA     2.66#'      
#'        
#' Now Pivot Longer with values_drop_na = TRUE to go back to only showing explicitly missing variables, BUT now Year is a char, when it used to be dbl.          

stockslonger <- stockswider %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )
stockslonger
#'  qtr year  return
#'  <dbl> <chr>  <dbl>
#'  1     1 2015    1.88
#'  2     2 2015    0.59
#'  3     2 2016    0.92
#'  4     3 2015    0.35
#'  5     3 2016    0.17
#'  6     4 2016    2.66


#' EXPOSE ALL IMPLICITS BASED ON A 2D GRID, USING COMPLETE
  
stockscomplt <- stocks %>%
  complete(year, qtr)     #exposes any implicitly missing values based on the year x qtr grid
stockscomlpt

#' year   qtr return
#' <dbl> <dbl>  <dbl>          YEAR is still a dbl
#' 1  2015     1   1.88
#' 2  2015     2   0.59
#' 3  2015     3   0.35
#' 4  2015     4  NA   
#' 5  2016     1  NA   
#' 6  2016     2   0.92
#' 7  2016     3   0.17
#' 8  2016     4   2.66
#'            
#'  
#'                
#' FILL :  LOCF  LASt Observation Carried Forward  CARRY THE PREVIOUS VALUE FORWARD
#' String tibble with missing values
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment

#'    person           treatment response
#'    <chr>                <dbl>    <dbl>
#' 1 Derrick Whitmore         1        7
#' 2 NA                       2       10
#' 3 NA                       3        9
#' 4 Katherine Burke          1        4


#'  USE fill() REPLACES WITH THE MOST RECENT MISSiNG VALUE

trmtfill <- treatment %>%
  fill(person)
trmtfill

#' ?fill     fill(pet_type, .direction = "up")  can be down, updown, downup for multiple NAs stacked


#'     person           treatment response
#'    <chr>                <dbl>    <dbl>
#' 1 Derrick Whitmore         1        7
#' 2 Derrick Whitmore         2       10
#' 3 Derrick Whitmore         3        9
#' 4 Katherine Burke          1        4
#' 

library(dplyr)

#'  CASE STUDY
#'  
#'  
who   #big tibble 7240 x 60    
#'   country iso2  iso3   year   new_sp_m014     new_s
#'   <chr>   <chr> <chr> <int>       <int>        <int>        <int>        <int>        <int>
#'1 Afghan~ AF    AFG    1980          NA           NA           NA           NA           NA
#'2 Afghan~ AF    AFG    1981          NA           NA           NA           NA           NA country iso2  iso3   year new_sp_m014 new_sp_m1524 plus 50+ more variables


#'Gather together all unknown columns and send the Offending Column name to KEY, and send the offending cell values to new CASES column (assuming the cell value is the count of cases.)
who1 <- who %>%
  pivot_longer(cols = new_sp_m014:newrel_f65, names_to = "key", values_to = "cases", values_drop_na = TRUE)
who1


who1 <- who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE)
who1


#'> # A tibble: 76,046 x 6
#'>   country     iso2  iso3   year key          cases
#'>   <chr>       <chr> <chr> <int> <chr>        <int>
#'> 1 Afghanistan AF    AFG    1997 new_sp_m014      0
#'> 2 Afghanistan AF    AFG    1997 new_sp_m1524    10
#'> 3 Afghanistan AF    AFG    1997 new_sp_m2534     6




who1 %>%
count(key)

#' REcap Code  
who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65,     
    #Gather together all unknown columns and send the Offending Column name to KEY, 
    #and send the offending cell values to new CASES column 
    #(assuming the cell value is the count of cases.)
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")   #for consistency replace all newrel with new_rel
  ) %>%
  separate(key, c("new", "var", "sexage")) %>%    #split KEY into three new cols default is char-delimited at _.
  select(-new, -iso2, -iso3) %>%     # drop three unneeded columns
  separate(sexage, c("sex", "age"), sep = 1)   #split sexage with position-delimted after char#1.

