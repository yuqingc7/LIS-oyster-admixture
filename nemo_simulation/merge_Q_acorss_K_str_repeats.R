# install dependencies
#install.packages(c("ggplot2","gridExtra","label.switching","tidyr","remotes"),repos="https://cloud.r-project.org")

# install pophelper package from GitHub
#remotes::install_github('royfrancis/pophelper')

# load library for use
library(pophelper)
library(tidyverse)

# check version
#packageDescription("pophelper", fields="Version")

# s=1000 # 1000 or 40
# pre_ad_gen=11400 #11400 or 10440
#ad_gen = pre_ad_gen+5
#admix = "single0.2"

# s=3270 # 1000 or 40
# pre_ad_gen=13670 #11400 or 10440
s=280 # 1000 or 40
pre_ad_gen=10680 #11400 or 10440

#for (admix in c("single0.1","single0.2","single0.5","single0.8","single1")){
for (admix in c("cons0.001", "cons0.002", "cons0.005", "cons0.01", "cons0.02", "cons0.05")){
  #for (tdiff in c(0,1,2,3,5,10,15,20)){
  for (tdiff in c(0,1,5,10,20,30)){
    #ad_gen = pre_ad_gen+tdiff
    ad_gen = pre_ad_gen+tdiff+1
    for (rep in 1:10) {
      
      prefix = paste0("2pop_ntrl_eq10400_s", s,"_", admix, "_rep", sprintf("%02d", rep), "_", ad_gen)
    
      setwd(paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/structure/", prefix))
    
      # STRUCTURE files
      sfiles <- list.files(path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/structure/", prefix), 
                         pattern = "^str_K2.*_f$")
    
      slist <- readQ(sfiles, indlabfromfile = TRUE)
    
      # check class of output
      #class(slist)
      # view head of first converted file
      #head(slist[[1]])
    
      #attributes(slist)
      #names(attributes(slist[[1]]))
      #attributes(slist[[1]])
    
      # alignK
      slist <- alignK(slist[])
    
      # get number of runs
      #length(slist)
      # get names of runs
      #names(slist)
      # get number of clusters in each run
      #sapply(slist,ncol)
      # get number of individuals in each run
      #sapply(slist,nrow)
    
      # mergeQ
      # Make sure clusters are aligned between replicate runs before merging them.
      merged_Q <- mergeQ(slist)
      #length(merged_Q)
      
      write_tsv(merged_Q[[1]] %>% rownames_to_column(), 
                paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/structure_rep_sum/", prefix, "_merged_Q.txt"), 
                col_names = F)
      # first 30 
    }
  }
}
