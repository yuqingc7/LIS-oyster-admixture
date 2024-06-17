# This script calculates mean depths of low coverage samples
# for the downsampling ratio of high coverage data

library(tidyverse)

setwd("/workdir/yc2644/CV_NYC_lcWGS/proc_scripts/11_downsample")

filedir <- "/workdir/yc2644/CV_NYC_lcWGS/proc_scripts/10_summary/"

low_cov_pop <- list("CT_Cv5785", "CT_Cv5786", "FI1012_bam", "FISV0212_bam", 
                    "HH1013a_merged_bam", "SV0512a_bam")

low_depth <- c()
for (i in 1:6) {
  pop <- low_cov_pop[i] 
  depth_sum <- read_tsv(paste0(filedir, pop, '_dedup_overlapclipped_realigned_depth_per_position_per_sample_summary.tsv'))
  low_depth <- c(low_depth, mean(as.numeric(depth_sum$mean_depth)))
}

mean(low_depth)
# 1.337678