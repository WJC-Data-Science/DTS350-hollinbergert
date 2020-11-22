#http://r-statistics.co/Probit-Regression-With-R.html

#'E:/000 DTS 350 Data Visualization/DTS350-hollinbergert/DTS350TemplateMaster/Week_07/Class_Task_12/messy_data.xlsx


library(tidyverse)
library(dplyr)
library(readxl)
library(devtools)
library(downloader)


probit <- read_csv("E:/000 DTS 400 Internship/PROBIT.csv")

probit
summary(probit)


probitMod <- glm(grad ~ dst + cmp + mat + sci + eng + rdg + hsgpa + rnk	+ siz	+ engsem	+ tcr + FM, data = probit, family = binomial(link = "probit"))  # build the logit model
#predicted <- predict(probitMod, testData, type="response")  # predict the probability scores
summary(probitMod)  # model summary
summary.lm(probitMod)
