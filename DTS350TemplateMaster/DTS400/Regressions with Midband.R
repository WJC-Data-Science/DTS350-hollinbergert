
library(tidyverse)
library(dplyr)
library(readxl)
library(car)
library(corrplot)
library(ggplot2)
#library(ggpmisc)

# not needed since it's on the e drive   download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE2",  "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("E:/000 DTS 400 Internship/Orig Lists/WORKFILE3a.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
midband <- read_excel("E:/000 DTS 400 Internship/Orig Lists/WORKFILE3a.xlsx", sheet = "GandE with filled blanks", skip = 0)
(midband)

setwd("E:/000 DTS 400 Internship/GE3 Linear Regression Midband/")
getwd()

#MAKE THE MIDBAND OF WJC GPAs between 2.3 and 3.3
midband <- filter(midband, wgpa > 2.3 & wgpa < 3.3)    #Results in 45 observations
View(midband)


#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
midbandgrads <- filter(midband, status != "Didn't Graduate, but had GPA")
View(midbandgrads)   #29 students
unique(midbandgrads$status)  #confirms that only one option exist: "Grad with GPA"   
unique(midbandgrads$wgpa)


#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
midbandexits <- filter(midband, status == "Didn't Graduate, but had GPA")
View(midbandexits)  #16 students
unique(midbandexits$status)  #confirms that only one option exist: "Grad with GPA"   
unique(midbandexits$wgpa)

###  Jump Down to 268 to continue midband


GEwfb <- as.data.frame(GEwfb)

GEwfbcorvars <- select(GEwfb, wgpa, rnkneg, siz, prnk)  #, engsem,	tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, hst, alum, rac, seg, nm, gndr, yr, ext, stat)
str(GEwfbcorvars)
corrplot.mixed(cor(GEwfbcorvars), upper = "ellipse")   #problems with blanks in wgpa, shows ? in wgpa col and row

#Take out the "No GPA on record, so now it's: Grads and Exits with gpas, and with filled blanks
GEwgpawfb <- filter(GEwfb, status != "No GPA on record")
View(GEwgpawfb)
unique(GEwgpawfb$status)  #confirms that only two options exist: "Didn't Graduate, but had GPA" "Grad with GPA"   
unique(GEwgpawfb$wgpa)  

GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, siz, prnk,	engsem,	tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, hst, alum, rac, seg, nm, gndr, yr, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")   #problems with blanks in wgpa

#Now use levels of categorical variables for segment
GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, seg1, seg2, seg3, seg4, seg5, seg6)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")   #problems with blanks in wgpa

#Now add in levels for categorical and binary variables
GEwgpawfbcorvars <- select(GEwgpawfb, wgpa, rnkneg, tcr, hsgpa,	cmp,	mat,	sci,	eng,	rdg,	dst, seg1, seg2, seg3, seg4, seg5, seg6, race1, race2, race3, race4, race5, race6, race7, alum0, alum1, alum2, alum3, hst1, hst2, hst3, hst4, nm, gndr, yr, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbcorvars), upper = "ellipse")   #problems with blanks in wgpa
ggsave("corrplotalllevels.jpeg",  width = 9, height = 7, units = "in")

GEwgpawfbtopcorrels <- select(GEwgpawfb, wgpa, hsgpa,	rnkneg, mat,	eng,	cmp,	rdg, sci,	tcr, gndr, seg1, race7, seg6, hst1, hst4, nm, ext, stat)
#str(GEwgpawfbcorvars)
corrplot.mixed(cor(GEwgpawfbtopcorrels), upper = "ellipse")   #problems with blanks in wgpa
ggsave("corrplotalllevels.jpeg",  width = 9, height = 7, units = "in")





par()  
#Take out the "Didn't Graduate, but had GPA", so now it's: Grads only, and with filled blanks
Gradswfb <- filter(GEwgpawfb, status != "Didn't Graduate, but had GPA")
#View(Gradswfb)
unique(Gradswfb$status)  #confirms that only two options exist: "Didn't Graduate, but had GPA" "Grad with GPA"   
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
ggsave("E:/000 DTS 400 Internship/GE3 Linear Regression/scatterplotMAtrix1.jpeg",  width = 9, height = 7, units = "in")
# Are not normal-looking and need to be transformed.  See the YBpg102










#BOX-COX Transformation YBpg102
#also other options: https://www.statisticssolutions.com/transforming-data-for-normality/
library(car)
lambdawgpa <- coef(powerTransform(1/GEwgpawfb_contin_num$wgpa))
lambdawgpa   #1 means close to normal
bcPower(GEwgpawfb_contin_num$wgpa, lambdawgpa)

par(mfrow = c(1,2))    #watch out this effects all plotting thereafter, need to toggle off eventually
hist(GEwgpawfb_contin_num$wgpa,
     xlab = "wgpa", ylab = "Count of Students",
     main = "Original Distribution")

hist(bcPower(GEwgpawfb_contin_num$wgpa, lambdawgpa),
     xlab = "Box-Cox Transform of wgpa", ylab = "Count of Students",
     main = "Transformed Distribution")

GEwfb
shapiro.test(GEwgpawfb_contin_num$wgpa)
#data:  GEwfb$wgpa
#W = 0.89606, p-value = 1.259e-09  NOT GOOD, wanted p>.05 (counterintuitive)

wgpaboxcox <- (bcPower(GEwgpawfb_contin_num$wgpa, lambdawgpa))
wgpaboxcox 
shapiro.test(wgpaboxcox)
#data:  wgpaboxcox
#W = 0.29815, p-value < 2.2e-16  WORSE!?!? after boxcox

#MANUAL TRANSFORMATION
#Other manual attempts at normality of wgpa
#wgpa , hsgpa + rnk + cmp + mat + sci + eng + rdg + tcr


#Assume average & maxdensity at 3.44 for G&E, and 3.53 for grads only

#Transform = wgpa, using grad-only mean of 3.503
GEwgpawfb
wgpaxfrm1 <-   (abs(3.503 - GEwgpawfb$wgpa))^.35  #using gradonly mean of 3.53, must be near mean, but not = to any actual gpa
wgpaxfrm1
shapiro.test(wgpaxfrm1)
#data:  wgpaxfrm1   Want a p-value > .05 (counterintuitive)
#W = 0.9845, p-value = 0.05311    exponent = .45  using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.98986, p-value = 0.2592    exponent = .40  using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.9892, p-value = 0.2148    exponent = .30  using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.99124, p-value = 0.3777    exponent = .375  using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.99161, p-value = 0.4154    exponent = .36   using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.99152, p-value = 0.4062    exponent = .34  using (abs(3.5305 - GEwgpawfb$wgpa))
#W = 0.99165, p-value = 0.4198    exponent = .35   BEST for (abs(3.5305 - GEwgpawfb$wgpa))

#Transform = wgpa, using grad and exit mean of 3.44
GEwgpawfb
wgpaxfrm1 <-   (abs(3.44 - GEwgpawfb$wgpa))^.37  #using gradonly mean of 3.53, must be near mean, but not = to any actual gpa
wgpaxfrm1
shapiro.test(wgpaxfrm1)
#data:  wgpaxfrm1   Want a p-value > .05 (counterintuitive)
#W = 0.99042, p-value = 0.3028    exponent = .35  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.98558, p-value = 0.07352    exponent = .30  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99102, p-value = 0.356    exponent = .40  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.98853, p-value = 0.1767    exponent = .45  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99074, p-value = 0.3306    exponent = .41   using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99117, p-value = 0.3708    exponent = .39  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.9912, p-value = 0.3733    exponent = .38   BEST for (abs(3.44 - GEwgpawfb$wgpa))


#Now do histogram to visually see normality
par(mfrow = c(1,2))    #watch out this effects all plotting thereafter, need to toggle off eventually
hist(GEwgpawfb$wgpa,
     xlab = "wgpa", ylab = "Count of Students",
     main = "Original Distribution")

hist((abs(3.44 - GEwgpawfb$wgpa))^.37,
     xlab = "Manual Transform of wgpa", ylab = "Count of Students",
     main = "Transformed Distribution")
# LOOKING GOOD!!


#Transform = hsgpa, using hsgpa mean of 3.814
#Original GEwgpawfb$hsgpa
shapiro.test(GEwgpawfb$hsgpa)
#W = 0.93335, p-value = 3.795e-07


GEwgpawfb
hsgpaxfrm1 <-   (abs(3.814 - GEwgpawfb$hsgpa))^.29  #using gradonly mean of 3.814, must be near mean, but not = to any actual gpa
hsgpaxfrm1
shapiro.test(hsgpaxfrm1)
#data:  wgpaxfrm1   Want a p-value > .05 (counterintuitive)
#W = 0.98795, p-value = 0.1492    exponent = .37  using (abs(3.814 - GEwgpawfb$wgpa))
#W = 0.98497, p-value = 0.06122    exponent = .40  using (abs(3.814 - GEwgpawfb$wgpa))
#W = 0.99139, p-value = 0.3924    exponent = .30  using (abs(3.814 - GEwgpawfb$wgpa))
#W = 0.99052, p-value = 0.3107    exponent = .25  using (abs(3.814 - GEwgpawfb$wgpa))
#W = 0.99139, p-value = 0.3926    exponent = .28  using (abs(3.814 - GEwgpawfb$wgpa))
#W = 0.99145, p-value = 0.3983    exponent = .29  BEST using (abs(3.814 - GEwgpawfb$wgpa))


#Now do histogram to visually see normality
par(mfrow = c(1,2))    #watch out this effects all plotting thereafter, need to toggle off eventually
hist(GEwgpawfb$hsgpa,
     xlab = "wgpa", ylab = "Count of Students",
     main = "Original Distribution")

hist((abs(3.814 - GEwgpawfb$hsgpa))^.29,
     xlab = "Manual Transform of wgpa", ylab = "Count of Students",
     main = "Transformed Distribution")
# LOOKING GOOD!!


#Transform = rnk
#Original GEwgpawfb$rnk
shapiro.test(GEwgpawfb$rnk)
#W = 0.82698, p-value = 5.249e-13


GEwgpawfb
rnkxfrm1 <-   (abs(3.44 - GEwgpawfb$rnk))^.37  #using gradonly mean of 3.53, must be near mean, but not = to any actual gpa
rnkxfrm1
shapiro.test(rnkxfrm1)
#data:  wgpaxfrm1   Want a p-value > .05 (counterintuitive)
#W = 0.99042, p-value = 0.3028    exponent = .35  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.98558, p-value = 0.07352    exponent = .30  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99102, p-value = 0.356    exponent = .40  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.98853, p-value = 0.1767    exponent = .45  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99074, p-value = 0.3306    exponent = .41   using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.99117, p-value = 0.3708    exponent = .39  using (abs(3.44 - GEwgpawfb$wgpa))
#W = 0.9912, p-value = 0.3733    exponent = .38   BEST for (abs(3.44 - GEwgpawfb$wgpa))


#Now do histogram to visually see normality
par(mfrow = c(1,2))    #watch out this effects all plotting thereafter, need to toggle off eventually
hist(GEwgpawfb$wgpa,
     xlab = "wgpa", ylab = "Count of Students",
     main = "Original Distribution")

hist((abs(3.44 - GEwgpawfb$wgpa))^.37,
     xlab = "Manual Transform of wgpa", ylab = "Count of Students",
     main = "Transformed Distribution")
# LOOKING GOOD!!


#Try a shapiro wilks check of the residuals
res <- residuals(lm(wgpa~hsgpa, data = GEwgpawfb_contin_num))
res
shapiro.test(res)
#data:  res
#W = 0.93454, p-value = 4.68e-07    # NOT GOOD  want P>.05 (counterintuitive)
#LITTLE IMPROVEMENT   SCRAP THIS LINE OF APPROACH



# MOVE ONTO LINEAR REGRESSION



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
View(midbandoutliers)


# THROW EVERYTHING IN  Continuous, BDV's and Categorical(except the Categorical Omitted Throwout Variables Race1, HST1, Seg1, and Alum0)
#using Grads and Exits w gpa 
fullge <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
             midband)
summary(fullge)    #disregard the error about doTryCatch...
#Results:  AdjRsqd = .0.4322      Midband: AdjR .259  pval = .1676    race7, alum1, rnk, mat

par(mfrow = c(2,2))
plot(fullge)   #YBpg168     not a good look
ggsave("diagnosticmidbandplotfullge.jpeg",  width = 9, height = 7, units = "in")



#using Grads only
fullg <- lm(wgpa ~ race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            midbandgrads)
summary(fullg) 
#OriginalResults: AdjRsqd = .0.469  p-value: 7.362e-12     Midbandgrads = AdjRqd .4497 ,  pval = .329    NO variables have sig pvals
par(mfrow = c(2,2))
plot(fullg)   #YBpg168
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")
#Results:  AdjRsqd = 0.469  

#using Exits only
fullg <- lm(wgpa ~ race7 + alum1 + rnkneg + tcr + hsgpa + cmp + mat,
            midbandexits)
summary(fullg) 
#Orig Results:  AdjRsqd = .0.469  p-value: 7.362e-12   Midbandexits = AdjRqd ..1533 ,  pval = .294    NO variables have sig pvals
par(mfrow = c(2,2))
plot(fullg)   #YBpg168
ggsave("diagnosticplotfullg.jpeg",  width = 9, height = 7, units = "in")
   

#Now use Status as DV

fullge <- lm(stat ~ wgpa + race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + seg6 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
             midband)
summary(fullge)    #disregard the error about doTryCatch...
#Stat Results:  Midband: AdjRsqd = .702 pval .001      wgpa, race6(NRA), alum3, tcr, dst, yr

par(mfrow = c(2,2))
plot(fullge)   #YBpg168     not a good look
ggsave("diagnosticmidbandplotfullge.jpeg",  width = 9, height = 7, units = "in")



#using Grads only or Exits only WON'T WORK BECAUSE THEY ARE ALREADY GRADUATES  yo get teh "perfec fit" error
fullg <- lm(stat ~ wgpa + race2 + race3 + race4 + race5 + race6 + race7 + hst2 + hst3 + hst4 + alum1 + alum2 + alum3 + seg2 + seg3 + seg4 + seg5 + engsem + rnkneg + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + nm + gndr + yr, 
            midbandgrads)
summary(fullg) 
#OriginalResults: AdjRsqd = .0.469  p-value: 7.362e-12     Midbandgrads = AdjRqd .4497 ,  pval = .329    NO variables have sig pvals
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
summary(myprobitabbv)
probitmfx(ext ~ tcr + yr + prnk, data = midband)
