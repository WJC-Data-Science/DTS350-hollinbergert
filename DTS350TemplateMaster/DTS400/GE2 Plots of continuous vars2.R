
# CONTINUOUS VARIABLES graph a series of scatterplots of continuous variables vs wgpa, with color = ext
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


GEwgpawofbstatgrprnd <- mutate(GEwgpawofbstatgrp, 
                               wgpa = round(wgpabar, digits = 2), 
                               rnk = round(rnkbar,digits = 1), 
                               siz = round(sizbar,digits = 1), 
                               prnk = round(prnkbar,digits = 2),
                               engsem = round(engsembar,digits = 1),
                               tcr = round(tcrbar,digits = 1),
                               hsgpa = round(hsgpabar,digits = 2),
                               cmp = round(cmpbar,digits = 1),
                               mat = round(matbar,digits = 1),
                               sci = round(scibar,digits = 1),
                               eng = round(engbar,digits = 1),
                               rdg = round(rdgbar,digits = 1),
                               dst = round(dstbar,digits = 0))

GEwgpawofbstatgrprnd  # has 2 rows, one for grads, one for exits

#Split in to two df's. One for Grads one for Exits
Gradwgpawofbstatgrprnd <-filter(GEwgpawofbstatgrprnd, status == "Grad with GPA")
Gradwgpawofbstatgrprnd
Exitwgpawofbstatgrprnd <-filter(GEwgpawofbstatgrprnd, status == "Didn't Graduate, but had GPA")
Exitwgpawofbstatgrprnd


#scatter plots with CI and stats
library(ggpubr)
listofcolors <- c("red","springgreen4") 

#This function results in Count = 123
stat_box_data <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste('count=', length(y), '\n',
                    'mean =', round(mean(y), 1), '\n')
    )
  )
}

#This function results in mirror image:  123 = Count
stat_box_data2 <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste(length(y), '= count', '\n',
                    round(mean(y),1), '= mean', '\n')
    )
  )
}

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#as oppsoed to the Categorical and Binary situations, this DOES NOT need to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows

library(directlabels)  #to allow for adding labels that call out the average points
GEwgpawofbstatgrp

Gradwgpawofbstatgrprnd$rnkbar

#WGPAxRNK
w <- ggplot(GEwgpawofb, aes(rnk, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rnkbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  annotate("text", x = 200, y = 2.15, hjust = 0, vjust = 0, color = "black", label = (str_c("Average : (  ", "Rank  ,  WJC GPA)"))) +
  annotate("text", x = 200, y = 2, hjust = 0, vjust = 0, color = "springgreen4", label = (str_c("Average : (  ", round(Gradwgpawofbstatgrprnd$rnkbar,digits = 1), "   ,   " , round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  annotate("text", x = 200, y = 1.84, hjust = 0, vjust = 0, color = "red",            label = (str_c("Average : (", round(Exitwgpawofbstatgrprnd$rnkbar,digits = 1), "   ,   " , round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
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
ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxrnk.jpeg",  width = 9, height = 7, units = "in")

#WGPAxSIZ
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$siz)), digits = 5)[2]  #[2] means the 2nd coeff, i.e., gradient of the abline.  1st coeff is the y-intercept   https://stackoverflow.com/questions/19661766/how-to-get-gradient-of-abline-in-r
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$siz)), digits = 5)[2]
exitslope



w <- ggplot(GEwgpawofb, aes(siz, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = sizbar, y = wgpabar, size = 12, color = status), shape = 8) +  
#  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$sizbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
#                                color = status), data = GEwgpawofbstatgrprnd) +
  annotate("text", x = 10, y = 2.15, hjust = 0, vjust = 0, color = "black", label = (str_c("Correlation,  Significance"))) +
  annotate("text", x = 400, y = 2.15, hjust = 0, vjust = 0, color = "black", label = (str_c("Slope of Line,    Avg Size   ,  Avg WJC GPA)"))) +
  annotate("text", x = 400, y = 2, hjust = 0, vjust = 0, color = "springgreen4", label = (str_c(gradslope,  "  Average : (", round(Gradwgpawofbstatgrprnd$sizbar,digits = 1), "   ,   " , round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  annotate("text", x = 400, y = 1.84, hjust = 0, vjust = 0, color = "red",            label = (str_c(exitslope, "  Average : (", round(Exitwgpawofbstatgrprnd$sizbar,digits = 1), "   ,   " , round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
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

#WGPAxRNK
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$rnk)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$rnk)), digits = 5)[2]
exitslope
GEwgpawofbgrad$rnk
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$rnk,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$rnk,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$rnk,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$rnk,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(rnk, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rnkbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$rnkbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    rnke     |   WJC GPA   "))) +
  annotate("text", x = 150, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$rnk,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,   ",
                          gradslope,
                          "  ,     " ,
                          round(Gradwgpawofbstatgrprnd$rnkbar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 150, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$rnk,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,   ",
                          exitslope,
                          "  ,   " ,
                          round(Exitwgpawofbstatgrprnd$rnkbar
                                ,digits = 1),
                          "     ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
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

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg          Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           RANK    WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as PLOTS3 wgpaxrnk at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxsiz w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPA x SIZE
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$siz)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$siz)), digits = 5)[2]
exitslope
GEwgpawofbgrad$siz
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$siz,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$siz,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$siz,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$siz,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(siz, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = sizbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$sizbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
#  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
#           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
#  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
#           label = (str_c("    Coeff         |   if p < .05    |      Line      |    Size     |   WJC GPA   "))) +
  annotate("text", x = 300, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$siz,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "    ,   ",
                          gradslope,
                          "  ,   " ,
                          round(Gradwgpawofbstatgrprnd$sizbar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +

  annotate("text", x = 300, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$siz,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,   ",
                          exitslope,
                          "  ,   " ,
                          round(Exitwgpawofbstatgrprnd$sizbar
                                ,digits = 1),
                          "     ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
#   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
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

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           SIZE      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxsiz at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxsiz w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPAxENGSEM
#WGPA x SIZE
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$engsem)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$engsem)), digits = 5)[2]
exitslope
GEwgpawofbgrad$engsem
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$engsem,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$engsem,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$engsem,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$engsem,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(engsem, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engsembar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$engsembar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      | EngSem   |   WJC GPA   "))) +
  annotate("text", x = 6.2, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$engsem,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "    ,   ",
                          gradslope,
                          "  ,   " ,
                          round(Gradwgpawofbstatgrprnd$engsembar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 6.2, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$engsem,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,   ",
                          exitslope,
                          "  ,   " ,
                          round(Exitwgpawofbstatgrprnd$engsembar
                                ,digits = 1),
                          "     ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of NUMBER OF HS ENGLISH SEMESTERS on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "Number of HS English Semesters",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line         EngSem    WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxengsem at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxengsem w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")

#WGPA x TCR
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$tcr)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$tcr)), digits = 5)[2]
exitslope
GEwgpawofbgrad$tcr
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$tcr,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$tcr,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$tcr,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$tcr,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(tcr, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = tcrbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$tcrbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    TCRs     |   WJC GPA   "))) +
  annotate("text", x = 24, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$tcr,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "    ,   ",
                          gradslope,
                          "  ,   " ,
                          round(Gradwgpawofbstatgrprnd$tcrbar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 24, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$tcr,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,   ",
                          exitslope,
                          "  ,     " ,
                          round(Exitwgpawofbstatgrprnd$tcrbar
                                ,digits = 1),
                          "        ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
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

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           TCRs      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxtcr at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxtcr w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")

exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$hsgpa)), digits = 5)[2]
exitslope
#WGPA x hsgpa
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$hsgpa)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$hsgpa)), digits = 5)[2]
exitslope
GEwgpawofbgrad$hsgpa
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$hsgpa,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$hsgpa,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$hsgpa,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$hsgpa,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(hsgpa, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = hsgpabar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$hsgpabar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    HSGPA     |   WJC GPA   "))) +
  annotate("text", x = 3.1, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$hsgpa,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,  ",
                          gradslope,
                          "    ,     " ,
                          round(Gradwgpawofbstatgrprnd$hsgpabar,digits = 1),
                          "        ,   ",
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 3.1, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$hsgpa,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,  ",
                          exitslope,
                          "    ,     " ,
                          round(Exitwgpawofbstatgrprnd$hsgpabar
                                ,digits = 1),
                          "        ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of HIGH SCHOOL GPA on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School GPA",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg         Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line          HSGPA   WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxhsgpa at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxhsgpa w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")



#WGPA x cmp
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$cmp)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$cmp)), digits = 5)[2]
exitslope
GEwgpawofbgrad$cmp
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$cmp,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$cmp,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$cmp,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$cmp,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(cmp, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = cmpbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$cmpbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    ACTCMP     |   WJC GPA   "))) +
  annotate("text", x = 23, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$cmp,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,   ",
                          gradslope,
                          "  ,     " ,
                          round(Gradwgpawofbstatgrprnd$cmpbar,digits = 1),
                          "       ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 23, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$cmp,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "    ,   ",
                          exitslope,
                          "  ,     " ,
                          round(Exitwgpawofbstatgrprnd$cmpbar
                                ,digits = 1),
                          "       ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT COMPOSITE SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT Composite Score",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line          CMP     WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxcmp at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxcmp w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPA x mat
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$mat)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$mat)), digits = 5)[2]
exitslope
GEwgpawofbgrad$mat
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$mat,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$mat,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$mat,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$mat,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(mat, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = matbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$matbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    MAT     |   WJC GPA   "))) +
  annotate("text", x = 24, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$mat,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,   ",
                          gradslope,
                          "  ,     " ,
                          round(Gradwgpawofbstatgrprnd$matbar,digits = 1),
                          "       ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 24, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$mat,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "        ,   ",
                          exitslope,
                          ",     " ,
                          round(Exitwgpawofbstatgrprnd$matbar
                                ,digits = 1),
                          "       ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT MATH SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT Math Score",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line          MAT     WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxmat at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxmat w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPA x sci
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$sci)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$sci)), digits = 5)[2]
exitslope
GEwgpawofbgrad$sci
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$sci,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$sci,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$sci,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$sci,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(sci, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = scibar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$scibar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    SCI     |   WJC GPA   "))) +
  annotate("text", x = 24.5, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$sci,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,   ",
                          gradslope,
                          "      ,     " ,
                          round(Gradwgpawofbstatgrprnd$scibar,digits = 1),
                          "      ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 24.5, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$sci,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "      ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "        ,   ",
                          exitslope,
                          "    ,     " ,
                          round(Exitwgpawofbstatgrprnd$scibar
                                ,digits = 1),
                          "      ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT SCIENCE SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT Science Score",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           SCI      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxsci at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxsci w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPA x eng
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$eng)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$eng)), digits = 5)[2]
exitslope
GEwgpawofbgrad$eng
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$eng,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$eng,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$eng,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$eng,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(eng, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$engbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    eng     |   WJC GPA   "))) +
  annotate("text", x = 22, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$eng,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "           ,   ",
                          gradslope,
                          "      ,     " ,
                          round(Gradwgpawofbstatgrprnd$engbar,digits = 1),
                          "         ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 22, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$eng,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "        ,   ",
                          exitslope,
                          "    ,     " ,
                          round(Exitwgpawofbstatgrprnd$engbar
                                ,digits = 1),
                          "      ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT ENGLISH SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT ENGLISH Score",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           ENG      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxeng at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxeng w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")


#WGPA x rdg
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$rdg)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$rdg)), digits = 5)[2]
exitslope
GEwgpawofbgrad$rdg
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$rdg,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$rdg,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$rdg,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$rdg,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(rdg, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rdgbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$rdgbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    rdg     |   WJC GPA   "))) +
  annotate("text", x = 22, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$rdg,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "          ,   ",
                          gradslope,
                          "  ,     " ,
                          round(Gradwgpawofbstatgrprnd$rdgbar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 22, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$rdg,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "     ,   ",
                          exitslope,
                          "    ,     " ,
                          round(Exitwgpawofbstatgrprnd$rdgbar
                                ,digits = 1),
                          "     ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ACT READING SCORE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ACT Reading Score",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           RDG      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxrdg at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxrdg w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")

#WGPA x dst
#Prep the Annotated Values
gradslope <- round(coef(lm(GEwgpawofbgrad$wgpa~GEwgpawofbgrad$dst)), digits = 5)[2]  #[2] means the 2nd coeff.  1st coeff is the y-intercept
gradslope
exitslope <- round(coef(lm(GEwgpawofbexit$wgpa~GEwgpawofbexit$dst)), digits = 5)[2]
exitslope
GEwgpawofbgrad$dst
GEwgpawofbgrad$wgpa  
cor(GEwgpawofbgrad$dst,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs")  #http://www.r-tutor.com/elementary-statistics/numerical-measures/correlation-coefficient
round(cor(GEwgpawofbgrad$dst,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2)
corrsltsgrad <- cor.test(GEwgpawofbgrad$dst,GEwgpawofbgrad$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsgrad$p.value, digits = 3)
corrsltsexit <- cor.test(GEwgpawofbexit$dst,GEwgpawofbexit$wgpa)  #http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r
round(corrsltsexit$p.value, digits = 3)


# library(ggpmisc)  #for annotate with npc     #doesn't load without crashing
library(ggplot2)  # because ggpmisc messes with ggplot, which couldn't be found
#from https://www.rdocumentation.org/packages/ggpmisc/versions/0.3.6/topics/annotate


#Run the Plot
w <- ggplot(GEwgpawofb, aes(dst, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = dstbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  #  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$dstbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
  #                                color = status), data = GEwgpawofbstatgrprnd) +
  
  #  annotate("text", x = 300, y = 2.10, hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("Correlation    |  Significant  |   Slope of   |    Avg      |     Avg     "))) +
  #  annotate("text", x = 300, y = 2., hjust = 0, vjust = 0, color = "black", 
  #           label = (str_c("    Coeff         |   if p < .05    |      Line      |    dst     |   WJC GPA   "))) +
  annotate("text", x = 27000, y = .35, hjust = 0, vjust = 0, cex = 4, color = "springgreen4", 
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbgrad$dst,GEwgpawofbgrad$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsgrad$p.value, digits = 3),
                          "     ,     ",
                          gradslope,
                          "          ,   " ,
                          round(Gradwgpawofbstatgrprnd$dstbar,digits = 1),
                          "     ,   " ,
                          round(Gradwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  annotate("text", x = 27000, y = .2, hjust = 0, vjust = 0, color = "red",     #can't get it to use npc coords
           label = (str_c(" R= ",
                          round(cor(GEwgpawofbexit$dst,GEwgpawofbexit$wgpa, use = "pairwise.complete.obs"), digits = 2), 
                          "        ,   p= ",
                          round(corrsltsexit$p.value, digits = 3),
                          "   ,     ",
                          exitslope,
                          "          ,   " ,
                          round(Exitwgpawofbstatgrprnd$dstbar
                                ,digits = 1),
                          "     ,   " ,
                          round(Exitwgpawofbstatgrprnd$wgpabar, digits = 2), ")" ))) +
  
  #   stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,   `~")), method = "pearson", label.x.npc = "left", label.y.npc = "bottom") +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ZIP DISTANCE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "Zip Distance",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") 

#Build vertical bars
vb0 <- annotation_custom(grid::textGrob(label = "|",                 #can't get it to use color = "red",
                                        x = unit(.40, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb1 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.55, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb2 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.675, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb3 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.79, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2))) 
vb4 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(.88, "npc"), y = unit(.145, "npc"), vjust = 0,  
                                        gp = grid::gpar(cex = 2))) 
vb5 <- annotation_custom(grid::textGrob(label = "|", 
                                        x = unit(1, "npc"), y = unit(.145, "npc"), vjust = 0,   
                                        gp = grid::gpar(cex = 2)))
t1 <-  annotation_custom(grid::textGrob(label = "   Correlation      Significant     Slope of     Avg           Avg     ", 
                                        x = unit(.4, "npc"), y = unit(.170, "npc"), vjust = 0, hjust = 0,   
                                        gp = grid::gpar(cex = 1))) 
t2 <-  annotation_custom(grid::textGrob(label = "    Coeff                if p < .05        Line           DST      WJC GPA   ", 
                                        x = unit(.4, "npc"), y = unit(.13, "npc"), vjust = 0, hjust = 0,  
                                        gp = grid::gpar(cex = 1))) 
v <- w + vb0 +vb1 + vb2 + vb3 + vb4 + vb5 + t1 + t2
v
# manually save as wgpaxdst at 744 x 581
#ggsave("E:/000 DTS 400 Internship/PLOTS3/wgpaxdst w annt 27x21 from ggsave while console exact 27x21.jpeg",  width = 27, height = 21, units = "cm")

###########
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$engsembar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w

w <- ggplot(GEwgpawofb, aes(engsem, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engsembar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$engsembar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$tcrbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(tcr, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = tcrbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$tcrbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$hsgpabar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(hsgpa, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = hsgpabar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$hsgpabar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$cmpbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(cmp, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = cmpbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$cmpbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$matbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(mat, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = matbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$matbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxmat.jpeg",  width = 9, height = 7, units = "in")

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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$scibar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(sci, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = scibar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$scibar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$engbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(eng, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = engbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$engbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$rdgbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(rdg, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = rdgbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$rdgbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$dstbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w
w <- ggplot(GEwgpawofb, aes(dst, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = dstbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$dstbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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





# BOXPLOTS of CATEGORICAL VARIABLES seg, race, hst, alum  (then split by status: grad vs non-grad)
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.

# Load libraries
library(tidyverse)
library(dplyr)
library(readxl)
library(ggpubr)  #scatter plots with CI and stats

#Set the colors
listofcolors <- c("red","springgreen4")

#Read-In the Worksheet
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("WORKFILE2.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwofb <- read_excel("WORKFILE2.xlsx", sheet = "GandE without filled blanks")
GEwofb

#Take out the "No GPA on record, so now it's: Grads and Exits with gpas, and without filled blanks
GEwgpawofb <- filter(GEwofb, status != "No GPA on record")
GEwgpawofb     #172 rows

#Create function that will write the count and mean above or below the boxplot
# https://medium.com/@gscheithauer/how-to-add-number-of-observations-to-a-ggplot2-boxplot-b22710f7ef80
#This function results in Count = 123
stat_box_data <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste('count=', length(y), '\n',
                    'mean =', round(mean(y), 1), '\n')
    )
  )
}

#This function results in mirror image:  123 = Count
stat_box_data2 <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste(length(y), '= count', '\n',
                    round(mean(y),1), '= mean', '\n')
    )
  )
}



#wgpaxsegment
seg_levels <- c("Humanities","Nursing","Pre-Professional","Sciences","Social Sciences","Undecided")
GEwgpawofb$segfct <- factor(GEwgpawofb$segment, levels = seg_levels)
GEwgpawofb$segfct

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows

v <- ggplot(GEwgpawofb, aes(segment, wgpa, color = status)) +
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of MAJOR on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "Major Groupings (Segments)",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(segfct, wgpa), 
             fun.data = stat_box_data, 
             geom = "text", size = 2.5,
             hjust = 1,
             vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(segfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", size = 2.5,
               hjust = -0.05,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(segfct, wgpa), 
               inherit.aes = FALSE, size = 2.5,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 15) 


v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxsegment.jpeg",  width = 9, height = 7, units = "in")

#wgpaxrace
rac_levels <- c("White","Black","Hispanic","Asian","NRA","2 or more","Not Disclosed")
GEwgpawofb$racfct <- factor(GEwgpawofb$race, levels = rac_levels)
GEwgpawofb$racfct

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows

v <- ggplot(GEwgpawofb, aes(race, wgpa, color = status)) +
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of RACE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "RACE",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = FALSE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(racfct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", size = 2.5,
               hjust = 1,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(racfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", size = 2.5,
               hjust = -0.05,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(racfct, wgpa), 
               inherit.aes = FALSE, size = 2.5,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 15) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxrace.jpeg",  width = 9, height = 7, units = "in")

#wgpaxhst
hst_levels <- c("Public","Private/Parochial","Foreign","Home School")
GEwgpawofb$hstypefct <- factor(GEwgpawofb$hstype, levels = hst_levels)
GEwgpawofb$hstypefct

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows

v <- ggplot(GEwgpawofb, aes(hstypefct, wgpa, color = status)) +
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of HIGH SCHOOL TYPE on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "High School Type",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = FALSE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(hstypefct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", size = 2.5,
               hjust = 1,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(hstypefct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", size = 2.5,
               hjust = -0.05,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(hstypefct, wgpa), 
               inherit.aes = FALSE, size = 2.5,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 15) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxhst.jpeg",  width = 9, height = 7, units = "in")

#wgpaxalum
alum_levels <- c("Zero","One","Two","Three")
GEwgpawofb$alumnifct <- factor(GEwgpawofb$alumni, levels = alum_levels)
GEwgpawofb$alumnifct

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows

v <- ggplot(GEwgpawofb, aes(alumnifct, wgpa, color = status)) +
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of NUMBER of ALUMNI CONNECTIONS on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "Number of Alumni Connections",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(alumnifct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", size = 2.5,
               hjust = 1,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(alumnifct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", size = 2.5,
               hjust = -0.05,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(alumnifct, wgpa), 
               inherit.aes = FALSE, size = 2.5,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 15) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxalum.jpeg",  width = 9, height = 7, units = "in")



# BINARY VARIABLES -- gndr, nm, yr, ext
# Load libraries
library(tidyverse)
library(dplyr)
library(readxl)
library(ggpubr)  #scatter plots with CI and stats

#Set the colors
listofcolors <- c("red","springgreen4")

#Read-In the Worksheet
#This excel file contains a number of tables on different sheets of the workbook. We can see a listing of the sheets using the excel_sheets function.
excel_sheets("WORKFILE2.xlsx")
#'Now we will load our data using the read_excel function. We will load the data from the Purchase Date April 2019 sheet.
GEwofb <- read_excel("WORKFILE2.xlsx", sheet = "GandE without filled blanks")
GEwofb

#Take out the "No GPA on record, so now it's: Grads and Exits with gpas, and without filled blanks
GEwgpawofb <- filter(GEwofb, status != "No GPA on record")
GEwgpawofb     #172 rows

#Create function that will write the count and mean above or below the boxplot
# https://medium.com/@gscheithauer/how-to-add-number-of-observations-to-a-ggplot2-boxplot-b22710f7ef80
#This function results in Count = 123
stat_box_data <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste('count=', length(y), '\n',
                    'mean =', round(mean(y), 1), '\n')
    )
  )
}

#This function results in mirror image:  123 = Count
stat_box_data2 <- function(y, upper_limit = 4 * 1.15) {
  return( 
    data.frame(
      y = 0.95 * upper_limit,
      label = paste(length(y), '= count', '\n',
                    round(mean(y),1), '= mean', '\n')
    )
  )
}


#wgpaxnm

#Set the order to display categories in the y axis
nmyn_levels <- c("No","Yes")
GEwgpawofb$nmynfct <- factor(GEwgpawofb$nmyn, levels = nmyn_levels)
GEwgpawofb$nmynfct
GEwgpawofb

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows


v <- ggplot(GEwgpawofb, aes(nmynfct, wgpa, color = status)) +  
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of NATIONAL MERIT SCHOLARSHIP on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "NATIONAL MERIT SCHOLAR?",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = FALSE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(nmynfct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", 
               hjust = 1.2,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(nmynfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = -.2,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(nmynfct, wgpa), 
               inherit.aes = FALSE,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 9) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxnm.jpeg",  width = 9, height = 7, units = "in")


#wgpaxgndr
gndr_levels <- c("Female","Male","Unknown")
GEwgpawofb$gndrfct <- factor(GEwgpawofb$sex, levels = gndr_levels)
GEwgpawofb$gndrfct
GEwgpawofb

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows


v <- ggplot(GEwgpawofb %>% filter(!is.na(sex)), aes(gndrfct, wgpa, color = status)) +   #got rid of two blanks which created a NA boxplot
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of GENDER on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "GENDER",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = FALSE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(gndrfct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", 
               hjust = 1.05,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(gndrfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = -.15,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(gndrfct, wgpa), 
               inherit.aes = FALSE,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 9) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxgndr.jpeg",  width = 9, height = 7, units = "in")

#wgpaxyr
yr_levels <- c("2015","2016")
GEwgpawofb$yrfct <- factor(GEwgpawofb$start, levels = yr_levels)
GEwgpawofb$yrfct
GEwgpawofb

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows


v <- ggplot(GEwgpawofb, aes(yrfct, wgpa, color = status)) +  
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Effect of ADMISSION YEAR on WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "ADMISSION YEAR",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = FALSE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(yrfct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", 
               hjust = 1.2,
               vjust = 0.9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(yrfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = -.2,
               vjust = 0.9) +
  stat_summary(GEwgpawofb, mapping = aes(yrfct, wgpa), 
               inherit.aes = FALSE,
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 9) 
v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxyr.jpeg",  width = 9, height = 7, units = "in")

#wgpaxyr
ext_levels <- c("No","Yes")
GEwgpawofb$extfct <- factor(GEwgpawofb$extyn, levels = ext_levels)
GEwgpawofb$extfct
GEwgpawofb

#create subset of only exits or only grads, these will be called when writing the count and mean above or below
#this needs to be decentralized in each plot, so that yrfct variable from the previous step is in these two dataframes that about to be created.
GEwgpawofbexit  <- filter(GEwgpawofb, extyn == "Yes")
GEwgpawofbexit  #21 rows

GEwgpawofbgrad  <- filter(GEwgpawofb, extyn == "No")
GEwgpawofbgrad  #151 rows


v <- ggplot(GEwgpawofb, aes(extfct, wgpa, color = status)) +  
  geom_boxplot(, varwidth = TRUE) +
  geom_jitter(width = 0.2) +
  scale_color_manual(values = listofcolors) +
  labs(title = "The Relationship between EXITING and WJC GPA ", 
       subtitle = "All Students with a WJC GPA on record, whether or not they graduated",
       caption = "Source: WJC Admissions Records",
       x = "EXITED, but DO have a GPA on record ?",
       y = "William Jewell College GPA",
       color = "Student Status:",
       size = "                     Avg X, Avg Y:") +
  guides(color = guide_legend(reverse = TRUE)) +
  theme(legend.position = "bottom", legend.box = "horizontal") +
  stat_summary(GEwgpawofbexit, mapping = aes(extfct, wgpa), 
               fun.data = stat_box_data2, 
               geom = "text", 
               hjust = .5,
               vjust = 9) +
  stat_summary(GEwgpawofbgrad, mapping = aes(extfct, wgpa), 
               fun.data = stat_box_data, 
               geom = "text", 
               hjust = .5,
               vjust = 9) 

v
ggsave("E:/000 DTS 400 Internship/PLOTS/wgpaxext.jpeg",  width = 9, height = 7, units = "in")


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
  theme(legend.position = "bottom", legend.box = "horizontal") +
  geom_text(data = GEwgpawofbstatgrprnd, aes(x = 250, y = 2.5, color = status), 
            label = paste0('Average:   ( ',GEwgpawofbstatgrprnd$prnkbar,'  ,  ',GEwgpawofbstatgrprnd$wgpabar, ' )', '\n'), 
            position_jitter(height = 0, seed = 2))
w

w <- ggplot(GEwgpawofb, aes(prnk, wgpa, color = status)) +
  geom_point() +
  geom_smooth(method = lm, lwd=1) +
  geom_point(GEwgpawofbstatgrp, mapping = aes(x = prnkbar, y = wgpabar, size = 12, color = status), shape = 8) +  
  ggrepel::geom_label_repel(aes(label = paste("Avg:  ", "( ", (round(GEwgpawofbstatgrprnd$prnkbar, digits = 1)),"  ,  ",(round(GEwgpawofbstatgrprnd$wgpabar, digits = 2)), " )"), sep = "  ", 
                                color = status), data = GEwgpawofbstatgrprnd) +
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
