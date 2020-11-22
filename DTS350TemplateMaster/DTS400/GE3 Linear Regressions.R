# Linear Regression

library(tidyverse)
library(dplyr)
library(readxl)
library(car)
library(corrplot)
library(ggplot2)
#library(ggpmisc)

# not needed since it's on the e drive   download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE2",  "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("E:/000 DTS 400 Internship/Orig Lists/WORKFILE3.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwfb <- read_excel("E:/000 DTS 400 Internship/Orig Lists/WORKFILE3.xlsx", sheet = "GandE with filled blanks", skip = 0)
(GEwfb)

setwd("E:/000 DTS 400 Internship/GE3 Linear Regression/")
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
#plotted in the reverse order they were typed into model line
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


##########
#Try a shapiro wilks check of the residuals
res <- residuals(lm((wgpa^.75) ~ rnkneg + gndr + hst3 + mat + dst + hsgpa + rdg,
                    data = GEwgpawfb.std))
res
shapiro.test(res)
#data:  res
#W = 0.92416, p-value = 7.999e-08    # NOT GOOD  want P>.05 (counterintuitive)
#LITTLE IMPROVEMENT   SCRAP THIS LINE OF APPROACH


#Try a shapiro wilks using shorthand name of the linear model from above
res
shapiro.test(res)

res <- residuals(Std.ClassicIVs)
res
shapiro.test(res)
#data:  res
#W = 0.93565, p-value = 5.712e-07    # NOT GOOD  want P>.05 (counterintuitive)

res <- residuals(ClassicIVs)
res
shapiro.test(res)
#data:  res
#W = 0.93565, p-value = 5.712e-07    # NOT GOOD  want P>.05 (counterintuitive)

res <- residuals(fullg)
res
shapiro.test(res)
#data:  res
#W = 0.96957, p-value = 0.001988    # NOT GOOD  want P>.05 (counterintuitive)

res <- residuals(fullge)
res
shapiro.test(res)
#data:  res
#W = 0.9341, p-value = 4.333e-07    # NOT GOOD  want P>.05 (counterintuitive)

res <- residuals(fullgstd)
res
shapiro.test(res)
#data:  res
#W = 0.96957, p-value = 0.001988    # NOT GOOD  want P>.05 (counterintuitive)

res <- residuals(fullgestd)
res
shapiro.test(res)
#data:  res
#W = 0.9341, p-value = 4.333e-07    # NOT GOOD  want P>.05 (counterintuitive)


#TRANFORMATIONS to IMPROVE THE SHAPIRO WILKS NORMALITY OF THE residuals
# Only Statistically Significant IVs  Pr <.05  using standardized continuous variables
res <- residuals(lm((wgpa^1.15) ~ rnkneg + gndr + hst3 + mat + dst + hsgpa + rdg,   
                    data = GEwgpawfb.std))
res
shapiro.test(res)
#data:  res
#W = 0.98103, p-value = 0.1303    #  BEST  want P>.05 (counterintuitive)

#Our Classic Suite of IVs
res <- residuals(lm((wgpa^7.06) ~ hsgpa + rnkneg + cmp + mat + sci + eng + rdg + tcr,
                 data = GEwgpawfb))
res
shapiro.test(res)
#data:  res
#W = 0.9955, p-value = 0.8868    #  BEST  want P>.05 (counterintuitive)


#Our Classic Suite of IVs
res <- residuals(lm((wgpa^7.06) ~ (hsgpa) + 1/sqrt(rnkneg) + cmp + mat + sci + eng + rdg + 1/sqrt(tcr),
                    data = GEwgpawfb))
res
shapiro.test(res)
#data:  res
#W = 0.99537, p-value = 0.8735   #  VERY GOOD  want P>.05 (counterintuitive)


shapiro.test(GEwgpawfb$wgpa^5.1)
#W = 0.97554, p-value = 0.003945   as good as it gets


#Shapiro Wilks to test normality of variables
shapiro.test(wgpa)




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


# Binary (YBpg176) and Categorical (YBpg177)

