

# PROBIT PRACTICE

library(tidyverse)
library(dplyr)


library(tidyverse)
library(dplyr)
library(readxl)
library(ggplot2)
#library(ggpmisc) #for annotate with npc   #doesn't load without crashing
setwd("E:/000 DTS 400 Internship/Orig Lists/")
#download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE3",
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

#Run the Regression  THIS ONE IS PRE, and somewhat naive
myprobit <- glm(ext ~ hst + rac + alum + yr + nm + engsem + prnk + gndr + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + wgpa + seg, family = binomial(link = "probit"), 
                data = prbtwgrds)

## model summary
summary(myprobit)   #AIC 58.207, lower is better


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
summary(myprobitabbv)   #AIC 57.797, lower is better

#Run Using Statistically Sig (P<.05) AND Throw rnk as an overlap of prnk, Throw from the bottom (mat)
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 61.724, NOT BETTER lower is better

#Run Using Statistically Sig (P<.05) AND Throw rnk as an overlap of prnk, Throw from the bottom (tcr)
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 63.64, NOT BETTER lower is better

#Run Using Statistically Sig (P<.05) AND Throw rnk as an overlap of prnk
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 57.797, BEST

#Now put this in excel and run real-statistic probit to get type1/type2 grid.

#####
#Need to calculate marginal effect.
#from https://rdrr.io/cran/mfx/man/probitmfx.html

library(mfx)  #for marginal effects
#  probitmfx(formula=y~x, data=data)

#BEST Model from Previous steps with AIC of 57.797
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)
probitmfx(ext ~ wgpa + prnk + hsgpa + tcr + mat, data = prbtwgrds)  


#All In Model
myprobitabbv <- glm(ext ~ race1 + race2 + race3 + race4 + race5 + race6 + race7 + hst1 + hst2 + hst3 + hst4 + alum0 + alum1 + alum2 + alum3 + seg1 + seg2 + seg3 + seg4 + seg5 + seg6 + rnk + siz + engsem + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + wgpa + nm + gndr + yr, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)  #AIC 60, lower is better
probitmfx(ext ~ race1 + race2 + race3 + race4 + race5 + race6 + race7 + hst1 + hst2 + hst3 + hst4 + alum0 + alum1 + alum2 + alum3 + seg1 + seg2 + seg3 + seg4 + seg5 + seg6 + rnk + siz + engsem + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + wgpa + nm + gndr + yr, data = prbtwgrds)  
#Error , non-conformable arguments,  fitted probabilities numerically 0 or 1 occurred

#Classics Model
myprobitabbv <- glm(ext ~ wgpa + rnk + hsgpa + tcr + cmp + mat + sci + eng + rdg, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)    # AIC = 50.
probitmfx(ext ~ wgpa + rnk + hsgpa + tcr + cmp + mat + sci + eng + rdg, data = prbtwgrds)  

#What We Know Ahead of Time Model
myprobitabbv <- glm(ext ~ hsgpa + tcr + cmp + mat + sci + eng + rdg, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)  #   AIC = 96.526.

#Run Individual IVs to get Marginal Effect, and using atmean = FALSE
#myprobitabbv <- glm(ext ~ hsgpa + tcr + cmp + mat + sci + eng + rdg, family = binomial(link = "probit"), 
#                    data = prbtwgrds)
#summary(myprobitabbv)  #   AIC = 96.526.
probitmfx(ext ~ cmp, atmean = FALSE, data = prbtwgrds)   


#Trial and Error without cmp
myprobitabbv <- glm(ext ~ hsgpa + tcr + cmp + mat + sci + eng + rdg, family = binomial(link = "probit"), 
                    data = prbtwgrds)  #AID 96.5
summary(myprobitabbv)
probitmfx(ext ~ hsgpa + tcr + cmp + mat + sci + eng + rdg, data = prbtwgrds)   

#Trial and Error without cmp
myprobitabbv <- glm(ext ~ hsgpa + tcr + mat + sci + eng + rdg, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)  # AIC 94.
probitmfx(ext ~ hsgpa + tcr + mat + sci + eng + rdg, data = prbtwgrds)   

#Trial and Error without mat + sci + eng + rdg
myprobitabbv <- glm(ext ~ hsgpa + tcr + cmp, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)  #AIC = 95.78
probitmfx(ext ~ hsgpa + tcr + cmp, data = prbtwgrds)   






#######

#Now throw out the 2 worst Pr>|z|  (hst2  dst)
myprobitabbv1 <- glm(ext ~ race5 + alum1 + tcr + hsgpa + cmp + mat + sci + rdg + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv1)   #AIC 78.59, lower is better


#Now throw out the 1 worst Pr>|z|  (sci)
myprobitabbv2 <- glm(ext ~ race5 + alum1 + tcr + hsgpa + cmp + mat + rdg + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv2)   #AIC 76.83 , lower is better


#Now throw out the 1 worst Pr>|z|  (rdg)
myprobitabbv3 <- glm(ext ~ race5 + alum1 + tcr + hsgpa + cmp + mat + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv3)   #AIC 75.14 , lower is better

#Now throw out the 1 worst Pr>|z|  (hsgpa)
myprobitabbv4 <- glm(ext ~ race5 + alum1 + tcr + cmp + mat + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv4)   #AIC 73.62 , lower is better

#Now throw out the 1 worst Pr>|z|  (race5)
myprobitabbv5 <- glm(ext ~ alum1 + tcr + cmp + mat + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv5)   #AIC 72.77 , lower is better   *****THIS IS MIN (Best)

#Now throw out the 1 worst Pr>|z|  (mat)
myprobitabbv6 <- glm(ext ~ alum1 + tcr + cmp + wgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv6)   #AIC 76.862, COMING BACK UP.

#Now pick the Best Known Inputs
myprobitabbv7 <- glm(ext ~ tcr + hsgpa + cmp, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv7)   #AIC 105, lower is better


#Now pick the Best Known Inputs
myprobitabbv8 <- glm(ext ~ tcr + hsgpa, family = binomial(link = "probit"), 
                     data = prbtwgrds)

## model summary
summary(myprobitabbv8)   #AIC 104, lower is better

#from https://www.econometrics-with-r.org/11-2-palr.html
#https://stats.stackexchange.com/questions/84076/negative-values-for-aic-in-general-mixed-model
#negative AIC's are not bad.  The smaller AIC is better.  Do not consider the absolute value.  -237 is better than -201.




#https://www.rdocumentation.org/packages/DescTools/versions/0.99.37/topics/PseudoR2

#install DescTools
library(DescTools)
PseudoR2(myprobitabbv, which = "all")
PseudoR2(myprobitabbv2, which = "all")
PseudoR2(myprobitabbv3, which = "all")


#REgression Throw-Out Run, WITHOUT WGPA, since it wouldn't generally be known in advance
myprobita <- glm(ext ~ hst + rac + alum + yr + nm + engsem + prnk + gndr + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + seg, family = binomial(link = "probit"), 
                 data = prbtwgrds)

## model summary
summary(myprobita)   #AIC 112.1, lower is better

#Now throw out the worst Pr>|z| (any with .99) (all hsts except hst2, all rac except rac5, keep alum1, throw nm, seg2, seg6)
myprobitabbvb <- glm(ext ~ hst2 + race5 + alum1 + yr + engsem + prnk + gndr + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + seg4 + seg5, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvb)   #AIC 111.73, lower is better

#Now throw out the worst Pr>|z|    hst2   hsgpa   dst
myprobitabbvc <- glm(ext ~ race5 + alum1 + yr + engsem + prnk + gndr + tcr + cmp + mat + sci + eng + rdg + seg4 + seg5, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvc)   #AIC 107.11, lower is better

#Now throw out the worst Pr>|z|    seg5
myprobitabbvd <- glm(ext ~ race5 + alum1 + yr + engsem + prnk + gndr + tcr + cmp + mat + sci + eng + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvd)   #AIC 105.12, lower is better

#Now throw out the worst Pr>|z|    sci
myprobitabbve <- glm(ext ~ race5 + alum1 + yr + engsem + prnk + gndr + tcr + cmp + mat + eng + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbve)   #AIC 103.39, lower is better

#Now throw out the worst Pr>|z|    eng
myprobitabbvf <- glm(ext ~ race5 + alum1 + yr + engsem + prnk + gndr + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvf)   #AIC 101.83, lower is better

#Now throw out the worst Pr>|z|    gndr
myprobitabbvg <- glm(ext ~ race5 + alum1 + yr + engsem + prnk + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvg)   #AIC 100.8, lower is better

#Now throw out the worst Pr>|z|    engsem
myprobitabbvh <- glm(ext ~ race5 + alum1 + yr + prnk + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvh)   #AIC 99.84, lower is better

#Now throw out the worst Pr>|z|    race5
myprobitabbvi <- glm(ext ~ alum1 + yr + prnk + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvi)   #AIC 99.86, NOT LOWER, HIT MINIMUM ON LAST ROUND

#Split Out PRNK to RNK and SIZ

#Now throw out the worst Pr>|z|    Split Out PRNK to RNK and SIZ
myprobitabbvj <- glm(ext ~ race5 + alum1 + yr + rnk + siz + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvj)   #AIC 97.098, lower is better


#Now throw out the worst Pr>|z|    siz
myprobitabbvk <- glm(ext ~ race5 + alum1 + yr + rnk + tcr + cmp + mat + rdg + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvk)   #AIC 95.587, lower is better

#Now throw out the worst Pr>|z|    rdg
myprobitabbvl <- glm(ext ~ race5 + alum1 + yr + rnk + tcr + cmp + mat + seg4, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvl)   #AIC 95.606, NOT LOWER, HIT MINIMUM ON LAST ROUND

#Now throw out non-actionable inputs    race5 alum1 yr seg4  
myprobitabbvm <- glm(ext ~ rnk + tcr + cmp + mat, family = binomial(link = "probit"), data = prbtwgrds)

## model summary
summary(myprobitabbvm)   #AIC 99.596, NOT LOWER, HIT MINIMUM ON LAST ROUND



#### Standardize the Variables prior to doing MFX, 
#BEST Model from Previous steps with AIC of 57.797
myprobitabbv <- glm(ext ~ wgpa + prnk + hsgpa + tcr + mat, family = binomial(link = "probit"), 
                    data = prbtwgrds)
summary(myprobitabbv)
probitmfx(ext ~ wgpa + prnk + hsgpa + tcr + mat, data = prbtwgrds)
str(prbtwgrds)




#BEST Model from Previous steps with AIC of 57.797
myprobitabbv <- glm(ext ~ wgpa + prnk + tcr + mat, family = binomial(link = "probit"), 
                    data = Gradswfb.std)
summary(myprobitabbv)
probitmfx(ext ~ wgpa + prnk + tcr + mat, data = prbtwgrds)
str(prbtwgrds)



##scratch after tthis_is_a_really_long_name

#DOWNLOAD WORKSHEET GandE w gpas -- it has grads and dng's who have gpas, but without filled blanks.  


# CONTINUOUS graph a series of scatterplots of continuous variables vs wgpa, with color = ext

library(readxl)

#download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE1",
#             "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("WORKFILE1.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEgpas <- read_excel("WORKFILE1.xlsx", sheet = "GandE without blanks filled")

#comebck and finish this









p <- ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                       y = Sepal.Length, 
                                       color = Species,
                                       shape = Species)) +
  geom_point() +
  scale_shape_manual(values =  c(1, 5, 7)) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("purple", "orange", "blue")) +
  labs(x = "Sepal Length (cm)",
       y = "Sepal Width (cm)",
       title = "This is where I would put a title",
       color = "Species of Iris",
       shape = "Species of Iris") + 
  theme(plot.title = element_text(hjust = .5)) +
  theme_bw() +
  facet_wrap(vars(Species)) 

p

#First, do you have the right packages loaded to computed averages? Then calculate the averages:
library(dplyr)

# pipe on page 5.13,  group_by and summarise on pg 5.11
averages <- iris %>%    #pg 5.13
  group_by(Species) %>% 
  summarise(avglength = mean(Sepal.Length))
averages

#3 horizontal lines with color to correspond to their respective obs colors?
p + geom_hline(data = averages, mapping = aes( yintercept = avglength, color = Species))   #pg3.8


