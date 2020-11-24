#' ---
#' title: "GE "
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
#' sample filepath E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/GE.r

#' Start by loading libraries
library(tidyverse)
library(dplyr)
library(readxl)
library(devtools)
library(downloader)
library(nycflights13)
library(knitr)
library(gapminder)
library(directlabels)
library(ggcorrplot)
library(car)
library(RColorBrewer)
library(viridis)
library(hexbin)
library(modelr)
library(ggplot2)
library(ggpubr)
library(foreign)
library(blscrapeR)
library(Lahman)
library(hrbrthemes)
library(lubridate)
library(haven)
library(readr)
library(RVerbalExpressions)

#' Check working directory
setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/")
getwd()


#'Download the csv from the web ()
#'download.file("https://educationdata.urban.org/csv/ipeds/colleges_ipeds_completers.csv","colleges_ipeds_completers.csv", "GE.csv", mode = "wb")

#' Open csv in excel and filter each row to see what the column contents are (missing data = 99 for example, etc) .
#' Also look for opening lines to skip, comment flags, column names (header row), etc 

#'Now we use the read_csv function to load the data.
library(readr)
ge <- read_csv("GE.csv")   
ge    #looks good, all columns came over
str(ge)    #says 'ext' its a col_double()
ge$ext    #shows up as 0';'s an 1's, which is good
grads <- filter(ge, ext == 0)  
grads$ext

ge <- read_csv("GE.csv")
ge    #looks good, all columns came over
str(ge)    #says 'ext' its a col_double()
ge$ext    #shows up as 0';'s an 1's, which is good
exits <- filter(ge, ext == 1)  
exits$ext

#install(ggpmisc) # for annotate with npc
#install jtools
#install broom.mixed
#install ggstance
library(ggplot2)
library(ggstance)
library(jtools)
library(broom.mixed)


# from  https://cran.r-project.org/web/packages/jtools/vignettes/summ.html

fitboth <- lm(wgpa ~ tcr + hsgpa + cmp + mat + sci + eng + rdg,
                       data = ge)
plot_summs(fitboth, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9, legend.title = "BOTH") 


fitgrads <- lm(wgpa ~ tcr + hsgpa + cmp + mat + sci + eng + rdg,
          data = grads)
plot_summs(fitgrads, scale = TRUE, plot.distributions = TRUE, inner_ci_level = .9, legend.title = "GRADS")

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


#View(grads)

# from https://rpubs.com/ajdowny_student/300663

# install ggplot2
# install car
# install magrittr
library(ggplot2)
library(corrplot)
library(car)
library(magrittr)

fitgrads <- lm(wgpa ~ tcr + hsgpa + ms + er + gndr,
               data = grads)
summary.aov(fitgrads)
summ(fitgrads, scale = TRUE, center = TRUE, n.sd = 2, confint = TRUE, ci.width = .95)

# Assumption 1 - Linearity of Relationship
plot(fitgrads,1)  


# Assumption 2 - Independence of Variables
cor(grads[,c(43,27,28,47,48,38)])    #  Assumption 2 - Independence of Variables
corrplot(cor(grads[,c(43,27,28,47,48,38)]),method='circle') 

#Graph of Grade Point distributions with Vertical Mean ofr 5 segments
library(viridis)
grads
gr <- grads %>%
group_by(seg) %>%
  summarise(grp.med = median(wgpa)) 
gr
gr$seg <- as.character(gr$seg)
grads$seg <- as.character(grads$seg)
gr 
grads
ggplot(grads, aes(wgpa, color = seg)) +
  geom_density(lwd = 2) +
  geom_vline(aes(xintercept = grp.med, color = seg),
             data = gr, linetype = 2, lwd = 1) +
  labs( 
    title = "WJC GPA Distribution based on Major Groupings",
    subtitle = "The percentage decline of GDP relative to the same quarter in 2019. It is adjusted for inflation.",
    caption = "Source: WJC Admissions Records")


library(viridis)
gr <- grads %>%
  group_by(seg) %>%
  summarise(grp.med = median(wgpa)) 
gr
gr$seg <- as.character(gr$seg)
grads$seg <- as.character(grads$seg)
gr 
grads
ggplot(grads, aes(wgpa, color = seg)) +
  geom_density(lwd = 2) +
  geom_vline(aes(xintercept = grp.med, color = seg),
             data = gr, linetype = 2, lwd = 1) +
facet_wrap(~ seg, ncol = 1)  




#' Unused template for reassigning variable types, if need be
#'df$aaa <- as.double(df$aaa)
#'df$bbb <- as.integer(df$bbb)
#'df$ccc <- as.character(df$ccc)
#'df$ddd <- as.factor(df$ddd)
#'df$eee <- as.double(df$eee)
#'df$fff <- as.double(df$fff)

#' look again
#'df

#'Select Columns and Filter rows,  Create new columns, then save as the working csv 
#'library(tidyverse)
#'library(dplyr)
#'df2 <- df 
df2 <- select(df2,aaa,bbb)   #select desired columns
#'df2 <- filter(df2, bbb == 2012)   #filter only needed rows
#'df2 <- mutate(df2, new = 1/aaa, new2 = 1/bbb)  #create any new derivation columns
#'df2 <- 
#'  head(df2, n = 10)
#'write_csv(df2, "df2.csv")


# PROBIT PRACTICE

library(tidyverse)
library(dplyr)

setwd("E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/DTS400/")
getwd()

prbt <- read_csv("PROBIT DATA incl no grades.csv")
prbt    #looks good, all columns came over, BUT almost all are dbl except for chars: hs,sex,initprgm,src,race,nm1
str(prbt)    #BUT almost all are dbl except for chars: hs,sex,initprgm,src,race,nm1
prbt$ext    #shows up as 0';'s an 1's, which is good


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

#Run the PROBIT Regression, now including Categoricl & Binary Variables 
myprobit <- glm(ext ~ hst + rac + alum + yr + nm + engsem + prnk + gndr + tcr + hsgpa + cmp + mat + sci + eng + rdg + dst + wgpa + seg, family = binomial(link = "probit"), 
                data = prbtwgrds)

## model summary
summary(myprobit)   #AIC 88, lower is better

#Now pick the 11 best Pr>|z| values
myprobitabbv <- glm(ext ~ hst2 + race5 + alum1 + tcr + hsgpa + cmp + mat + sci + rdg + dst + wgpa, family = binomial(link = "probit"), 
                    data = prbtwgrds)

## model summary
summary(myprobitabbv)   #AIC 81, lower is better


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


#P{ROBIT REgression Chase-Down, Throw-Out Run, WITHOUT WGPA, since it wouldn't generally be known in advance
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




