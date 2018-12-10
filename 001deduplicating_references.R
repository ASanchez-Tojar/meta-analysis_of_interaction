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

# Script first created the 15th Nov 2018

# This script is to import the results of the references citing
# the following 4 publications by today 15th Nov 2018:

#Gurevitch et al. 2000, AmNat: The interaction between competition and predation: a meta-analysis of field experiments.
#Hawkes and Sullivan 2001, Ecology: The impact of herbivory on plants in different resource conditions: a meta-analysis.
#Morris et al. 2007, Ecology: Direct and interactive effects of enemies and mutualists on plant performance: a meta-analysis.
#Lajeunesse 2011, Ecology: On the meta-analysis of response ratios for studies with correlated and multi-group designs.


##############################################################
# Packages needed
##############################################################

# load pacakges
# install.packages("revtools")
devtools::install_github("mjwestgate/revtools")
library(revtools) #developing package installed from GitHub
library(plyr)

# cleaning up
rm(list=ls())


##############################################################
# Functions needed
##############################################################

#none

##############################################################
# Importing reference data
##############################################################

# the literature searches were conducted on the 15 Nov of 2018

# More information: https://docs.google.com/document/d/1mlEl7E_svDc9WiZDHy1V4DMDlvqfyKpjildiH2duL4I/edit?usp=sharing


##############################################################
# Gurevitch et al. 2000
##############################################################

#################
# Web of Science
#################

# importing the .bib file
wos_Gurevitch <- as.data.frame(read_bibliography("literature_searches_results/Gurevitch_et_al_2000_WoS.bib")) # as.data.frame() should not be needed in the udpated version of revtools, but it doesn't hurt to have it there


# reducing fields to the minimum number of fields so that
# all databases have the same columns. Also, these fields
# are the important ones for the screening files (see below).

reducing.fields <- c("label","title","author","journal","issn",
                         "volume","pages","year","doi","abstract")

wos_Gurevitch.red <- wos_Gurevitch[,reducing.fields]


#########
# PubMed
#########

# importing the .nbib files
pubmed_Gurevitch <- as.data.frame(read_bibliography("literature_searches_results/Gurevitch_et_al_2000_PubMed.nbib"))


# reducing fields
pubmed_Gurevitch.red <- pubmed_Gurevitch[,reducing.fields]


#########
# Scopus
#########

# importing the .bib files
scopus_Gurevitch <- as.data.frame(read_bibliography("literature_searches_results/Gurevitch_et_al_2010_Scopus.bib"))


# reducing fields 
scopus_Gurevitch.red <- scopus_Gurevitch[,reducing.fields]


##############################################################
# Full reference data: before deduplication
##############################################################

full.Gurevitch <- rbind(wos_Gurevitch.red,pubmed_Gurevitch.red,scopus_Gurevitch.red)

write.csv(full.Gurevitch,"output_cleaning_reference_list/Gurevitch_bf_deduplication.csv",row.names=FALSE)



##############################################################
# Screening reference data: after deduplication
##############################################################

# the devoloping revtools does not seem to be ready for deduplication
# (i.e. find_duplicates() does not work). Therefore, we used
# the CRAN version of the package for this process

install.packages("revtools")
library(revtools)
library(plyr)


# saving the information regarding the versions of the R packages
# for future reference
sink("output_cleaning_reference_list/deduplicating_Rpackages_session.txt")
sessionInfo()
sink()


# searching duplicates
search.duplicated.Gurevitch <- find_duplicates(full.Gurevitch)


# extracing duplicates
screening.ref.data.Gurevitch <- extract_unique_references(search.duplicated.Gurevitch)
write.csv(screening.ref.data.Gurevitch,"output_cleaning_reference_list/Gurevitch_deduplicated.csv",row.names=FALSE)


# re-installing the most updated version of revtools
devtools::install_github("mjwestgate/revtools")


##############################################################
# Formatting data for RAYYAN QCRI
##############################################################

# choose only the fields needed for creating a .csv file importable by: https://rayyan.qcri.org

# example of a valid .csv file
rayyan.example <- read.table("output_cleaning_reference_list/rayyan_csv_example.csv",header=TRUE,sep=",")
names(rayyan.example)
names(screening.ref.data)

# standardizing fields according to rayyan.example despite that some fields are missing from the wos output

# what's different between the two?
setdiff(names(rayyan.example),names(screening.ref.data.Gurevitch))
setdiff(names(screening.ref.data.Gurevitch),names(rayyan.example))

# creating two variables that were not present in screening.ref.data
screening.ref.data.Gurevitch$issue <- ""
screening.ref.data.Gurevitch$publisher <- ""

# excluding two variables that are not needed
screening.ref.data.Gurevitch$duplicate_group <- NULL
screening.ref.data.Gurevitch$n_duplicates <- NULL

# what's different now?
setdiff(names(rayyan.example),names(screening.ref.data.Gurevitch))
setdiff(names(screening.ref.data.Gurevitch),names(rayyan.example))

# rename columns in screening.ref.data so that they are as expected by rayyan
names(rayyan.example)
names(screening.ref.data.Gurevitch)

screening.ref.data.Gurevitch.rayyan <- rename(screening.ref.data.Gurevitch, c("label"="key", "author"="authors", "doi"="url"))
names(screening.ref.data.Gurevitch.rayyan)

# reorder
screening.ref.data.Gurevitch.rayyan <- screening.ref.data.Gurevitch.rayyan[,names(rayyan.example)]





# finding authors with missing initial(s) as that causes an error when importing into rayyan
table(grepl(",  ",screening.ref.data.Gurevitch.rayyan$authors,fixed=T))

for(i in 1:nrow(screening.ref.data.Gurevitch.rayyan)){
  
  if(grepl(",  ",screening.ref.data.Gurevitch.rayyan$authors[i],fixed=T)){
    
    print(i)
  }
  
}


write.csv(screening.ref.data.Gurevitch.rayyan,"output_cleaning_reference_list/Gurevitch_deduplicated_rayyan.csv",row.names=FALSE)
#remember to manually remove the quotes for the column names only in the .csv file




##############################################################
# Hawkes and Sullivan 2001
##############################################################

#################
# Web of Science
#################

# importing the .bib file
wos_Hawkes <- as.data.frame(read_bibliography("literature_searches_results/Hawkes_and_Sullivan_2001_WoS.bib")) # as.data.frame() should not be needed in the udpated version of revtools, but it doesn't hurt to have it there


# reducing fields to the minimum number of fields so that
# all databases have the same columns. Also, these fields
# are the important ones for the screening files (see below).

reducing.fields <- c("label","title","author","journal","issn",
                     "volume","pages","year","doi","abstract")

wos_Hawkes.red <- wos_Hawkes[,reducing.fields]


#########
# PubMed
#########

# no file

#########
# Scopus
#########

# importing the .bib files
scopus_Hawkes <- as.data.frame(read_bibliography("literature_searches_results/Hawkes_and_Sullivan_2001_Scopus.bib"))


# reducing fields 
scopus_Hawkes.red <- scopus_Hawkes[,reducing.fields]


##############################################################
# Full reference data: before deduplication
##############################################################

full.Hawkes <- rbind(wos_Hawkes.red,scopus_Hawkes.red)

write.csv(full.Hawkes,"output_cleaning_reference_list/Hawkes_bf_deduplication.csv",row.names=FALSE)



##############################################################
# Screening reference data: after deduplication
##############################################################

# the devoloping revtools does not seem to be ready for deduplication
# (i.e. find_duplicates() does not work). Therefore, we used
# the CRAN version of the package for this process

install.packages("revtools")
library(revtools)
library(plyr)


# # saving the information regarding the versions of the R packages
# # for future reference
# sink("output_cleaning_reference_list/deduplicating_Rpackages_session.txt")
# sessionInfo()
# sink()


# searching duplicates
search.duplicated.Hawkes <- find_duplicates(full.Hawkes)


# extracing duplicates
screening.ref.data.Hawkes <- extract_unique_references(search.duplicated.Hawkes)
write.csv(screening.ref.data.Hawkes,"output_cleaning_reference_list/Hawkes_deduplicated.csv",row.names=FALSE)


# re-installing the most updated version of revtools
devtools::install_github("mjwestgate/revtools")


##############################################################
# Formatting data for RAYYAN QCRI
##############################################################

# choose only the fields needed for creating a .csv file importable by: https://rayyan.qcri.org

# example of a valid .csv file
rayyan.example <- read.table("output_cleaning_reference_list/rayyan_csv_example.csv",header=TRUE,sep=",")
names(rayyan.example)
names(screening.ref.data)

# standardizing fields according to rayyan.example despite that some fields are missing from the wos output

# what's different between the two?
setdiff(names(rayyan.example),names(screening.ref.data.Hawkes))
setdiff(names(screening.ref.data.Hawkes),names(rayyan.example))

# creating two variables that were not present in screening.ref.data
screening.ref.data.Hawkes$issue <- ""
screening.ref.data.Hawkes$publisher <- ""

# excluding two variables that are not needed
screening.ref.data.Hawkes$duplicate_group <- NULL
screening.ref.data.Hawkes$n_duplicates <- NULL

# what's different now?
setdiff(names(rayyan.example),names(screening.ref.data.Hawkes))
setdiff(names(screening.ref.data.Hawkes),names(rayyan.example))

# rename columns in screening.ref.data so that they are as expected by rayyan
names(rayyan.example)
names(screening.ref.data.Hawkes)

screening.ref.data.Hawkes.rayyan <- rename(screening.ref.data.Hawkes, c("label"="key", "author"="authors", "doi"="url"))
names(screening.ref.data.Hawkes.rayyan)

# reorder
screening.ref.data.Hawkes.rayyan <- screening.ref.data.Hawkes.rayyan[,names(rayyan.example)]





# finding authors with missing initial(s) as that causes an error when importing into rayyan
table(grepl(",  ",screening.ref.data.Hawkes.rayyan$authors,fixed=T))

for(i in 1:nrow(screening.ref.data.Hawkes.rayyan)){
  
  if(grepl(",  ",screening.ref.data.Hawkes.rayyan$authors[i],fixed=T)){
    
    print(i)
  }
  
}


write.csv(screening.ref.data.Hawkes.rayyan,"output_cleaning_reference_list/Hawkes_deduplicated_rayyan.csv",row.names=FALSE)
#write.csv(screening.ref.data.rayyan,"output_cleaning_reference_list/testing.csv",row.names=FALSE)
#remember to manually remove the quotes for the column names only in the .csv file




##############################################################
# Morris et al. 2007
##############################################################

#################
# Web of Science
#################

# importing the .bib file
wos_Morris <- as.data.frame(read_bibliography("literature_searches_results/Morris_et_al_2007_WoS.bib")) # as.data.frame() should not be needed in the udpated version of revtools, but it doesn't hurt to have it there


# reducing fields to the minimum number of fields so that
# all databases have the same columns. Also, these fields
# are the important ones for the screening files (see below).

reducing.fields <- c("label","title","author","journal","issn",
                     "volume","pages","year","doi","abstract")

wos_Morris.red <- wos_Morris[,reducing.fields]


#########
# PubMed
#########

# importing the .nbib files
pubmed_Morris <- as.data.frame(read_bibliography("literature_searches_results/Morris_et_al_2007_PubMed.nbib"))


# reducing fields
pubmed_Morris.red <- pubmed_Morris[,reducing.fields]


#########
# Scopus
#########

# importing the .bib files
scopus_Morris <- as.data.frame(read_bibliography("literature_searches_results/Morris_et_al_2007_Scopus.bib"))


# reducing fields 
scopus_Morris.red <- scopus_Morris[,reducing.fields]


##############################################################
# Full reference data: before deduplication
##############################################################

full.Morris <- rbind(wos_Morris.red,pubmed_Morris.red,scopus_Morris.red)

write.csv(full.Morris,"output_cleaning_reference_list/Morris_bf_deduplication.csv",row.names=FALSE)



##############################################################
# Screening reference data: after deduplication
##############################################################

# the devoloping revtools does not seem to be ready for deduplication
# (i.e. find_duplicates() does not work). Therefore, we used
# the CRAN version of the package for this process

install.packages("revtools")
library(revtools)
library(plyr)


# # saving the information regarding the versions of the R packages
# # for future reference
# sink("output_cleaning_reference_list/deduplicating_Rpackages_session.txt")
# sessionInfo()
# sink()


# searching duplicates
search.duplicated.Morris <- find_duplicates(full.Morris)


# extracing duplicates
screening.ref.data.Morris <- extract_unique_references(search.duplicated.Morris)
write.csv(screening.ref.data.Morris,"output_cleaning_reference_list/Morris_deduplicated.csv",row.names=FALSE)


# re-installing the most updated version of revtools
devtools::install_github("mjwestgate/revtools")


##############################################################
# Formatting data for RAYYAN QCRI
##############################################################

# choose only the fields needed for creating a .csv file importable by: https://rayyan.qcri.org

# example of a valid .csv file
rayyan.example <- read.table("output_cleaning_reference_list/rayyan_csv_example.csv",header=TRUE,sep=",")
names(rayyan.example)
names(screening.ref.data)

# standardizing fields according to rayyan.example despite that some fields are missing from the wos output

# what's different between the two?
setdiff(names(rayyan.example),names(screening.ref.data.Morris))
setdiff(names(screening.ref.data.Morris),names(rayyan.example))

# creating two variables that were not present in screening.ref.data
screening.ref.data.Morris$issue <- ""
screening.ref.data.Morris$publisher <- ""

# excluding two variables that are not needed
screening.ref.data.Morris$duplicate_group <- NULL
screening.ref.data.Morris$n_duplicates <- NULL

# what's different now?
setdiff(names(rayyan.example),names(screening.ref.data.Morris))
setdiff(names(screening.ref.data.Morris),names(rayyan.example))

# rename columns in screening.ref.data so that they are as expected by rayyan
names(rayyan.example)
names(screening.ref.data.Morris)

screening.ref.data.Morris.rayyan <- rename(screening.ref.data.Morris, c("label"="key", "author"="authors", "doi"="url"))
names(screening.ref.data.Morris.rayyan)

# reorder
screening.ref.data.Morris.rayyan <- screening.ref.data.Morris.rayyan[,names(rayyan.example)]


# finding authors with missing initial(s) as that causes an error when importing into rayyan
table(grepl(",  ",screening.ref.data.Morris.rayyan$authors,fixed=T))

for(i in 1:nrow(screening.ref.data.Morris.rayyan)){
  
  if(grepl(",  ",screening.ref.data.Morris.rayyan$authors[i],fixed=T)){
    
    print(i)
  }
  
}


write.csv(screening.ref.data.Morris.rayyan,"output_cleaning_reference_list/Morris_deduplicated_rayyan.csv",row.names=FALSE)
#write.csv(screening.ref.data.rayyan,"output_cleaning_reference_list/testing.csv",row.names=FALSE)
#remember to manually remove the quotes for the column names only in the .csv file




##############################################################
# Lajeunesse 2011
##############################################################

#################
# Web of Science
#################

# importing the .bib file
wos_Lajeunesse <- as.data.frame(read_bibliography("literature_searches_results/Lajeunesse_2011_WoS.bib")) # as.data.frame() should not be needed in the udpated version of revtools, but it doesn't hurt to have it there


# reducing fields to the minimum number of fields so that
# all databases have the same columns. Also, these fields
# are the important ones for the screening files (see below).

reducing.fields <- c("label","title","author","journal","issn",
                     "volume","pages","year","doi","abstract")

wos_Lajeunesse.red <- wos_Lajeunesse[,reducing.fields]


#########
# PubMed
#########

# importing the .nbib files
pubmed_Lajeunesse <- as.data.frame(read_bibliography("literature_searches_results/Lajeunesse_2011_PubMed.nbib"))


# reducing fields
pubmed_Lajeunesse.red <- pubmed_Lajeunesse[,reducing.fields]


#########
# Scopus
#########

# importing the .bib files
scopus_Lajeunesse <- as.data.frame(read_bibliography("literature_searches_results/Lajeunesse_2011_Scopus.bib"))


# reducing fields 
scopus_Lajeunesse.red <- scopus_Lajeunesse[,reducing.fields]


##############################################################
# Full reference data: before deduplication
##############################################################

full.Lajeunesse <- rbind(wos_Lajeunesse.red,pubmed_Lajeunesse.red,scopus_Lajeunesse.red)

write.csv(full.Lajeunesse,"output_cleaning_reference_list/Lajeunesse_bf_deduplication.csv",row.names=FALSE)



##############################################################
# Screening reference data: after deduplication
##############################################################

# the devoloping revtools does not seem to be ready for deduplication
# (i.e. find_duplicates() does not work). Therefore, we used
# the CRAN version of the package for this process

install.packages("revtools")
library(revtools)
library(plyr)


# # saving the information regarding the versions of the R packages
# # for future reference
# sink("output_cleaning_reference_list/deduplicating_Rpackages_session.txt")
# sessionInfo()
# sink()


# searching duplicates
search.duplicated.Lajeunesse <- find_duplicates(full.Lajeunesse)


# extracing duplicates
screening.ref.data.Lajeunesse <- extract_unique_references(search.duplicated.Lajeunesse)
write.csv(screening.ref.data.Lajeunesse,"output_cleaning_reference_list/Lajeunesse_deduplicated.csv",row.names=FALSE)


# re-installing the most updated version of revtools
devtools::install_github("mjwestgate/revtools")


##############################################################
# Formatting data for RAYYAN QCRI
##############################################################

# choose only the fields needed for creating a .csv file importable by: https://rayyan.qcri.org

# example of a valid .csv file
rayyan.example <- read.table("output_cleaning_reference_list/rayyan_csv_example.csv",header=TRUE,sep=",")
names(rayyan.example)
names(screening.ref.data)

# standardizing fields according to rayyan.example despite that some fields are missing from the wos output

# what's different between the two?
setdiff(names(rayyan.example),names(screening.ref.data.Lajeunesse))
setdiff(names(screening.ref.data.Lajeunesse),names(rayyan.example))

# creating two variables that were not present in screening.ref.data
screening.ref.data.Lajeunesse$issue <- ""
screening.ref.data.Lajeunesse$publisher <- ""

# excluding two variables that are not needed
screening.ref.data.Lajeunesse$duplicate_group <- NULL
screening.ref.data.Lajeunesse$n_duplicates <- NULL

# what's different now?
setdiff(names(rayyan.example),names(screening.ref.data.Lajeunesse))
setdiff(names(screening.ref.data.Lajeunesse),names(rayyan.example))

# rename columns in screening.ref.data so that they are as expected by rayyan
names(rayyan.example)
names(screening.ref.data.Lajeunesse)

screening.ref.data.Lajeunesse.rayyan <- rename(screening.ref.data.Lajeunesse, c("label"="key", "author"="authors", "doi"="url"))
names(screening.ref.data.Lajeunesse.rayyan)

# reorder
screening.ref.data.Lajeunesse.rayyan <- screening.ref.data.Lajeunesse.rayyan[,names(rayyan.example)]





# finding authors with missing initial(s) as that causes an error when importing into rayyan
table(grepl(",  ",screening.ref.data.Lajeunesse.rayyan$authors,fixed=T))

for(i in 1:nrow(screening.ref.data.Lajeunesse.rayyan)){
  
  if(grepl(",  ",screening.ref.data.Lajeunesse.rayyan$authors[i],fixed=T)){
    
    print(i)
  }
  
}


write.csv(screening.ref.data.Lajeunesse.rayyan,"output_cleaning_reference_list/Lajeunesse_deduplicated_rayyan.csv",row.names=FALSE)
#write.csv(screening.ref.data.rayyan,"output_cleaning_reference_list/testing.csv",row.names=FALSE)
#remember to manually remove the quotes for the column names only in the .csv file