setwd("/local/workdir/yc2644/CV_NYC_ddRAD/relatedness")

library(tidyverse)
library(ggplot2)
library(ggpubr)
library(hrbrthemes)
library(viridis)
library(forcats)

# KING-robust between-family kinship estimate
kingships <- read_tsv("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.kin0") %>% 
  separate("#IID1", c("Pop1", "ID1")) %>% 
  separate("IID2", c("Pop2", "ID2")) %>% 
  select("Pop1", "ID1", "Pop2", "ID2", "KINSHIP") 

kingships %>% 
  filter(KINSHIP>0.177)


kingships_pop <- read_tsv("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.kin0") %>% 
  separate("#IID1", c("Pop1", "ID1")) %>% 
  separate("IID2", c("Pop2", "ID2")) %>% 
  select("Pop1", "ID1", "Pop2", "ID2", "KINSHIP") %>% 
  filter(Pop1==Pop2) %>% 
  select("Pop1", "ID1", "ID2", "KINSHIP") %>% 
  rename(Pop=Pop1)

kingships_pop %>% 
  mutate(Pop = fct_reorder(Pop,KINSHIP)) %>% 
  ggplot( aes(x=KINSHIP, color=Pop, fill=Pop)) +
    geom_histogram(alpha=0.6, binwidth = 0.05) +
    scale_fill_viridis(discrete=TRUE) +
    scale_color_viridis(discrete=TRUE) +
    theme_ipsum() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.1, "lines"),
      strip.text.x = element_text(size = 8)
          ) +
    xlab("") +
    ylab("Pairwise Kinship") +
    facet_wrap(~Pop)

kingships_pop %>% 
  filter(KINSHIP>0.1777)

read_tsv("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.genome")

