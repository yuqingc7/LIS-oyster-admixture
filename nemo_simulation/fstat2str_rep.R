setwd("/local/workdir/yc2644/CV_NYC_nemo_sim")

#library(devtools)
#install_github("jgx65/hierfstat")
library("hierfstat")

library(tidyverse)

# s=40
# pre_ad_gen=10440

# s=1000
# pre_ad_gen=11400

s=3270
pre_ad_gen=13670

# s=280
# pre_ad_gen=10680

letters = c("W1", "AQ", "W2")
numbers = 1:30
pops = rep(letters, each = 30)
inds = paste0(pops, "-", rep(numbers, times = 3))
# 
# # also make indfile
# indfile = tibble(inds, pops)
# write_tsv(indfile, 
#           file = paste0("structure/indfile_n90.txt"),
#           col_names = F)
# # 90 lines

#for (admix in c("single0.1","single0.2","single0.5","single0.8")){
for (admix in c("cons0.001", "cons0.002", "cons0.005", "cons0.01", "cons0.02", "cons0.05")){
#for (admix in c("single1")){
  for (rep in 1:10) {
    prefix = paste0("2pop_ntrl_eq10400_s", s,"_", admix, "_rep", sprintf("%02d", rep))
  
    #for (x in c(0,1,2,3,5,10,15,20)) {
    for (x in c(0,1,5,10,15,20,30)) {
      #ad_gen = pre_ad_gen+x
      ad_gen = pre_ad_gen+x+1
      df <- hierfstat::read.fstat(paste0("nemo_simulations/2pop_ntrl_eq10400_s", s ,"_", admix, "_rep/ntrl/", 
                              prefix, "_", ad_gen, ".n90.dat"),na.s = c("0","00","000","0000","00000","000000","NA"))
  
      write.struct(df,ilab=inds,pop=rep(1:3, each = 30),
                MARKERNAMES=T,MISSING=-9,
                fname=paste0("structure/", prefix, "_", ad_gen, "/threader_input/", prefix, "_", ad_gen, ".n90.str"))
      # 1+80x2 = 181 lines
    }
  }
}
