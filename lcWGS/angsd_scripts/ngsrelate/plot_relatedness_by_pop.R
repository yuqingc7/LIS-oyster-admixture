setwd("/workdir/yc2644/CV_NYC_lcWGS/results_ngsrelate")

library(tidyverse)
library(ggplot2)
library(ggpubr)

pops = list("FI", "SV", "HHmerged", "CT5785", "CT5786")
df_low_cov = data.frame()
for (pop in pops) {
  df_pop <- read_tsv(file=paste0(pop, ".res")) %>% 
    select("ida", "idb", "rab") %>% 
    mutate(population=pop)
  df_low_cov <- rbind(df_low_cov, df_pop)
}

df_low_cov %>% 
  ggplot(mapping = aes(x=population, y=rab)) +
  geom_boxplot() +
  labs(x = "Population", y = "Relatedness") +
  theme_pubr()

# make a heatmap
df_low_cov %>% 
  filter(population == "CT5786") %>% 
  ggplot(mapping = aes(x = ida, y = idb ,fill = rab)) +
  geom_tile() +
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5))

df_low_cov %>% 
  filter(population == "FI") %>% 
  ggplot(mapping = aes(x = ida, y = idb ,fill = rab)) +
  geom_tile() +
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5))

df_low_cov %>% 
  filter(population == "CT5786") %>% 
  filter(rab>0.2) %>% 
  print(n=25)

df_low_cov %>% 
  filter(population == "FI") %>% 
  filter(rab>0.2) %>% 
  print(n=25)

df_low_cov %>% 
  filter(population == "CT5786") %>% 
  filter(rab>0.1) %>% 
  print(n=50)

df_low_cov %>% 
  filter(population == "FI") %>% 
  filter(rab>0.1) %>% 
  print(n=50)


# --- high coverage populations --- #

pops = list("NEHds", "UMFSds")
df_high_cov = data.frame()
for (pop in pops) {
  df_pop <- read_tsv(file=paste0(pop, ".res")) %>% 
    select("ida", "idb", "rab") %>% 
    mutate(population=pop)
  df_high_cov <- rbind(df_high_cov, df_pop)
}

df_high_cov %>% 
  ggplot(mapping = aes(x=population, y=rab)) +
  geom_boxplot() +
  labs(x = "Population", y = "Relatedness") +
  theme_pubr()

# make a heatmap
df_high_cov %>% 
  filter(population == "DEBYds") %>% 
  filter(rab>0.2) %>% 
  print(n=25)

df_high_cov %>% 
  filter(population == "NEHds") %>% 
  filter(rab>0.05) %>% 
  print(n=25)

df_high_cov %>% 
  filter(population == "UMFSds") %>% 
  filter(rab>0.05) %>% 
  print(n=25)
