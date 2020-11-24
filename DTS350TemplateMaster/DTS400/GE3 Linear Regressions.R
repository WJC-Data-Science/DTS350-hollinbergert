#' ---
#' title: "GE3 Linear Regressions "
#' author: "TomHollinberger"
#' date: "11/22/2020"
#' output: 
#'  html_document: 
#'    keep_md: yes
#'    toc: TRUE
#'    toc_depth: 6
#'    #'    code_folding:  hide
#'    results: 'hide'
#'    message: FALSE
#'    warning: FALSE
#' ---  
#' ---  
#' THIS RSCRIPT USES ROXYGEN CHARACTERS.  
#' YOU CAN PRESS ctrl+shift+K AND GO STRAIGHT TO A HTML.  
#' SKIPS THE HANDWORK OF CREATING A RMD, AFTER THE ORIGINAL WORK IS NONE IN A RSCRIPT.
#' sample filepath E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/
#' 
#' # Linear Regression

library(tidyverse)
library(dplyr)
library(readxl)
library(car)
library(corrplot)
library(ggplot2)
#library(ggpmisc)

# not needed since it's on the e drive   download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE2",  "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwfb <- read_excel("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3.xlsx", sheet = "GandE with filled blanks", skip = 0)
(GEwfb)

setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/GE3 Linear Regression/")
getwd()


GEwfbcorvars <- select(GEwfb, wgpa, rnkneg, siz, prnk,	engsem,	tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, hst, alum, rac, seg, nm, gndr, yr, ext, stat)
#str(GEwfbcorvars)
corrplot.mixed(cor(GEwfbcorvars), upper = "ellipse")   #problems with blanks in wgpa, shows ? in wgpa col and row
 
#Take out the "No GPA on record, so now it's: Grads and Exits with gpas, and with filled blanks
GEwgpawfb <- filter(GEwfb, status != "No GPA on record")
#View(GEwgpawfb)
unique(GEwgpawfb$status)  #confirms that only two options exist: "Didn't Graduate, but had GPA" "Grad with GPA"   
unique(GEwgpawfb$wgpa)  

GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, siz, prnk,	engsem,	tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, hst, alum, rac, seg, nm, gndr, yr, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")  

#Now use levels of categorical variables for segment
GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, seg1, seg2, seg3, seg4, seg5, seg6)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")   

#Now add in levels for categorical and binary variables
GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, seg1, seg2, seg3, seg4, seg5, seg6, race1, race2, race3, race4, race5, race6, race7, alum0, alum1, alum2, alum3, hst1, hst2, hst3, hst4, nm, gndr, yr, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")   
ggsave("corrplotalllevels.jpeg",  width = 9, height = 7, units = "in")

GEwgpawfbtopcorrels <- select(GEwgpawfb, wgpa, hsgpa,	rnkneg, mat,	eng,	cmp,	rdg, sci,	tcr, gndr, seg1, race7, seg6, hst1, hst4, nm, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbtopcorrels), upper = "ellipse")   
ggsave("corrplotalllevels.jpeg",  width = 9, height = 7, units = "in")





par()  
#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
Gradswfb <- filter(GEwgpawfb, status != "Didn't Graduate, but had GPA")
#View(Gradswfb)
unique(Gradswfb$status)  #confirms that only one options exist: "Grad with GPA"   
unique(Gradswfb$wgpa)

par(mfrow = c(0,0))
par(mfcol = c(0,0))
#this toggles the plot area.  
#Do a corrplot matrix from YBpg163 to see correlation coeffs.  See what's strong, and what's interrelated
#select only continuous numeric columns  (copy and paste from light green col headers in excel, then throw in commas)
# Doesn't work  shows ? in WGPA cells
GEwgpawfb_contin_num <- select(GEwgpawfb, wgpa, rnkneg, tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg)
#View(GEwgpawfb_contin_num)
corrplot.mixed(cor(GEwgpawfb_contin_num), upper = "ellipse")


ggsave("corrplot5.jpeg",  width = 9, height = 7, units = "in")


## Recommendation: Keep rnk, drop siz, prnk, rksz, and sizrnk.  
## Recommendation: Consider culling some of the ACT scores, since they are inter-correlated.  MAT and ENG have highest correlation to wgpa.
## However, the subset ACT scores may help show a distinction between Majors Groups (Segments)


#Try scatterplot (YBpg162)to view distributions, and see if we want to transform
scatterplotMatrix(GEwgpawfb_contin_num)  #this shows some, but will rearrange the order to facilitate a screenshot
GEwgpawfb_contin_num_select <- select(GEwgpawfb, wgpa, rnkneg, hsgpa, tcr, eng, rdg)
scatterplotMatrix(GEwgpawfb_contin_num_select) 
getwd()
ggsave("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/scatterplotMAtrix1.jpeg",  width = 9, height = 7, units = "in")
# Are not normal-looking and need to be transformed.  See the YBpg102



# MOVE ONTO LINEAR REGRESSION



#YB pg 167 Model Fitting with continuous vars only, then look at diagnostic plots
# from https://data.library.virginia.edu/diagnostic-plots/
GEwgpawfb_contin_num
x <- GEwgpawfb_contin_num$hsgpa
y <- GEwgpawfb_contin_num$wgpa
whmdl <- lm(y~x)

plot(y~x)
abline(whmdl)

whmdl2 <- lm(wgpa ~ hsgpa + mat + eng + rnkneg, GEwgpawfb_contin_num)
par(mfrow = c(2,2))
plot(whmdl2)
getwd()
ggsave("diagnosticplot_hsg_rnkneg_eng_mat.jpeg",  width = 9, height = 7, units = "in")

#Look at outliers
GEwgpawfb_contin_num[c(1,2,3,8,15,20),]  #they are mostly low wgpa's and likely non-grads



GEwgpawfb


# THROW EVERYTHING IN  Continuous, BDV's and Categorical(except the Categorical Omitted Throwout Variables Race1, HST1, Seg1, and Alum0)
#using Grads and Exits w gpa 
fullge <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            GEwgpawfb)
summary(fullge)    #disregard the error about doTryCatch...
#Results:  AdjRsqd = .0.4322   

par(mfrow = c(2,2))
plot(fullge)   #YBpg168
ggsave("diagnosticplotfullge.jpeg",  width = 9, height = 7, units = "in")



#using Grads only
fullg <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            Gradswfb)
summary(fullg) 
#Results:  AdjRsqd = .0.469   
par(mfrow = c(2,2))
plot(fullg)   #YBpg168
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")
#Results:  AdjRsqd = 0.469   p-value: 7.362e-12 

#FULLGE, Standardize the continuous variables to see which one is strong  YB7.3.3 pg 175
GEwgpawfb
GEwgpawfb[,37:50]
GEwgpawfb.std <- GEwgpawfb
GEwgpawfb.std[,37:50] <- scale(GEwgpawfb.std[,37:50]) 
GEwgpawfb.std[,37:50]

fullgestd <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
             GEwgpawfb.std)
summary(fullgestd)    
#Results:  AdjRsqd = 0.4322  
#copy these summary(full) to excel, text to column, sort by Pr(>>|t|), smallest are most accurate, but also look at the coeff to see which are the strongest.

par(mfrow = c(2,2))
plot(fullgestd)   #YBpg168
ggsave("diagnosticplotfullgestd.jpeg",  width = 9, height = 7, units = "in")

#FULG Grads only, Standardize the continuous variables to see which one is strong  YB7.3.3 pg 175
Gradswfb[,37:50]
Gradswfb.std <- Gradswfb
Gradswfb.std[,37:50] <- scale(Gradswfb.std[,37:50]) 
Gradswfb.std[,37:50]

fullgstd <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
                Gradswfb.std)
summary(fullgstd)    
#Results:  AdjRsqd = .469   same as before 
#copy these summary(full) to excel, text to column, sort by Pr(>>|t|), smallest are most accurate, but also look at the coeff to see which are the strongest.

par(mfrow = c(2,2))
plot(fullgstd)   #YBpg168
ggsave("diagnosticplotfullgstd.jpeg",  width = 9, height = 7, units = "in")

# ala https://statisticsbyjim.com/regression/interpret-coefficients-p-values-regression/
#Copied these summary(full) to excel, text to column, sort by Pr(>|t|), smallest are most accurate, but also look at the coeff to see which are the strongest.



#Throw out the bottom 
#Keptthose with Pr(>|t|) < .25


library(ggplot2)
library(ggstance)
library(jtools)
library(broom.mixed)

# from  https://cran.r-project.org/web/packages/jtools/vignettes/summ.html

tophalfIVs <- lm(wgpa ~ hsgpa + rnkneg + hst3 + dst + gndr + rdg + mat + alum3 + cmp + hst2 + race7 + yr + tcr + race2 + seg3 + race5,
              data = GEwgpawfb)
summary(tophalfIVs)
par(mfrow = c(1,1))
plot_summs(tophalfIVs, scale = TRUE, plot.distributions = FALSE, inner_ci_level = .9, legend.title = "tophalfIVs") 
#plotted int eh order they were typed into model line
par(mfrow = c(2,2))
plot(tophalfIVs)
ggsave("diagnosticplottophalfIVs.jpeg",  width = 9, height = 7, units = "in")

GEwgpawfb$hst3

#Now cull down to the statistically significant IVs, manually ordered by Pr>|t|)
StatSigIVs <- lm(wgpa ~ rnkneg + gndr + hst3 + mat + dst + hsgpa + rdg,
                 data = GEwgpawfb)
summary(StatSigIVs)   #give adjRsqd = .438 

#Now throw out rdg because it has become less than significant
StatSigIVs <- lm(wgpa ~ rnk + gndr + hst3 + mat + dst + hsgpa,
                 data = GEwgpawfb)
summary(StatSigIVs)   #gives adjRsqd = .4345 

par(mfrow = c(1,1))
#need to reverse order
StatSigIVsrev <- lm(wgpa ~ hsgpa + dst + mat + hst3 + gndr + rnk,
                 data = GEwgpawfb)
plot_summs(StatSigIVsrev, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9, legend.title = "StatSigIVs") 
#plotted in the reverse order they were typed into model line    # scale = true makes the x scale a standard deviation scale
par(mfrow = c(2,2))
plot(StatSigIVs)
ggsave("diagnosticplotStatSigIVs.jpeg",  width = 9, height = 7, units = "in")




#Our Classic Suite of IVs
ClassicIVs <- lm(wgpa ~ rnk + hsgpa + mat + eng + rdg + cmp + sci + tcr,
                 data = GEwgpawfb)
summary(ClassicIVs)  #gives adjRsqd = .3894
# 
par(mfrow = c(1,1))
#need to reverse order
ClassicIVsrev <- lm(wgpa ~ tcr + sci + cmp + rdg + eng + mat + hsgpa + rnk,
                    data = GEwgpawfb)
plot_summs(ClassicIVsrev, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9, legend.title = "ClassicIVs") 
#plotted in the reverse order they were typed into model line  # scale = true makes the x scale a standard deviation scale

#plot both models on the same graph
plot_summs(ClassicIVsrev, StatSigIVsrev, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9) 

par(mfrow = c(2,2))
plot(ClassicIVs)
ggsave("diagnosticplotClassicIVs.jpeg",  width = 9, height = 7, units = "in")

#Conveniently, our Classics are all Continuous, so let's regress using the standardized form, so we can compaore strength of coefficientsOur
# Our STANDARDIZED Classic Suite of IVs
Std.ClassicIVs <- lm(wgpa ~ rnkneg + hsgpa + mat + eng + rdg + tcr + sci + cmp,
                 data = GEwgpawfb.std)
summary(Std.ClassicIVs)   #gives adj Rsq = .3894
par(mfrow = c(1,1))
plot_summs(Std.ClassicIVs, scale = TRUE, plot.distributions = FALSE, inner_ci_level = .9, legend.title = "Standardized ClassicIVs") 
#plotted int eh order they were typed into model line
par(mfrow = c(2,2))
plot(Std.ClassicIVs)
ggsave("diagnosticplotStd.ClassicIVs.jpeg",  width = 9, height = 7, units = "in")


# Only Statistically Significant IVs  Pr <.05  using standardized continuous variables
Std.StatSigIVs <- lm(wgpa ~ rnkneg + gndr + hst3 + mat + dst + hsgpa + rdg,
                     data = GEwgpawfb.std)
summary(Std.StatSigIVs)
par(mfrow = c(1,1))
plot_summs(Std.StatSigIVs, scale = TRUE, plot.distributions = FALSE, inner_ci_level = .9, legend.title = "Standardized Statisticallt Significant IVs") 
#plotted int eh order they were typed into model line
par(mfrow = c(2,2))
plot(Std.StatSigIVs)
ggsave("diagnosticplotStd.Stat.sigIVs.jpeg",  width = 9, height = 7, units = "in")





fitgrads <- lm(wgpa ~ tcr + hsgpa + cmp + mat + sci + eng + rdg,
               data = grads)
plot_summs(fitgrads, scale = TRUE, plot.distributions = FALSE, inner_ci_level = .9, legend.title = "GRADS")

fitexits <- lm(wgpa ~ tcr + hsgpa + cmp + mat + sci + eng + rdg,
               data = exits)
plot_summs(fitexits, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9, legend.title = "EXITS")

plot_summs(fitboth, fitgrads, fitexits, scale = TRUE, plot.distributions = TRUE)


#from http://r-statistics.co/Assumptions-of-Linear-Regression.html
#install gvlma
library(gvlma)
par(mfrow=c(2,2))  # draw 4 plots in same window
mod <- lm(wgpa ~ gndr, data=grads)
gvlma::gvlma(mod)

plot(mod)


#from http://r-statistics.co/Assumptions-of-Linear-Regression.html
#install gvlma
library(gvlma)
par(mfrow=c(2,2))  # draw 4 plots in same window
mod <- lm(wgpa ~ gndr, data=grads)
gvlma::gvlma(mod)

plot(mod)



#from http://r-statistics.co/Assumptions-of-Linear-Regression.html
#install gvlma
library(gvlma)
par(mfrow=c(2,2))  # draw 4 plots in same window
mod <- lm(wgpa ~ gndr + hst3 + mat + dst + hsgpa + rdg, data=grads)
gvlma::gvlma(mod)

plot(mod)


#from http://r-statistics.co/Assumptions-of-Linear-Regression.html
#install gvlma
library(gvlma)
par(mfrow=c(2,2))  # draw 4 plots in same window
mod <- lm(wgpa ~ rnk + hsgpa + mat + tcr, data=grads)
gvlma::gvlma(mod)
plot(mod)



