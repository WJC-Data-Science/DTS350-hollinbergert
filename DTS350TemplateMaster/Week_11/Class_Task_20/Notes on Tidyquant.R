#Built for analyzing stocks and portfolios. 
#Gives access to financial in economic data. 
#"At scale" which means of millions of data points 
#includes Federal Reserve and Yahoo an Morningstar sources 

#tq get()    
#Stock.prices includes hi,low, open, close and adjusted for individual stocks 
#or entire indexes like the SP500.

#tq transmute()  and  tq mutate()      
#there are many built-in financial functions .  Use tq_transmute_fun_options() to see them all.

#Use group_by  symbol,  
#then pair it with the monthly.returns function. To get monthly returns for each symbol.

#tq performance() and tq portfolio()
