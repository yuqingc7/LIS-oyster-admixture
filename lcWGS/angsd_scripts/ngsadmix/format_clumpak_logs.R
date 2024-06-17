setwd("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix")

library(tidyverse)

logs <- as.data.frame(read.table("logs_ngsadmix_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_K3_7_10x.out.10595"))

logs$K <- c(rep(3:7, 10))

logs <- logs %>% arrange(K)

write.table(logs[, c(2, 1)], "logs_formatted_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_K3_7_10x.out.10595", row.names = F, 
            col.names = F, quote = F)
