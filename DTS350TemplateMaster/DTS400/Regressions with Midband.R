#' ---
#' title: "Regressions with Midband "
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
library(tidyverse)
library(dplyr)
library(readxl)
library(car)
library(corrplot)
library(ggplot2)
#library(ggpmisc)

# not needed since it's on the e drive   download.file("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3",  "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
midband <- read_excel("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3.xlsx", sheet = "GandE with filled blanks", skip = 0)
(midband)

setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/")
getwd()

#MAKE THE MIDBAND OF WJC GPAs between 2.3 and 3.3
midband <- filter(midband, wgpa > 2.3 & wgpa < 3.3)    #Results in 45 observations
#View(midband)


#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
midbandgrads <- filter(midband, status != "Didn't Graduate, but had GPA")
#View(midbandgrads)   #29 students
unique(midbandgrads$status)  #confirms that only one option exist: "Grad with GPA"   
unique(midbandgrads$wgpa)


#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
midbandexits <- filter(midband, status == "Didn't Graduate, but had GPA")
#View(midbandexits)  #16 students
unique(midbandexits$status)  #confirms that only one option exist: "Grad with GPA"   
unique(midbandexits$wgpa)


#YB pg 167 Model Fitting with continuous vars only, then look at diagnostic plots
# from https://data.library.virginia.edu/diagnostic-plots/
midband
x <- midband$hsgpa
y <- midband$wgpa
whmdl <- lm(y~x)

plot(y~x)
abline(whmdl)

whmdl2 <- lm(wgpa ~ hsgpa + mat + eng + rnkneg, midband)
par(mfrow = c(2,2))
plot(whmdl2)
getwd()
ggsave("diagnosticplot_midband_hsg_rnkneg_eng_mat.jpeg",  width = 9, height = 7, units = "in")

#Look at outliers
midbandoutliers <- midband[c(12,45,32,15,22),20:61]  #no apparent pattern    BTW, View only handles 50 columns (variables)
#View(midbandoutliers)


# THROW EVERYTHING IN  Continuous, BDV's and Categorical(except the Categorical Omitted Throwout Variables Race1, HST1, Seg1, and Alum0)
#using Grads and Exits w gpa 
fullge <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
             midband)
summary(fullge)   
#Results:  Midband: AdjR .259  pval = .1676    race7, alum1, rnk, mat       compare to all students(not midband) AdjRsqd = 0.4322      

par(mfrow = c(2,2))
plot(fullge)   #YBpg168     not a good look, especially Cooks Distance
ggsave("diagnosticmidbandplotfullge.jpeg",  width = 9, height = 7, units = "in")



#using Grads only
fullg <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            midbandgrads)
summary(fullg) 
#Original All Students (not just Midband) Results: AdjRsqd = 0.469  p-value: 7.362e-12     Midbandgrads = AdjRqd .4497 ,  pval = .329    NO variables have sig pvals
par(mfrow = c(2,2))
plot(fullg)   #YBpg168   terrible Cook's Distance chart
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")


#using Exits only
fullg <- lm(wgpa ~ race7 + alum1 + rnkneg + tcr + hsgpa + cmp + mat,
            midbandexits)
summary(fullg) 
#Orig All Students (not just Midband) Results:  AdjRsqd = 0.469  p-value: 7.362e-12   Midbandexits = AdjRqd .1533 ,  pval = .294    NO variables have sig pvals
par(mfrow = c(2,2))
plot(fullg)   #YBpg168
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")
   

#Now use Status  (Stat: 2 = Didn't Grad but did have grade  3 = Grad) as DV
midband$stat
fullge <- lm(stat ~ wgpa + race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
             midband)
summary(fullge)    #disregard the error about doTryCatch...
#Stat Results:  Midband: AdjRsqd = .702 pval .001      wgpa, race6(NRA), alum3, tcr, dst, yr

par(mfrow = c(2,2))
plot(fullge)   #YBpg168     not a good look
ggsave("diagnosticmidbandplotfullge.jpeg",  width = 9, height = 7, units = "in")




#using Grads only or Exits only WON'T WORK BECAUSE THEY ARE ALREADY GRADUATES  you get the "perfect fit" error
fullg <- lm(stat ~ wgpa + race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            midbandgrads)
summary(fullg) 
#OriginalResults: AdjRsqd = .0.469  p-value: 7.362e-12     Midbandgrads = AdjRqd -.13 ,  pval = 1    
par(mfrow = c(2,2))
plot(fullg)   #YBpg168
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")
#Results:  AdjRsqd = 0.469  


##Try PRobit

myprobitabbv <- glm(ext ~ wgpa + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + gndr + yr, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)
probitmfx(ext ~ wgpa + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + gndr + yr, data = midband)

#Keep strongest
myprobitabbv <- glm(ext ~ tcr + yr + prnk, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)     #AIC = 46.625


myprobitabbv <- glm(ext ~ tcr + prnk + hsgpa, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)     #AIC = 54


myprobitabbv <- glm(ext ~ tcr, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)     #AIC = 52.74    p=.00691   coeff = -.07


myprobitabbv <- glm(ext ~ prnk, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)     #AIC = 57.22      p=.0264   coeff =  -2.5


myprobitabbv <- glm(ext ~ hsgpa, family = binomial(link = "probit"), 
                    data = midband)
summary(myprobitabbv)     #AIC = 60.897       p=.22    coeff =  -0.54

#Interpretation, in the midband, hsgpa isn't helping
#While it was fresh on my mind, I went ahead and ran some regressions on that mid-band of students with WJC GPA’s between 2.3 and 3.3, where there is a mix of red dots and green dots (Exits and Grads), to see if there were any clues as to what’s influencing people in that transitional band.
#Unfortunately the regression models for predicting WJC GPA were not significant, and only had an adjusted R-squared of 25%  (compared to models A & B we looked at today which had adjusted R-squareds of 38% and 43%). 
#I also ran the version of the model for predicting Grad vs Exit, but they too were not significant, having an overall accuracy of 77% (compared to models C & D we looked at today which had accuracy of 92% and 83%).
#A couple of interesting items,
#Even though the models were not significant overall, three individual variables did stand out as significant:  Transfer Credits, HS Class Rank, and Year Enrolled.  So, you could say that these three have enduring influence even in that transitional band where students are being overwhelmed by various detractors that have them on the cusp of exiting.  
#Exiting students in the midband have surprisingly high ACT scores compared to the Grads in the midband.  For example, the Median Midband Exiting ACT Composite Score was 4 points higher than the Median Midband Graduates’ ACT Composite Score.  That same spread between Exits and Grads in the overall population (i.e., all students, not just the midband) was only .9 .  Midband Exiting students also had higher scores than Midband Grads for Math, Science, English, and Reading.


