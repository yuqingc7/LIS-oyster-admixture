setwd("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum")

library(tidyverse)
library(ggplot2)
library(gridExtra)
library(grid)
#devtools::install_github('smin95/smplot2')
library(smplot2) #https://smin95.github.io/dataviz/raincloud-and-forest-plots.html

# empirical admixed ---------------------------------------------------------------
str_ddRAD_all <- read_csv("/local/workdir/yc2644/CV_NYC_ddRAD/structure/n380_structure.csv") %>% 
  dplyr::select(Group,P2) %>% 
  mutate(location = c(rep("Aquaculture",27), 
                      rep("Hudson River",189), 
                      rep("ddRAD\nEast River",164))) %>% dplyr::rename(p=Group,AQ=P2)
#check <- subset(str_ddRAD_all, location == "Hudson River"&p != "PRA1013a")
zero_ddRAD <- mean(subset(str_ddRAD_all, location == "Hudson River"&p != "PRA1013a")$AQ)

str_ddRAD <- str_ddRAD_all %>% 
  filter(location=="ddRAD\nEast River")

pop <- read.table( "/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)
q <- read.table("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K5_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
str_lcWGS_all <- cbind(pop, q) %>% 
  mutate(AQ = 1-V5) %>% filter(p=="SV0512a"|p=="CT5785"|p=="HH13a") %>%
  mutate(location = case_when(
    p == "SV0512a" ~ "lcWGS\nEast River",
    p == "CT5785" ~ "lcWGS\nLIS",
    p == "HH13a" ~ "Hudson River",
    TRUE ~ p
  )) %>% dplyr::select(p,AQ,location) %>% mutate(across(all_of("location"), as_factor))
  
zero_lcWGS <- mean(subset(str_lcWGS_all, location == "Hudson River")$AQ)

str_lcWGS <- str_lcWGS_all %>% 
  filter(location=="lcWGS\nEast River"|location=="lcWGS\nLIS")

str_real_nozero <- rbind(subset(str_ddRAD, AQ>zero_ddRAD),subset(str_lcWGS, AQ>zero_lcWGS))

# ggplot(subset(str_real,AQ>0),
#        mapping = aes(x = location, y = AQ)) +
#   geom_violin(fill='grey',color="transparent",
#               scale="count" #scale maximum width proportional to sample size
#   ) +
#   geom_point(size=2,shape=1,position = position_jitter(width = 0.2),alpha=0.3,color="navyblue")+
#   geom_point(stat = "summary", fun = "mean", size = 1.5, color = "red",na.rm = F) +
#   # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
#   #   size = 1,color = "red") +
#   xlab(label = NULL) +
#   ylab(label = "") +
#   labs(title = "Aquaculture source admixture proportions for admixed individuals") +
#   theme_minimal() +
#   theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
#         axis.title = element_text(size = 16),
#         strip.text = element_text(size=16),
#         plot.title = element_text(size = 16))+
#   coord_cartesian(ylim = c(0, 1))

p1 <- ggplot(str_real_nozero,
       mapping = aes(x = location, y = AQ,fill=location)) +
  sm_raincloud(sep_level = 2,
               boxplot.params = list(outlier.shape = NA,color=NA,fill=NA),
               #err.params = list(size = 1.2),
               violin.params = list(scale="width",color="black",alpha=0.2), 
               #errorbar_type = "sd",
               point_jitter_width = 0.3,
               point.params = list(shape = 1, color = "lightslateblue",
                                   size = 1.5, alpha=0.45))+
  scale_fill_manual(values=rep("lightslateblue",8))+
  geom_point(stat = "summary", fun = "mean", size = 2, color = "red",na.rm = F) +
  ylab(label = "Aquaculture-source admixture levels\nfor admixed individuals") +
  xlab(label = NULL) +
  labs(title = "Empirical Data from ddRAD and lcWGS") +
  theme_minimal() +
  theme(axis.text.x = element_text(size=12,hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  coord_cartesian(ylim = c(0, 1))
p1

# empirical non-admixed proportion ----------------------------------------

str_ddRAD_non <- str_ddRAD %>% 
  group_by(p,) %>% 
  dplyr::summarise(num_zeros = sum(AQ <= zero_ddRAD)) %>% 
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/(nrow(str_ddRAD))) %>% 
  dplyr::select(p,freq_unadmixed) %>% 
  mutate(location="ddRAD\nEast River")
1-mean(str_ddRAD_non$freq_unadmixed)

str_lcWGS_non <- str_lcWGS %>% 
  group_by(p,location) %>% 
  dplyr::summarise(num_zeros = sum(AQ <= zero_lcWGS),
                   n = n()) %>%  
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/n) %>% 
  dplyr::select(p,freq_unadmixed,location)
1-mean(str_lcWGS_non$freq_unadmixed)

empirical_non <- rbind(str_ddRAD_non,str_lcWGS_non)

ggplot(empirical_non, 
       mapping=aes(x=location, y=1-freq_unadmixed),color="lightslateblue")+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  xlab(label = "") +
  labs(title = "Proportions of admixed individuals",
       y=NULL) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 16),
        strip.text = element_text(size=16),
        plot.title = element_text(size = 16))+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))

empirical_non %>% 
  group_by(location) %>% 
  dplyr::summarise(mean = mean(freq_unadmixed))
# location              mean
# <chr>                <dbl>
#   1 "ddRAD\nEast River" 0.0305
# 2 "lcWGS\nEast River" 0.0417 #1-0.958
# 3 "lcWGS\nLIS"        0.0333

# cons high admixed box plots -------------------------------------------------------

# Create an empty list to store data frames
all_tot_Q <- list()

directory_path <- "/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/"
file_pattern <- "^2pop_ntrl_eq10400_s3270_cons_(g6|g11|g21|g31)_total_rep10_tidy_Q\\.tsv$"
matching_files <- list.files(path = directory_path, pattern = file_pattern, full.names = TRUE)
print(matching_files) #1scen*4gen

# Function to read and combine TSV files
read_and_combine_tsv <- function(file_path) {
  read_tsv(file_path)
}

# Use purrr::map_dfr to read and combine the TSV files into one data frame
combined_cons_tot_Q <- map_dfr(matching_files, read_and_combine_tsv) %>% 
  mutate(gen_to_admix=gen_to_admix-1) %>% 
  mutate(gen_to_admix = as.factor(gen_to_admix))
# Print or work with the combined data
print(combined_cons_tot_Q) #21600=1scen*4gen*10rep*6rate*90ind

immigration_rate_list <- c(`cons0.001`="m=0.0001",`cons0.002`="m=0.0002",
                           `cons0.005`="m=0.0005",`cons0.01`="m=0.001",
                           `cons0.02`="m=0.002",`cons0.05`="m=0.005")

zero <- mean(subset(combined_cons_tot_Q,pop == "W2")$AQ_assignment_rate)

# ggplot(subset(combined_cons_tot_Q,pop=="W1"&AQ_assignment_rate>zero),
#        mapping = aes(x = gen_to_admix, y = AQ_assignment_rate)) +
#   geom_violin(fill='grey',color="transparent",
#               scale="count" #scale maximum width proportional to sample size
#   ) +
#   geom_point(size=2,shape=1,position = position_jitter(width = 0.2),alpha=0.3,color="navyblue")+
#   geom_point(stat = "summary", fun = "mean", size = 1.5, color = "red",na.rm = F) +
#   geom_line(stat = "summary", fun = "mean", aes(group = 1), 
#             color = "red", size = 0.5, na.rm = F,linetype = "dashed")+
#   # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
#   #   size = 1,color = "red") +
#   xlab(label = "Generations since first admixture event") +
#   ylab(label = "") +
#   labs(title = "Consistent Annual Admixture Simulation (Fst=0.077)\nAquaculture source admixture proportions for admixed individuals") +
#   theme_minimal() +
#   theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
#         axis.title = element_text(size = 16),
#         strip.text = element_text(size=16),
#         plot.title = element_text(size = 16))+
#   facet_wrap(~admix_scenario, nrow=2,
#              #scales = "free_y",
#              labeller = as_labeller(immigration_rate_list)
#              )
fst=0.360
ggplot(subset(combined_cons_tot_Q,pop=="W1"&AQ_assignment_rate>zero&admix_scenario%in%c("cons0.002","cons0.02","cons0.05")),
       mapping = aes(x = gen_to_admix, 
                     y = AQ_assignment_rate,
                     fill=as.factor(gen_to_admix))) +
  sm_raincloud(sep_level = 2,
               boxplot.params = list(outlier.shape = NA,color=NA,fill=NA),
               #err.params = list(size = 1.2),
               violin.params = list(scale="width",color="black",alpha=0.2), 
               #errorbar_type = "sd",
               point_jitter_width = 0.3,
               point.params = list(shape = 1, color = "lightslateblue",
                                   size = 1.5, alpha=0.45))+
  scale_fill_manual(values=rep("lightslateblue",8))+
  geom_point(stat = "summary", fun = "mean", size = 2, color = "red",na.rm = F) +
  geom_line(stat = "summary", fun = "mean", aes(group = 1), 
            color = "red", size = 0.8, na.rm = F,linetype = "dashed")+
  # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
  #   size = 1,color = "red") +
  xlab(label = "Generation(s) since the first migration event") +
  ylab(label = "Aquaculture-source admixture levels\nfor admixed individuals") +
  labs(title = paste0("Consistent Annual Admixture Simulation\nInitial Mean Fst=",fst)) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))


# cons high non-admixed ---------------------------------------------------

combined_cons_non <- subset(combined_cons_tot_Q,pop=="W1"&admix_scenario%in%c("cons0.002","cons0.02","cons0.05")) %>% 
  group_by(gen_to_admix,admix_scenario,simulation_replicate) %>% 
  dplyr::summarise(num_zeros = sum(AQ_assignment_rate<=zero)) %>% 
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/30) %>% 
  dplyr::select(gen_to_admix,admix_scenario,simulation_replicate,freq_unadmixed)
  
ggplot(combined_cons_non, 
       mapping=aes(x=gen_to_admix, y=1-freq_unadmixed),color="lightslateblue")+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.1,size = 1)+
  xlab(label = "Generation(s) since the first migration event") +
  labs(y = "Proportions of admixed individuals\nin native population") +
  labs(title = paste0("Consistent Annual Admixture Simulation\nInitial Mean Fst=",fst)) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 16),
        strip.text = element_text(size=16),
        plot.title = element_text(size = 16))+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))


# cons low admixed box plots -------------------------------------------------------

# Create an empty list to store data frames
all_tot_Q <- list()

directory_path <- "/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/"
file_pattern <- "^2pop_ntrl_eq10400_s280_cons_(g6|g11|g21|g31)_total_rep10_tidy_Q\\.tsv$"
matching_files <- list.files(path = directory_path, pattern = file_pattern, full.names = TRUE)
print(matching_files) #1scen*4gen

# Function to read and combine TSV files
read_and_combine_tsv <- function(file_path) {
  read_tsv(file_path)
}

# Use purrr::map_dfr to read and combine the TSV files into one data frame
combined_cons_tot_Q <- map_dfr(matching_files, read_and_combine_tsv) %>% 
  mutate(gen_to_admix=gen_to_admix-1) %>% 
  mutate(gen_to_admix = as.factor(gen_to_admix))
# Print or work with the combined data
print(combined_cons_tot_Q) #21600=1scen*4gen*10rep*6rate*90ind

immigration_rate_list <- c(`cons0.001`="m=0.0001",`cons0.002`="m=0.0002",
                           `cons0.005`="m=0.0005",`cons0.01`="m=0.001",
                           `cons0.02`="m=0.002",`cons0.05`="m=0.005")

zero <- mean(subset(combined_cons_tot_Q,pop == "W2")$AQ_assignment_rate)

fst=0.070
p2 <- ggplot(subset(combined_cons_tot_Q,pop=="W1"&AQ_assignment_rate>zero&admix_scenario%in%c("cons0.002","cons0.02","cons0.05")),
       mapping = aes(x = gen_to_admix, 
                     y = AQ_assignment_rate,
                     fill=as.factor(gen_to_admix))) +
    sm_raincloud(sep_level = 2,
               boxplot.params = list(outlier.shape = NA,color=NA,fill=NA),
               #err.params = list(size = 1.2),
               violin.params = list(scale="width",color="black",alpha=0.2), 
               #errorbar_type = "sd",
               point_jitter_width = 0.3,
               point.params = list(shape = 1, color = "lightslateblue",
                                   size = 1.5, alpha=0.45))+
  scale_fill_manual(values=rep("lightslateblue",8))+
  geom_point(stat = "summary", fun = "mean", size = 2, color = "red",na.rm = F) +
  geom_line(stat = "summary", fun = "mean", aes(group = 1), 
            color = "red", size = 0.8, na.rm = F,linetype = "dashed")+
  # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
  #   size = 1,color = "red") +
  xlab(label = "Generation(s) since the first migration event") +
  #ylab(label = "Aquaculture-source admixture levels\nfor admixed individuals") +
  ylab(label = NULL) +
  labs(title = paste0("Consistent Annual Admixture Simulation (Initial Mean Fst=",fst,")")) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))
p2

# cons low non-admixed ---------------------------------------------------

combined_cons_non <- subset(combined_cons_tot_Q,pop=="W1"&admix_scenario%in%c("cons0.002","cons0.02","cons0.05")) %>% 
  group_by(gen_to_admix,admix_scenario,simulation_replicate) %>% 
  dplyr::summarise(num_zeros = sum(AQ_assignment_rate<=zero)) %>% 
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/30) %>% 
  dplyr::select(gen_to_admix,admix_scenario,simulation_replicate,freq_unadmixed)

ggplot(combined_cons_non, 
       mapping=aes(x=gen_to_admix, y=1-freq_unadmixed),color="lightslateblue")+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.1,size = 1)+
  xlab(label = "Generation(s) since the first migration event") +
  labs(y = "Proportions of admixed individuals\nin native population") +
  labs(title = paste0("Consistent Annual Admixture Simulation\nInitial Mean Fst=",fst)) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 16),
        strip.text = element_text(size=16),
        plot.title = element_text(size = 16))+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))


# single high - admixed box plots -------------------------------------------------------

# Create an empty list to store data frames
all_tot_Q <- list()

directory_path <- "/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/"
#file_pattern <- "^2pop_ntrl_eq10400_s1000_single_(g1|g2|g3|g5|g10|g15|g20|g30)_total_rep10_tidy_Q\\.tsv$"
file_pattern <- "^2pop_ntrl_eq10400_s3270_single_(g1|g2|g3|g4|g6|g11|g16|g21)_total_rep10_tidy_Q\\.tsv$"
#file_pattern <- "^2pop_ntrl_eq10400_s280_single_(g1|g2|g3|g4|g6|g11|g16|g21)_total_rep10_tidy_Q\\.tsv$"
fst=0.360 #0.070 or 0.360

matching_files <- list.files(path = directory_path, pattern = file_pattern, full.names = TRUE)
print(matching_files) #1scen*8gen

# Function to read and combine TSV files
read_and_combine_tsv <- function(file_path) {
  read_tsv(file_path)
}

# Use purrr::map_dfr to read and combine the TSV files into one data frame
combined_cons_tot_Q <- map_dfr(matching_files, read_and_combine_tsv) %>% 
  mutate(gen_to_admix=gen_to_admix-1) %>% 
  mutate(gen_to_admix = as.factor(gen_to_admix))
# Print or work with the combined data
print(combined_cons_tot_Q) #21600=1scen*4gen*10rep*6rate*90ind

immigration_rate_list <- c(`single0.1`="m=0.01",`single0.2`="m=0.02",`single0.5`="m=0.05",
                           `single0.8`="m=0.08",`single1`="m=0.1")

zero <- mean(subset(combined_cons_tot_Q,pop == "W2")$AQ_assignment_rate)

p3 <- ggplot(subset(combined_cons_tot_Q,pop=="W1"&AQ_assignment_rate>zero&admix_scenario%in%c("single0.1","single0.5","single1")),
       mapping = aes(x = gen_to_admix, 
                     y = AQ_assignment_rate,
                     fill=as.factor(gen_to_admix))) +
  sm_raincloud(sep_level = 2,
               boxplot.params = list(outlier.shape = NA,color=NA,fill=NA),
               #err.params = list(size = 1.2),
               violin.params = list(scale="width",color="black",alpha=0.2), 
               #errorbar_type = "sd",
               point_jitter_width = 0.3,
               point.params = list(shape = 1, color = "lightslateblue",
                                   size = 1.5, alpha=0.45))+
  scale_fill_manual(values=rep("lightslateblue",8))+
  geom_point(stat = "summary", fun = "mean", size = 2, color = "red",na.rm = F) +
  geom_line(stat = "summary", fun = "mean", aes(group = 1), 
            color = "red", size = 0.8, na.rm = F,linetype = "dashed")+
  # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
  #   size = 1,color = "red") +
  xlab(label = "Generation(s) since the first migration event") +
  ylab(label = "Aquaculture-source admixture levels\nfor admixed individuals") +
  labs(title = paste0("Single Pulse Admixture Simulation (Initial Mean Fst=",fst,")")) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        axis.text.x = element_text(size=12,hjust = 0.5, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list)
  )
p3

# single high non-admixed ---------------------------------------------------

combined_cons_non <- subset(combined_cons_tot_Q,pop=="W1"&admix_scenario%in%c("single0.1","single0.5","single1")) %>% 
  group_by(gen_to_admix,admix_scenario,simulation_replicate) %>% 
  dplyr::summarise(num_zeros = sum(AQ_assignment_rate<=zero)) %>% 
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/30) %>% 
  dplyr::select(gen_to_admix,admix_scenario,simulation_replicate,freq_unadmixed)

ggplot(combined_cons_non, 
       mapping=aes(x=gen_to_admix, y=1-freq_unadmixed),color="lightslateblue")+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.1,size = 1)+
  xlab(label = "Generation(s) since the first migration event") +
  labs(y = "Proportions of admixed individuals\nin native population") +
  labs(title = paste0("Single Pulse Admixture Simulation (Initial Mean Fst=",fst,")")) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 16),
        strip.text = element_text(size=16),
        plot.title = element_text(size = 16))+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))



# single low - admixed box plots -------------------------------------------------------

file_pattern <- "^2pop_ntrl_eq10400_s280_single_(g1|g2|g3|g4|g6|g11|g16|g21)_total_rep10_tidy_Q\\.tsv$"
fst=0.070 #0.070 or 0.360

matching_files <- list.files(path = directory_path, pattern = file_pattern, full.names = TRUE)
print(matching_files) #1scen*8gen

# Function to read and combine TSV files
read_and_combine_tsv <- function(file_path) {
  read_tsv(file_path)
}

# Use purrr::map_dfr to read and combine the TSV files into one data frame
combined_cons_tot_Q <- map_dfr(matching_files, read_and_combine_tsv) %>% 
  mutate(gen_to_admix=gen_to_admix-1) %>% 
  mutate(gen_to_admix = as.factor(gen_to_admix))
# Print or work with the combined data
print(combined_cons_tot_Q) #21600=1scen*4gen*10rep*6rate*90ind

immigration_rate_list <- c(`single0.1`="m=0.01",`single0.2`="m=0.02",`single0.5`="m=0.05",
                           `single0.8`="m=0.08",`single1`="m=0.1")

zero <- mean(subset(combined_cons_tot_Q,pop == "W2")$AQ_assignment_rate)

p4 <- ggplot(subset(combined_cons_tot_Q,pop=="W1"&AQ_assignment_rate>zero&admix_scenario%in%c("single0.1","single0.5","single1")),
             mapping = aes(x = gen_to_admix, 
                           y = AQ_assignment_rate,
                           fill=as.factor(gen_to_admix))) +
  sm_raincloud(sep_level = 2,
               boxplot.params = list(outlier.shape = NA,color=NA,fill=NA),
               #err.params = list(size = 1.2),
               violin.params = list(scale="width",color="black",alpha=0.2), 
               #errorbar_type = "sd",
               point_jitter_width = 0.3,
               point.params = list(shape = 1, color = "lightslateblue",
                                   size = 1.5, alpha=0.45))+
  scale_fill_manual(values=rep("lightslateblue",8))+
  geom_point(stat = "summary", fun = "mean", size = 2, color = "red",na.rm = F) +
  geom_line(stat = "summary", fun = "mean", aes(group = 1), 
            color = "red", size = 0.8, na.rm = F,linetype = "dashed")+
  # geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.2,
  #   size = 1,color = "red") +
  xlab(label = "Generation(s) since the first migration event") +
  ylab(label = "Aquaculture-source admixture levels\nfor admixed individuals") +
  labs(title = paste0("Single Pulse Admixture Simulation (Initial Mean Fst=",fst,")")) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list)
  )

# single low non-admixed ---------------------------------------------------

combined_cons_non <- subset(combined_cons_tot_Q,pop=="W1"&admix_scenario%in%c("single0.1","single0.5","single1")) %>% 
  group_by(gen_to_admix,admix_scenario,simulation_replicate) %>% 
  dplyr::summarise(num_zeros = sum(AQ_assignment_rate<=zero)) %>% 
  ungroup() %>% 
  mutate(freq_unadmixed = num_zeros/30) %>% 
  dplyr::select(gen_to_admix,admix_scenario,simulation_replicate,freq_unadmixed)

ggplot(combined_cons_non, 
       mapping=aes(x=gen_to_admix, y=1-freq_unadmixed),color="lightslateblue")+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.1,size = 1)+
  xlab(label = "Generation(s) since the first migration event") +
  labs(y = "Proportions of admixed individuals\nin native population") +
  labs(title = paste0("Single Pulse Admixture Simulation (Initial Mean Fst=",fst,")")) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 16),
        strip.text = element_text(size=16),
        plot.title = element_text(size = 16))+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))+
  facet_wrap(~admix_scenario, nrow=1,
             #scales = "free_y",
             labeller = as_labeller(immigration_rate_list))

library(patchwork)

layout <-" 
AABBBB
CCCCCC
DDDDDD
"

#p1+p2+p4+p3+ plot_layout(design=layout, axis_titles = "collect")#,axes = "collect")

layout1 <-" 
AABBBB
"
p5 <- p1+p2+ plot_layout(design=layout1,axes = "collect")
layout2 <-" 
AAAAAA
BBBBBB
"
p6 <- p4+p3+ plot_layout(design=layout2,axes = "collect")
layout3 <-" 
AAAAAA
BBBBBB
BBBBBB
"
p5/p6+ plot_layout(design=layout3)




# proportion non-admixed - cons --------------------------------------------------

# Create an empty list to store data frames
sum_by_rep_Q <- list()

directory_path <- "/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/"
file_pattern <- "^2pop_ntrl_eq10400_s1000_cons_(g5|g10|g20|g30)_total_rep10_sum_by_rep_pop_Q\\.tsv$"
#fst=0.077 or 0.349
matching_files <- list.files(path = directory_path, pattern = file_pattern, full.names = TRUE)
print(matching_files) #1scen*4gen

# Function to read and combine TSV files
read_and_combine_tsv <- function(file_path) {
  read_tsv(file_path)
}

# Use purrr::map_dfr to read and combine the TSV files into one data frame
combined_cons_sum_by_rep_Q <- map_dfr(matching_files, read_and_combine_tsv) %>% 
  mutate(gen_to_admix = as.factor(gen_to_admix))
# Print or work with the combined data
print(combined_cons_sum_by_rep_Q) #720=1scen*4gen*10rep*6rate*3pop

library(rcartocolor)

nColor <- 6
scales::show_col(carto_pal(nColor, "Safe"))

ggplot(subset(combined_cons_sum_by_rep_Q, pop=="W1"), 
       mapping=aes(x=gen_to_admix, y=freq_unadmixed,color=admix_scenario))+
  scale_color_manual(values=carto_pal(nColor, "Safe"),
                     labels=c("m=0.0001","m=0.0002","m=0.0005",
                              "m=0.001","m=0.002","m=0.005"))+
  geom_point(stat = "summary", fun = "mean", size = 2, na.rm = F) +
  geom_line(stat = "summary", fun = "mean", aes(group = admix_scenario), 
            size = 1, na.rm = F,linetype = "dashed")+
  geom_errorbar(stat = "summary",fun.data = "mean_cl_boot",width = 0.1,size = 1)+
  xlab(label = "Generations since first admixture event") +
  labs(title = "Consistent Annual Admixture Simulation (Fst=0.349)\nProportions of individuals remain non-admixed",
       y=NULL) +
  theme_minimal() +
  theme(axis.text = element_text(size=14,hjust = 0.5, vjust = 0.5),
        axis.title = element_text(size = 14),
        strip.text = element_text(size=14),
        plot.title = element_text(size = 14),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  theme(legend.title = element_blank(),
        legend.position = c(0.15, 0.25),
        legend.background = element_rect(fill = "white", color = "black", size = 0.5))+
  coord_cartesian(ylim = c(0, 1))

