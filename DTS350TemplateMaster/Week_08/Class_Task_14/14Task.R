#' ---
#' title: "Task 14 Strings and grep"
#' author: "TomHollinberger"
#' date: "10/13/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#'
#' _________________________________
#'

#'# Task 14 Strings and grep

#' install RVerbalExpressions
library(tidyverse) #to use the stringr package
library(readr) #to read in .txt file
library(RVerbalExpressions)

#' Escape character  
x <- c("\"","\\")
x
writeLines(x)

#'
#'### [ ] Use the readr::read_lines() function to read in each string in randomletters.txt and randomletters_wnumbers.txt.
RandomLetters <- read_lines("https://github.com/WJC-Data-Science/DTS350/raw/master/randomletters.txt")
RandomNumbers <- read_lines("https://github.com/WJC-Data-Science/DTS350/raw/master/randomletters_wnumbers.txt")  #from copy link of the raw button in github

#'
#'### [ ] With the randomletter.txt file, pull out every 1700 letter (e.g. 1, 1700, 3400, …) and 
#'
NewLetterList <- c()
for (i in seq(1, str_length(RandomLetters)/1700)) {
  NewLetterList <- str_c(NewLetterList, str_sub(RandomLetters, start = i*1700, end = i*1700))
}
NewLetterList    
#'### [ ] find the quote that is hidden. The quote ends in a period.  Answer: "The plural of anecdote is not data."
#'
#'
#'### [ ] With the randomletters_wnumbers.txt file, find all the numbers hidden and convert those numbers to letters using the letters order in the alphabet to decipher the message.
NumbersOnly <- c()
NumbersOnly <- str_remove_all(RandomNumbers,("[abcdefghijklmnopqrstuvwxyz]"))    #removes all alphas
NumbersOnly  #interstingly shows double-digit occurrences 10 thru 26
#' Thus, we need to extract cases where 2 numbers are side-by-side as double digits

SingleandDoubleNumbersOnly <- c()
SingleandDoubleNumbersOnly <- str_extract_all(RandomNumbers,("\\d\\d|\\d"))    #extract all double-digits or single digits
SingleandDoubleNumbersOnly

#'Replace numbers with their letters-order alpha counterpart. 
Alpha2Nbrs <- c()
Alpha2Nbrs <- str_replace_all(SingleandDoubleNumbersOnly, c("10" = "j","11" = "k","12" = "l","13" = "m","14" = "n","15" = "o","16" = "p","17" = "q","18" = "r","19" = "s","20" = "t","21" = "u","22" = "v","23" = "w","24" = "x","25" = "y","26" = "z","1" = "a","2" = "b","3" = "c","4" = "d","5" = "e","6" = "f","7" = "g","8" = "h","9" = "i"))
Alpha2Nbrs  #CAUTION"  Must do the double-digit-letters first, because otherwise, str_replace changes 24 to bd, i.e., it breaks a double-digit in to two single digits.
#' "Experts often posses more data than judgment"

#'
NumbersOnly <- c()
NumbersOnly <- str_extract_all(RandomNumbers,("[1234567890]"))    #extract all digits
NumbersOnly

#'
#'
#'### [ ] With the randomletters.txt file, remove all the spaces and periods from the string then find the longest sequence of vowels.
NoSpace <- c()
NoSpace <- str_remove_all(RandomLetters,"\\s")    #removes all spaces 
NoSpace
NoSpacePeriod <- c()
NoSpacePeriod <- str_remove_all(NoSpace,"[.]")   #removes all spaces   Need to figure out how to combine with an OR
NoSpacePeriod  

#' ###[ ] find the longest sequence of vowels.
str_count(RandomLetters, "a{2}")  #89 occurences
str_count(RandomLetters, "a{3}")  #2 occurences
str_count(RandomLetters, "a{4}")  #1 occurences   ****
str_count(RandomLetters, "a{5}")  #0 occurences
str_count(RandomLetters, "a{6}")  #0 occurences
str_count(RandomLetters, "a{7}")  #0 occurences
str_count(RandomLetters, "a{8}")  #0 occurences
str_count(RandomLetters, "e{2}")  #83 occurences
str_count(RandomLetters, "e{3}")  #0 occurences
str_count(RandomLetters, "e{4}")  #0 occurences
str_count(RandomLetters, "e{5}")  #0 occurences
str_count(RandomLetters, "e{6}")  #0 occurences
str_count(RandomLetters, "e{7}")  #0 occurences
str_count(RandomLetters, "e{8}")  #0 occurences
str_count(RandomLetters, "i{2}")  #103 occurences
str_count(RandomLetters, "i{3}")  #2 occurences
str_count(RandomLetters, "i{4}")  #0 occurences
str_count(RandomLetters, "i{5}")  #0 occurences
str_count(RandomLetters, "i{6}")  #0 occurences
str_count(RandomLetters, "i{7}")  #0 occurences
str_count(RandomLetters, "i{8}")  #0 occurences
str_count(RandomLetters, "o{2}")  #81 occurences
str_count(RandomLetters, "o{3}")  #2 occurences
str_count(RandomLetters, "o{4}")  #1 occurences  ****
str_count(RandomLetters, "o{5}")  #0 occurences
str_count(RandomLetters, "o{6}")  #0 occurences
str_count(RandomLetters, "o{7}")  #0 occurences
str_count(RandomLetters, "o{8}")  #0 occurences
str_count(RandomLetters, "u{2}")  #89 occurences
str_count(RandomLetters, "u{3}")  #2 occurences
str_count(RandomLetters, "u{4}")  #0 occurences
str_count(RandomLetters, "u{5}")  #0 occurences
str_count(RandomLetters, "u{6}")  #0 occurences
str_count(RandomLetters, "u{7}")  #0 occurences
str_count(RandomLetters, "u{8}")  #0 occurences

str_locate(RandomLetters,"aaaa")   #starts at position 17827
str_locate(RandomLetters,"oooo")   #starts at position 9260
#'
#'
#'### [ ] Save your .R script to your repository and be ready to share your code solution at the beginning of our next class.
#'
#'
#'