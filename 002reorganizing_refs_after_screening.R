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

# Script first created the 28th Nov 2018

# This script is to subset the screening outputs (from rayyan) of 
# the references citing the following 4 publications 

#Gurevitch et al. 2000, AmNat: The interaction between competition and predation: a meta-analysis of field experiments.
#Hawkes and Sullivan 2001, Ecology: The impact of herbivory on plants in different resource conditions: a meta-analysis.
#Morris et al. 2007, Ecology: Direct and interactive effects of enemies and mutualists on plant performance: a meta-analysis.
#Lajeunesse 2011, Ecology: On the meta-analysis of response ratios for studies with correlated and multi-group designs.


##############################################################
# Packages needed
##############################################################

# load pacakges
install.packages("revtools")
#devtools::install_github("mjwestgate/revtools")
library(revtools) 
#library(plyr)

# cleaning up
rm(list=ls())


##############################################################
# Functions needed
##############################################################

#none

##############################################################
# Importing screened reference data
##############################################################

# More information: https://docs.google.com/document/d/1mlEl7E_svDc9WiZDHy1V4DMDlvqfyKpjildiH2duL4I/edit?usp=sharing


##################################################################################
# Factorial meta-analysis based on Cohen's d or Hedge's g [Gurevitch et al. 2000]
##################################################################################

gurevitch <- read.table("output_rayyan/Gurevitch_et_al_2000_screening_v2.csv",header=T,sep=",") #get rid off ' in title, I did this manually. I also got rid off some crap in the notes of citations number 1.
#test <- read.table("output_rayyan/trial.csv",header=T,sep=",")


# subsetting those papers that were included for further screening
gurevitch.included <- gurevitch[substr(gurevitch$notes, 32,35)=="true",] #subsetting those that need fulltext screening


# generating a simpler unique idenfier for the included papers
gurevitch.included$studyID <- paste0("Gurevitch",1:nrow(gurevitch.included))

write.csv(gurevitch.included,
          "output_rayyan/Gurevitch_et_al_2000_v2_included_full.csv",row.names=FALSE)


#reducing the number of variables to make it more handy
# gurevitch.included.reduced <- gurevitch.included
# gurevitch.included.reduced[,"notes"] <- NULL 
gurevitch.included.veryreduced <- gurevitch.included[,c("studyID","title","year")]

write.csv(gurevitch.included.veryreduced,
          "output_rayyan/Gurevitch_et_al_2000_v2_included_reduced.csv",row.names=FALSE)


####################################################################################################
# Factorial meta-analysis based on lnRR [Hawkes & Sullivan 2001, Morris et al 2007, Lajeuness 2011]
####################################################################################################

# In this case, we combine the remaining three papers as they all three cover factorial
# meta-analysis for lnRR. Thus, we need to create a combined deduplicated database.

Hawkes <- read.table("output_rayyan/Hawkes_and_Sullivan_2001_screening_v2.csv",header=T,sep=",") #get rid off ' in title, I did this manually. I also got rid off some crap in the notes of citations number 1.
Hawkes.included <- Hawkes[substr(Hawkes$notes, 32,35)=="true",] #subsetting those that need fulltext screening

Morris <- read.table("output_rayyan/Morris_et_al_2007_screening.csv",header=T,sep=",") #get rid off ' in title, I did this manually. I also got rid off some crap in the notes of citations number 1.
Morris.included <- Morris[substr(Morris$notes, 32,35)=="true",] #subsetting those that need fulltext screening

Lajeunesse <- read.table("output_rayyan/Lajeunesse_2011_screening.csv",header=T,sep=",") #get rid off ' in title, I did this manually. I also got rid off some crap in the notes of citations number 1.
Lajeunesse.included <- Lajeunesse[substr(Lajeunesse$notes, 32,35)=="true",] #subsetting those that need fulltext screening

# combining all databases together
lnRR <- unique(rbind(Hawkes.included,Morris.included,Lajeunesse.included))


# searching duplicates using revtools
search.duplicated <- find_duplicates(data = lnRR,
                                     match_variable = "title",
                                     group_variable = NULL,
                                     match_function = "fuzzdist",
                                     method = "fuzz_partial_ratio",
                                     threshold = 0)


# extracing duplicates
lnRR.unique <- extract_unique_references(lnRR, search.duplicated)
lnRR.unique <- lnRR.unique[order(lnRR.unique$title),]


# generating a simpler unique idenfier for the included papers
lnRR.unique$studyID <- paste0("lnRR",1:nrow(lnRR.unique))

write.csv(lnRR.unique,
          "output_rayyan/lnRR_included_full.csv",row.names=FALSE)


#reducing the number of variables to make it more handy
lnRR.unique.veryreduced <- lnRR.unique[,c("studyID","title","year")]

write.csv(lnRR.unique.veryreduced,
          "output_rayyan/lnRR_included_reduced.csv",row.names=FALSE)

