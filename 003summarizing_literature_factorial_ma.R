##############################################################
# Authors: 
#
# Alfredo Sanchez-Tojar (@ASanchez_Tojar)
# Profile: https://goo.gl/PmpPEB
# Bielefeld University
# Email: alfredo.tojar@gmail.com

##############################################################
# Description of script and Instructions
##############################################################

# Script first created the 30th Nov 2018

# This script is to summarize the number of articles that cite
# the following four articles, and actually used the factorial
# meta-analysis method described in each of them.

#Gurevitch et al. 2000, AmNat: The interaction between competition and predation: a meta-analysis of field experiments.
#Hawkes and Sullivan 2001, Ecology: The impact of herbivory on plants in different resource conditions: a meta-analysis.
#Morris et al. 2007, Ecology: Direct and interactive effects of enemies and mutualists on plant performance: a meta-analysis.
#Lajeunesse 2011, Ecology: On the meta-analysis of response ratios for studies with correlated and multi-group designs.


##############################################################
# Packages needed
##############################################################

# load pacakges
library(doBy)


# cleaning up
rm(list=ls())


##############################################################
# Functions needed
##############################################################

#none

##############################################################
# Importing data
##############################################################

##################################################################################
# Factorial meta-analysis based on Cohen's d or Hedge's g [Gurevitch et al. 2000]
##################################################################################

factorial.d.g <- read.table("the_final_database/Gurevitch_et_al_2000_v2_included_reduced_DATA.csv",
                            header=TRUE,sep=",")

factorial.d.g.subset <- factorial.d.g[factorial.d.g$reported_effect_size_used=="d" |
                                        factorial.d.g$reported_effect_size_used=="g",]


factorial.d.g.per.year <- summaryBy(methods_used~year,data=factorial.d.g.subset,FUN=sum)


#sequence <- seq(min(factorial.d.g.per.year$year),max(factorial.d.g.per.year$year),1)
sequence <- seq(2000,max(factorial.d.g.per.year$year),1)


for(i in 1:length(sequence)){
  if(!(sequence[i]%in%factorial.d.g.per.year$year)){
    factorial.d.g.per.year<-rbind(factorial.d.g.per.year,c(sequence[i],0))
  }
}

#adding Gurevitch et al. 2000 paper itself
factorial.d.g.per.year[factorial.d.g.per.year$year==2000,"methods_used.sum"]<- factorial.d.g.per.year[factorial.d.g.per.year$year==2000,"methods_used.sum"] + 1

factorial.d.g.per.year <- factorial.d.g.per.year[order(factorial.d.g.per.year$year),]


tiff("plots/Factorial_ma_d_and_g.tiff",
     height=10.5, width=10.5,
     units='cm', compression="lzw", res=600)

op <- par(mgp=c(1,0.35,0), mar = c(3.5,3.25,0.5,0)) #bottom, left, top, and right. 


x <- barplot(factorial.d.g.per.year$methods_used.sum,factorial.d.g.per.year$year,
             yaxt="n",
             xaxt="n",
             ylim=c(0,4),
             col=rgb(196/255,196/255,196/255,0.8))

axis(2,at=seq(0,4,1),
     cex.axis=0.7,tck=-0.015,las=2)

axis(1,at=x,
     labels=seq(2000,2018,1),
     cex.axis=0.7,tck=-0.015,las=2)

title(xlab = "Year",
      ylab = "Number of publications",
      cex.lab=1.25,line=2)

dev.off()


####################################################################################################
# Factorial meta-analysis based on lnRR [Hawkes & Sullivan 2001, Morris et al 2007, Lajeuness 2011]
####################################################################################################

factorial.lnRR.1 <- read.table("the_final_database/lnRR_included_reduced_DATA.csv",
                            header=TRUE,sep=",")

factorial.lnRR.2 <- read.table("the_final_database/lnRR_included_reduced_v2_additional_refs_DATA.csv",
                             header=TRUE,sep=",")

factorial.lnRR <- rbind(factorial.lnRR.1,factorial.lnRR.2)


factorial.lnRR.subset <- factorial.lnRR[!(is.na(factorial.lnRR$methods_used)),]
#factorial.lnRR.subset <- factorial.lnRR.subset[factorial.lnRR.subset$methods_used==1,]
factorial.lnRR.subset <- factorial.lnRR.subset[factorial.lnRR.subset$reported_effect_size_used=="lnRR",]


factorial.lnRR.per.year <- summaryBy(methods_used~year,data=factorial.lnRR.subset,FUN=sum)


#sequence <- seq(min(factorial.lnRR.per.year$year),max(factorial.lnRR.per.year$year),1)
sequence <- seq(2000,max(factorial.lnRR.per.year$year),1)


for(i in 1:length(sequence)){
  if(!(sequence[i]%in%factorial.lnRR.per.year$year)){
    factorial.lnRR.per.year<-rbind(factorial.lnRR.per.year,c(sequence[i],0))
  }
}

#adding Hawkes and Sullivan 2001, which is not in the list so far
factorial.lnRR.per.year[factorial.lnRR.per.year$year==2001,"methods_used.sum"]<-factorial.lnRR.per.year[factorial.lnRR.per.year$year==2001,"methods_used.sum"] + 1

factorial.lnRR.per.year <- factorial.lnRR.per.year[order(factorial.lnRR.per.year$year),]

tiff("plots/Factorial_ma_lnRR.tiff",
     height=10.5, width=10.5,
     units='cm', compression="lzw", res=600)

op <- par(mgp=c(1,0.35,0), mar = c(3.5,3.25,0.5,0)) #bottom, left, top, and right. 


x <- barplot(factorial.lnRR.per.year$methods_used.sum,factorial.lnRR.per.year$year,
             yaxt="n",
             xaxt="n",
             ylim=c(0,5),
             col=rgb(196/255,196/255,196/255,0.8))

axis(2,at=seq(0,5,1),
     cex.axis=0.7,tck=-0.015,las=2)

axis(1,at=x,
     labels=seq(2000,2018,1),
     cex.axis=0.7,tck=-0.015,las=2)

title(xlab = "Year",
      ylab = "Number of publications",
      cex.lab=1.25,line=2)

dev.off()



####################################################################################################
# Factorial meta-analysis - COMBINED
####################################################################################################

factorial <- merge(factorial.d.g.per.year,factorial.lnRR.per.year,by="year",all.x=T)
factorial$methods_used.sum.y <- ifelse(is.na(factorial$methods_used.sum.y),
                                       0,
                                       factorial$methods_used.sum.y)

factorial$total <- factorial$methods_used.sum.x + factorial$methods_used.sum.y
factorial.red <- factorial[,c("year","total")]

sum(factorial.red$total)


tiff("plots/Factorial_ma_total.tiff",
     height=10.5, width=10.5,
     units='cm', compression="lzw", res=600)

op <- par(mgp=c(1,0.35,0), mar = c(3.5,3.25,0.5,0)) #bottom, left, top, and right. 


x <- barplot(factorial.red$total,factorial.red$year,
             yaxt="n",
             xaxt="n",
             ylim=c(0,6),
             col=rgb(196/255,196/255,196/255,0.8))

barplot(factorial.lnRR.per.year$methods_used.sum,factorial.lnRR.per.year$year,
        yaxt="n",
        xaxt="n",
        ylim=c(0,6),
        col=rgb(77/255,77/255,77/255,0.8),add=T)

axis(2,at=seq(0,6,1),
     cex.axis=0.7,tck=-0.015,las=2,line=0.5)

axis(1,at=x,
     labels=seq(2000,2018,1),
     cex.axis=0.7,tck=-0.015,las=2)

title(xlab = "Year",
      ylab = "Number of publications",
      cex.lab=1.25,line=2)


legend(2000,5.8,
       c("Hedge's d/g",
         "lnRR"),
       pt.bg=c(rgb(196/255,196/255,196/255,0.8),rgb(77/255,77/255,77/255,0.8)),
       pt.cex=1,
       cex=0.7,
       pch=21,
       inset=c(0,0),
       y.intersp=1.1,x.intersp=1.1)


dev.off()


# included papers database

included.final <- rbind(factorial.d.g.subset,factorial.lnRR.subset)

write.csv(included.final,
          "the_final_database/included_FINAL.csv",row.names=FALSE)
