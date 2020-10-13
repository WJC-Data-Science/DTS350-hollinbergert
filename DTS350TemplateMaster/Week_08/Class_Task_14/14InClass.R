library(tidyverse) #to use the stringr package
library(readr) #to read in .txt file

# Escape character
x <- c("\"","\\")
x
writeLines(x)

# Load our text file
RandomLetters <- read_lines("https://github.com/WJC-Data-Science/DTS350/raw/master/randomletters.txt")

# What is the length of the string?
str_length(RandomLetters)

# Remove all the 'e' and 'a' letters and then find out how long the string is.
RandomLetters1 <- RandomLetters %>%
  str_remove_all("[ae]")
str_length(RandomLetters1)

# How many times is 'jim' in the string?
str_count(RandomLetters, "jim")

# Can you find any other names in the string?
NameString <- c("tom","connor","brooks","jim","chase","chance","brady")
str_detect(RandomLetters, NameString)
str_count(RandomLetters, NameString)

# Show all the sequences with 5 of the same letter in a row in the file without a's and e's. (Backreferences)
str_detect(RandomLetters1, ("(.)\\1{4}")) # capture a letter, match that 4xs.
str_extract_all(RandomLetters1, ("(.)\\1{4}"))

# Show all the sequences 'rp-xx' where - can be any letter, and xx is the same repeated letter
str_detect(RandomLetters, "rp(.)(.)\\2")
str_extract_all(RandomLetters, "rp(.)(.)\\2")

# Show all palendromes of length 6.
str_extract_all(RandomLetters, "(.)(.)(.)\\3\\2\\1")

# Which character locations have three 'a's in a row?
str_locate(RandomLetters, "a{3}")

# Split the characters so each letter is an individual item in a vector.
str_split(RandomLetters, "")

# Create a new list comprised of every 10th character
NewLetterList <- c()
for (i in seq(1, str_length(RandomLetters)/10)) {
  NewLetterList <- str_c(NewLetterList, str_sub(RandomLetters, start = i*10, end = i*10))
}