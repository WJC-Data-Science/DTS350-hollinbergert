---
title: "Notes from Chap 18 and 20"
author: "editor TomHollinberger"
date: "9/22/2020"
output: 
  html_document: 
    keep_md: yes
    toc: TRUE
    toc_depth: 6
---

# 18 Pipes

## 18.1 Introduction : Clearly expressing a sequence of multiple operations
Pipes are a powerful tool for clearly expressing a sequence of multiple operations. So far, you’ve been using them without knowing how they work, or what the alternatives are. Now, in this chapter, it’s time to explore the pipe in more detail. You’ll learn the alternatives to the pipe, when you shouldn’t use the pipe, and some useful related tools.

### 18.1.1 Prerequisites : load the **tidyverse** package
The pipe, %>%, comes from the magrittr package by Stefan Milton Bache. Packages in the tidyverse load %>% for you automatically, so you don’t usually load magrittr explicitly. Here, however, we’re focussing on piping, and we aren’t loading any other packages, so we will load it explicitly.

## 18.2 Piping alternatives
The point of the pipe is to help you write code in a way that is easier to read and understand. To see why the pipe is so useful, we’re going to explore a number of ways of writing the same code. Let’s use code to tell a story about a little bunny named Foo Foo:
Little bunny Foo Foo
Went hopping through the forest
Scooping up the field mice
And bopping them on the head
This is a popular Children’s poem that is accompanied by hand actions.
We’ll start by defining an object to represent little bunny Foo Foo:

And we’ll use a function for each key verb: hop(), scoop(), and bop(). Using this object and these verbs, there are (at least) four ways we could retell the story in code:
1.	Save each intermediate step as a new object.
2.	Overwrite the original object many times.
3.	Compose functions.
4.	Use the pipe.
We’ll work through each approach, showing you the code and talking about the advantages and disadvantages.

### 18.2.1 Intermediate steps -- simple, but many intermediate elements
The **simplest approach** is to save each step as a new object:
The main downside of this form is that it forces you to **name each intermediate element**. If there are **natural names**, this is a good idea, and you should do it. But many times, like this in this example, there aren’t natural names, and you add numeric suffixes to make the names unique. That leads to two problems:
1.	The code is **cluttered** with unimportant names
2.	You have to carefully increment the suffix on each line.
Whenever I write code like this, I invariably use the wrong number on one line and then spend 10 minutes scratching my head and trying to figure out what went wrong with my code.
You may also worry that this form creates **many copies** of your data and takes up a lot of memory. Surprisingly, that’s not the case. First, note that proactively worrying about memory is not a useful way to spend your time: worry about it when it becomes a problem (i.e. you run out of memory), not before. Second, R isn’t stupid, and it will share columns across data frames, where possible. Let’s take a look at an actual data manipulation pipeline where we add a new column to ggplot2::diamonds:

 gives the memory occupied by all of its arguments. The results seem counterintuitive at first:
•	diamonds takes up 3.46 MB,
•	diamonds2 takes up 3.89 MB,
•	diamonds and diamonds2 together take up 3.89 MB!
How can that work? Well, diamonds2 has 10 columns in common with diamonds: there’s no need to duplicate all that data, so the two data frames have variables in common. These variables will only get copied if you modify one of them. In the following example, we modify a single value in diamonds$carat. That means the carat variable can no longer be shared between the two data frames, and a copy must be made. The size of each data frame is unchanged, but the collective size increases:

### 18.2.2 Overwrite the Original -- Not recommended

### 18.2.3 Function composition -- hard for a human to understand
Another approach is to abandon assignment and just string the function calls together:.  Here the **disadvantage** is that you have to read from inside-out, from right-to-left, and that the arguments end up spread far apart (evocatively called the dagwood sandwhich problem). In short, this code is **hard for a human** to consume.

### 18.2.4 **Use the pipe**  verbs(adj = dirobj) then pass to next line for next verb
Finally, we can use **the pipe**:

**foo_foo %>%
  hop(through = forest) %>%
  scoop(up = field_mice) %>%
  bop(on = head)**

This is my **favourite** form, because it focusses on verbs, not nouns. You can read this series of function compositions like it’s a set of imperative actions. Foo Foo hops, then scoops, then bops. 
The pipe works by performing a *“lexical transformation”**: behind the scenes, magrittr reassembles the code in the pipe to a form that works by overwriting an intermediate object. When you run a pipe like the one above, magrittr does something like this:

This means that the *pipe won’t work for **two classes of functions:
1.	Functions that use the current environment. For example, *assign() ** will create a new variable with the given name in the current environment:
2.	assign("x", 10)
3.	x
4.	> [1] 10
5.	
6.	"x" %>% assign(100)
7.	x

stop("!") %>% 
  tryCatch(error = function(e) "An error")

## 18.3 When not to use the pipe -- less than ten steps, multi-inputs/outputs 
The pipe is a powerful tool, but it’s not the only tool at your disposal, and it doesn’t solve every problem! *Pipes are most useful for rewriting a fairly short linear sequence of operations**. I think you should reach for another tool when:

### 18.3.1	Your pipes are **longer than (say) ten steps**. In that case, create **intermediate objects with meaningful names**. That will make debugging easier, because you can more easily check the intermediate results, and it makes it easier to understand your code, because the variable names can help communicate intent.

### 18.3.2	You have *multiple inputs or outputs**. If there isn’t one primary object being transformed, but two or more objects being combined together, don’t use the pipe.
•	You are starting to think about a **directed graph** with a complex dependency structure. Pipes are fundamentally linear and expressing complex relationships with them will typically yield confusing code.

## 18.4 tidyverse automatically makes %>% available
All packages in the  for you, so you don’t normally load magrittr explicitly. 


# 20 Vectors

## 20.2 Vector basics
There are two types of vectors:

### 20.2.1 Atomic vectors, of which there are six types: logical, integer, double, character, complex, and raw. 
Integer and double vectors are collectively known as numeric vectors.

### 20.2.2 Lists, aka recursive vectors because lists can contain other lists.
The chief difference between atomic vectors and lists is that atomic vectors are homogeneous, while lists can be heterogeneous. There’s one other related object: NULL. NULL is often used to represent the absence of a vector (as opposed to NA which is used to represent the absence of a value in a vector). NULL typically behaves like a vector of length 0. Figure 20.1 summarises the interrelationships.
 
Figure 20.1: The hierarchy of R’s vector types

### 20.2.3 Every vector has two key properties:  type and length
1.	Its type, which you can determine with typeof().
2.	typeof(letters)
3.	> [1] "character"
4.	typeof(1:10)  > [1] "integer"
5.	Its length, which you can determine with length().
6.	x <- list("a", "b", 1:10)
7.	length(x)  > [1] 3
Vectors can also contain arbitrary additional metadata in the form of attributes. These attributes are used to create augmented vectors which build on additional behaviour. There are three important types of augmented vector:

### 20.2.4 Built-On's
•	Factors are built on top of integer vectors.
•	Dates and date-times are built on top of numeric vectors.
•	Data frames and tibbles are built on top of lists.


## 20.3 Important types of atomic vector : Big $: logical, integer, double, charact
The four most important types of atomic vector are logical, integer, double, and character. Raw and complex are rarely used during a data analysis, so I won’t discuss them here.

### 20.3.1 Logical – False, True, NA    used in comparisons

### 20.3.2 Numeric – includes integer and double.
1.	Doubles are approximations. Doubles represent floating point numbers that can not always be precisely represented with a fixed amount of memory. This means that you should consider all doubles to be approximations. For example, what is square of the square root of two?
Instead of comparing floating point numbers using ==, you should use dplyr::near() which allows for some numerical tolerance.

### 20.3.3 Character : each element is a sting and can contain an arbitrary amount of data
Character vectors are the most complex type of atomic vector, because each element of a character vector is a string, and a string can contain an arbitrary amount of data.

### 20.3.4 Missing values : varies by vector type
Note that each type of atomic vector has its own missing value:
NA            # logical   > [1] NA
NA_integer_   # integer    > [1] NA
NA_real_      # double    > [1] NA
NA_character_ # character   > [1] NA
Normally you don’t need to know about these different types because you can always use NA and it will be converted to the correct type using the implicit coercion rules described next. However, there are some functions that are strict about their inputs, so it’s useful to have this knowledge sitting in your back pocket so you can be specific when needed.

## 20.4 Using atomic vectors : converting, type-check, diff lengths, naming, extracting
Now that you understand the different types of atomic vector, it’s useful to review some of the important tools for working with them. These include:
1.	How to convert from one type to another, and when that happens automatically.
2.	How to tell if an object is a specific type of vector.
3.	What happens when you work with vectors of different lengths.
4.	How to name the elements of a vector.
5.	How to pull out elements of interest.

### 20.4.1 Coercion :  as.integer()  as.double()
There are two ways to convert, or coerce, one type of vector to another:
1.	Explicit coercion happens when you call a function like as.logical(), as.integer(), as.double(), or as.character(). Whenever you find yourself using explicit coercion, you should always check whether you can make the fix upstream, so that the vector never had the wrong type in the first place. For example, you may need to tweak your readr col_types specification.
2.	Implicit coercion happens when you use a vector in a specific context that expects a certain type of vector. For example, when you use a logical vector with a numeric summary function, or when you use a double vector where an integer vector is expected.
Because explicit coercion is used relatively rarely, and is largely easy to understand, I’ll focus on implicit coercion here.
You’ve already seen the most important type of implicit coercion: using a logical vector in a numeric context. In this case TRUE is converted to 1 and FALSE converted to 0. That means the sum of a logical vector is the number of trues, and the mean of a logical vector is the proportion of trues:
x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)  # how many are greater than 10?  > [1] 38
mean(y) # what proportion are greater than 10?  > [1] 0.38
You may see some code (typically older) that relies on implicit coercion in the opposite direction, from integer to logical:
if (length(x)) {
  # do something
}
In this case, 0 is converted to FALSE and everything else is converted to TRUE. I think this makes it harder to understand your code, and I don’t recommend it. Instead be explicit: length(x) > 0.
It’s also important to understand what happens when you try and create a vector containing multiple types with c(): the most complex type always wins.
typeof(c(TRUE, 1L))   > [1] "integer"
typeof(c(1L, 1.5))   > [1] "double"
typeof(c(1.5, "a"))   > [1] "character"
An atomic vector can not have a mix of different types because the type is a property of the complete vector, not the individual elements. If you need to mix multiple types in the same vector, you should use a list, which you’ll learn about shortly.

### 20.4.2 Test functions :  check to see if it’s a certain type of vector    is.xxxx()
Sometimes you want to do different things based on the type of vector. One option is to use typeof(). Another is to use a test function which returns a TRUE or FALSE. Base R provides many functions like is.vector() and is.atomic(), but they often return surprising results. Instead, it’s safer to use the is_* functions provided by purrr, which are summarised in the table below.
	lgl	int	dbl	chr	list
is_logical()	x				
is_integer()		x			
is_double()			x		
is_numeric()		x	x		
is_character()				x	
is_atomic()	x	x	x	x	
is_list()					x
is_vector()	x	x	x	x	x
Each predicate also comes with a “scalar” version, like is_scalar_atomic(), which checks that the length is 1. This is useful, for example, if you want to check that an argument to your function is a single logical value.

### 20.4.3 Scalars and recycling rules – auto-adjusting lengths of vestors
As well as implicitly coercing the types of vectors to be compatible, R will also implicitly coerce the length of vectors. This is called vector recycling, because the shorter vector is repeated, or recycled, to the same length as the longer vector.
This is generally most useful when you are mixing vectors and “scalars”. I put scalars in quotes because R doesn’t actually have scalars: instead, a single number is a vector of length 1. Because there are no scalars, most built-in functions are vectorised, meaning that they will operate on a vector of numbers. That’s why, for example, this code works:
Here, R will expand the shortest vector to the same length as the longest, so called recycling. This is silent except when the length of the longer is not an integer multiple of the length of the shorter:
While vector recycling can be used to create very succinct, clever code, it can also silently conceal problems. For this reason, the vectorised functions in tidyverse will throw errors when you recycle anything other than a scalar. If you do want to recycle, you’ll need to do it yourself with rep():

### 20.4.4 Naming vectors -- any vector can be named
All types of vectors can be named. You can name them during creation with c():
c(x = 1, y = 2, z = 4)   > x y z    > 1 2 4
Or after the fact with purrr::set_names():
set_names(1:3, c("a", "b", "c"))   > a b c    > 1 2 3
Named vectors are most useful for subsetting, described next.

### 20.4.5 Subsetting – filtering rows of tibbles
So far we’ve used dplyr::filter() to filter the rows in a tibble. filter() only works with tibble, so we’ll need new tool for vectors: [. [ is the subsetting function, and is called like x[a]. There are four types of things that you can subset a vector with:
1.	A numeric vector containing only integers. The integers must either be all positive, all negative, or zero.
Subsetting with positive integers keeps the elements at those positions:

## 20.7 Augmented vectors – factors, dates, date-times, tibbles
Atomic vectors and lists are the building blocks for other important vector types like factors and dates. I call these augmented vectors, because they are vectors with additional attributes, including class. Because augmented vectors have a class, they behave differently to the atomic vector on which they are built. In this book, we make use of four important augmented vectors:
•	Factors
•	Dates
•	Date-times
•	Tibbles
These are described below.

### 20.7.1 Factors  -- categorical data, fixed set of levels (possible values)
Factors are designed to represent categorical data that can take a fixed set of possible values. Factors are built on top of integers, and have a levels attribute:
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)   > [1] "integer"
attributes(x)   > $levels   > [1] "ab" "cd" "ef"   > $class     > [1] "factor"

### 20.7.2 Dates and date-times  -- since 1 Jan 1970
Dates in R are numeric vectors that represent the number of days since 1 January 1970.
Date-times are numeric vectors with class POSIXct that represent the number of seconds since 1 January 1970. (In case you were wondering, “POSIXct” stands for “Portable Operating System Interface”, calendar time.)
POSIXlts are rare inside the tidyverse. They do crop up in base R, because they are needed to extract specific components of a date, like the year or month. Since lubridate provides helpers for you to do this instead, you don’t need them. POSIXct’s are always easier to work with, so if you find you have a POSIXlt, you should always convert it to a regular data time lubridate::as_date_time().

### 20.7.3 Tibbles – have vectors with the same length 
Tibbles are augmented lists: they have class “tbl_df” + “tbl” + “data.frame”, and names (column) and row.names attributes:

The difference between a tibble and a list is that all the elements of a data frame must be vectors with the same length. All functions that work with tibbles enforce this constraint.
Traditional data.frames have a very similar structure:
The main difference is the class. The class of tibble includes “data.frame” which means tibbles inherit the regular data frame behaviour by default.
 

