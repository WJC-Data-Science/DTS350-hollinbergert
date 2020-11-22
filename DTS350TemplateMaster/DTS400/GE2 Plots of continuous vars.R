
# CONTINUOUS graph a series of scatterplots of continuous variables vs wgpa, with color = ext
library(tidyverse)
library(dplyr)
library(readxl)

#download.file("E:/000 DTS 400 Internship/Orig Lists/WORKFILE1",
#             "workfiletmp.xlsx", mode = "wb")
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("WORKFILE2.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwofb <- read_excel("WORKFILE2.xlsx", sheet = "GandE without filled blanks")
GEwofb

#Take out the "No GPA on record, so now it's: Grads and Exits with gpas, and without filled blanks
GEwgpawofb <- filter(GEwofb, status != "No GPA on record")
GEwgpawofb
unique(GEwgpawofb$status)  #confirms that only two options exist: "Didn't Graduate, but had GPA" "Grad with GPA"   


GEwgpawofb$seg <- as.factor(GEwgpawofb$seg)
GEwgpawofb$status <- as.factor(GEwgpawofb$status)



#Create Means for each continuous variable


GEwgpawofbstatgrp <- group_by(GEwgpawofb, status)
GEwgpawofbstatgrp <- (summarize(GEwgpawofbstatgrp, 
                                wgpabar = mean(wgpa, na.rm = TRUE), 
                                rnkbar = mean(rnk, na.rm = TRUE), 
                                sizbar = mean(siz, na.rm = TRUE),
                                prnkbar = mean(prnk, na.rm = TRUE),
                                engsembar = mean(engsem, na.rm = TRUE),
                                tcrbar = mean(tcr, na.rm = TRUE),
                                hsgpabar = mean(hsgpa, na.rm = TRUE),
                                cmpbar = mean(cmp, na.rm = TRUE),
                                matbar = mean(mat, na.rm = TRUE),
                                scibar = mean(sci, na.rm = TRUE),
                                engbar = mean(eng, na.rm = TRUE),
                                rdgbar = mean(rdg, na.rm = TRUE),
                                dstbar = mean(dst, na.rm = TRUE)))
# this gets a warning:  "`summarise()` regrouping output by 'year' (override with `.groups` argument)
GEwgpawofbstatgrp
#View(graph2data)


#scatter plots with CI and stats
library(ggpubr)
listofcolors <- c("red","springgreen4") 

#WGPAxRNK
w <- ggplot(GEwgpawofb, aes(rnk, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rnkbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of High School Class RANK on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School Class RANK",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxrnk.jpeg",  width = 9, height = 7, units = "in")

#WGPAxSIZ
w <- ggplot(GEwgpawofb, aes(siz, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = sizbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of High School Class SIZE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School Class SIZE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxsiz.jpeg",  width = 9, height = 7, units = "in")

#WGPAxPRNK
w <- ggplot(GEwgpawofb, aes(prnk, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = prnkbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of High School Class RANK / SIZE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School Class RANK / SIZE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxprnk.jpeg",  width = 9, height = 7, units = "in")

#wgpaxengsem   
w <- ggplot(GEwgpawofb, aes(engsem, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engsembar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of HS English Semesters on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School English Semesters",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxengsem.jpeg",  width = 9, height = 7, units = "in")

#wgpaxtcr 
w <- ggplot(GEwgpawofb, aes(tcr, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = tcrbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of TRANSFER CREDITS on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "Transfer Credits",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxtcr.jpeg",  width = 9, height = 7, units = "in")

#wgpaxhsgpa
w <- ggplot(GEwgpawofb, aes(hsgpa, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = hsgpabar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of High School GPA on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School GPA",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxhsgpa.jpeg",  width = 9, height = 7, units = "in")

#wgpaxcmp
w <- ggplot(GEwgpawofb, aes(cmp, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = cmpbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
# stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of COMPOSITE ACT SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "COMPOSITE ACT SCORE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxcmp.jpeg",  width = 9, height = 7, units = "in")

#wgpaxmat
w <- ggplot(GEwgpawofb, aes(mat, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = matbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT MATH SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT MATH SCORE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxact.jpeg",  width = 9, height = 7, units = "in")

#wgpaxsci
w <- ggplot(GEwgpawofb, aes(sci, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = scibar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The ACT SCIENCE SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT SCIENCE SCORE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxsci.jpeg",  width = 9, height = 7, units = "in")

#wgpaxeng
w <- ggplot(GEwgpawofb, aes(eng, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT ENGLISH SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT ENGLISH SCORE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxeng.jpeg",  width = 9, height = 7, units = "in")

#wgpaxrdg
w <- ggplot(GEwgpawofb, aes(rdg, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rdgbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT READING SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT READING SCORE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxrdg.jpeg",  width = 9, height = 7, units = "in")

#wgpaxdst
w <- ggplot(GEwgpawofb, aes(dst, wgpa, color = status)) +
  geom_point() +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = dstbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  geom_smooth(method = lm) +
  # stat_cor(method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ZIP-DISTANCE FROM HOME on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ZIP-DISTANCE FROM HOME",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal")
w
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxdst.jpeg",  width = 9, height = 7, units = "in")

