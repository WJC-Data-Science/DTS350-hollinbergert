Notes on Chapter 15  factors 

the classic problem is how to sort chronologically rather than alphabetically 
January February March... As opposed to April December January... 

The tool for solving this is a factor 
Creating a factor involves assigning levels in specific sequential order of precedence 
this new factor can be applied to a variable , and then this variable becomes a factor type rather than its original character type .  
it is then sortable in logical rather than alphabetical fashion .

The common syntax is 
y2 <- factor(x2, levels = month_levels)


To see the valid levels that were previously set use :  levels(f2)

To see all of the factors you can use count(variable)
or use a bar chart .  

Use drop = false in the bar chart to show levels for which there were no observations.

You can change the factor order Using fct_reorder to sort one variable based on the values of a second variable .  
These complicated factorisings can best occur in a mutate statement 

You can use  fct_relevel to add levels to existing lists of levels.

You can order the results by increasing frequency using the fct_infreq statement .

In addition to changing the order of the levels, you can change the actual name of the level using fct_recode 

You can collapse smaller groups into aggregates and set the number of resulting groups using the fct_lump and n =  statement.  
It names the aggregated group “Other”.
