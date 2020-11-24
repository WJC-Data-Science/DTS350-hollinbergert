#' ---
#' title: "GE4 PRobit "
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

# PROBIT PRACTICE

library(tidyverse)
library(dplyr)


library(tidyverse)
library(dplyr)
library(readxl)
library(ggplot2)
#library(ggpmisc) #for annotate with npc   #doesn't load without crashing
setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/")
#download.file("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/WORKFILE3",
#             "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("WORKFILE3.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwofb <- read_excel("WORKFILE3.xlsx", sheet = "GandE without filled blanks")
GEwofb
prbt <- GEwofb               # was in GE read_csv("PROBIT DATA incl no grades.csv")
prbt    #looks good, all columns came over, BUT almost all are dbl except for chars: hs,sex,initprgm,src,race,nm1
str(prbt)    #BUT almost all are dbl except for chars: hs,sex,initprgm,src,race,nm1
prbt$ext    #shows up as 0';'s an 1's, which is good

#Pink and Blue Stacked Dots
#PLOT a HISTOGRAM OF GRADES, with grouping by Exit or Not  (use onlythose students with grades (i.e., not Did-Not-Attends))
prbtwgrds <- filter(prbt, wgpa > 0.1)  
summary(prbtwgrds$wgpa)   #cut out all without a grade (could be no shows)  range is now 1.64 to 4.0
(prbtwgrds$ext) 
prbtwgrds$ext <- as.factor(prbtwgrds$ext)
ggplot(data = prbtwgrds) +
  geom_dotplot(mapping = aes(x = wgpa, group = ext, fill = ext), method = "histodot", binwidth = .1, dotsize = .4, stackgroups = TRUE) +   #boundary = 0 sets the bins' edges at 1000's aot the centers at 1000's,
  labs(
    x = "WJC GPA",
    y = "Count",
    title = "Number of WJC Students in GPA Brackets",
    subtitle = "Includes Grads and Non-Grads with GPA's on record") +
  coord_cartesian(xlim = c(1.60,4.1), ylim = c(0,50)) +
  scale_x_continuous(breaks = seq(from = 1.60, to = 4.0, by = .1)) +
  scale_y_continuous(breaks = seq(from = 0, to = 30, by = 5)) +
  theme(axis.text.x = element_text(angle = 75, vjust = .5, hjust = .5))


# from https://stats.idre.ucla.edu/r/dae/probit-regression/

## convert rac, hst, alum, and seg to factor (categorical variable)
prbtwgrds$rac <- as.factor(prbtwgrds$rac)
prbtwgrds$hst <- as.factor(prbtwgrds$hst)
prbtwgrds$alum <- as.factor(prbtwgrds$alum)
prbtwgrds$seg <- as.factor(prbtwgrds$seg)

str(prbtwgrds)   #confirm that they have become factors

#Run the Regression ALL-IN-MODEL
myprobit <- glm(ext ~ race1 + race2 + race3 + race4 + race5 + race6 + race7 + hst1 + hst2 + hst3 + hst4 + alum0 + alum1 + alum2 + alum3 + seg1 + seg2 + seg3 + seg4 + seg5 + seg6 + rnk + siz + engsem + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + wgpa + nm + gndr + yr, family = binomial(link = "probit"), 
                data = prbtwgrds)

## model summary
summary(myprobit)   #AIC 60, lower is better


#Now pick the 11 best Pr>|z| values
myprobitabbv <- glm(ext ~ hst2 + race5 + alum1 + tcr + hsgpa + cmp + mat + sci + rdg + dst + wgpa, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 64.053, lower is better

##### 

#Run a set if single IVs and track on a excel spreadsheet PROBIT SINGLE IVs MODEL RUNS, in the ORIG LIST folder
myprobitabbv <- glm(ext ~ yr, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC lower is better     Pr(>|z|) should be < .05


#######

#Run Using Statistically Sig (P<.10) from the Single IV Models
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + rnk + tcr + mat + yr + race5 + gndr, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 63.68, lower is better


#Run Using Statistically Sig (P<.05) from the Single IV Models
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + rnk + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 59.743, lower is better

#Run Using Statistically Sig (P<.05) AND Manually throwing out PRNK
myprobitabbv <- glm(ext ~ wgpa + hsgpa + rnk + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 58.286, lower is better

#Run Using Statistically Sig (P<.05) AND Manually throwing out RNK, put prnk back in
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 57.797, lower is better  BEST MODEL

#Run Using Statistically Sig (P<.05) Throw from the bottom (mat)
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 61.724, NOT BETTER lower is better

#Run Using Statistically Sig (P<.05) Throw from the bottom (tcr)
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 63.64, NOT BETTER lower is better

#Run Using Statistically Sig (P<.05) 
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 57.797, BEST

#Run Using Statistically Sig (P<.05) Throw out WGPA since it is not well-known in advance  AIC = 72.584 : Lose a lot by throwing out wgpa
myprobitabbv <- glm(ext ~ prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC = 72.584 : Lose a lot by throwing out wgpa

#Now put this in excel and run real-statistic probit to get type1/type2 grid.   
#WORKFILE3 / PROBIT 1 using RS"  using wgpa,prnk,hsgpa,tcr,mat
#WORKFILE3 / PROBIT 2 using RS"  using prnk,hsgpa,tcr,mat   since wgpa isn't known well in advance
