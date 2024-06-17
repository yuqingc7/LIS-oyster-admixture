library(tidyverse)
library(data.table)

setwd("/workdir/yc2644/CV_NYC_lcWGS/proc_scripts/10_summary")

BAMLIST <- "bam_dedup_overlapclipped_realigned.list"
basedir <- "/workdir/yc2644/CV_NYC_lcWGS"
bam_list <- read_lines(paste0(basedir, "/sample_lists/", BAMLIST))
bam_list_prefix <- str_extract(BAMLIST, "[^.]+")

for (i in 1:length(bam_list)){ # nolint

  bamfile = paste0(bam_list[i],'.depth.gz')
  bamhead = paste(strsplit(bamfile,"_")[[1]][1:2], collapse='_')

  # Compute depth stats
  depth <- read_tsv(paste0(basedir, '/bam/', bamfile), col_names = F)$X1
  mean_depth <- mean(depth)
  sd_depth <- sd(depth)
  mean_depth_nonzero <- mean(depth[depth > 0])
  mean_depth_within2sd <- mean(depth[depth < mean_depth + 2 * sd_depth])
  median <- median(depth)
  presence <- as.logical(depth)
  proportion_of_reference_covered <- mean(presence)

  # Bind stats into dataframe and store sample-specific per base depth and presence data
  if (i==1){
    output <- data.frame(bamhead, mean_depth, sd_depth, mean_depth_nonzero, mean_depth_within2sd, median, proportion_of_reference_covered)
    total_depth <- depth
    total_presence <- presence
  } else {
    output <- rbind(output, cbind(bamhead, mean_depth, sd_depth, mean_depth_nonzero, mean_depth_within2sd, median, proportion_of_reference_covered))
    total_depth <- total_depth + depth
    total_presence <- total_presence + presence
  }
}
print(output)

output %>%
  mutate(across(where(is.numeric), round, 3))

write_tsv(output, paste0(bam_list_prefix, "_depth_per_position_per_sample_summary.tsv"))
#write_lines(total_depth, paste0(bam_list_prefix, "_depth_per_position_all_samples.txt"))
#write_lines(total_presence, paste0(bam_list_prefix, "_presence_per_position_all_samples.txt"))
