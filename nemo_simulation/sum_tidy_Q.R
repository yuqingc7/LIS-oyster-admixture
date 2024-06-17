setwd("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum")

# run after "tidy_Q_across_nemo_simulation_rep.R"

library(tidyverse)
library(ggplot2)
library(gridExtra)
library(grid)

s=1000 # 1000 or 40
Fst=0.349 # 0.349 or 0.077
gen = 20
total_rep = 10
scenario = "single" # "cons" or "single"

# read in tidy data
file_tot_path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/2pop_ntrl_eq10400_s", s, "_", scenario, "_g", gen, "_total_rep", total_rep, "_tidy_Q.tsv")
tot_Q <- read_tsv(file_tot_path) # rows: 900 x 6 admix_scenario
tot_Q 

file_sum_path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/2pop_ntrl_eq10400_s", s, "_", scenario, "_g", gen, "_total_rep", total_rep, "_sum_by_rep_pop_Q.tsv")
sum_by_rep_Q <- read_tsv(file_sum_path) # rows: 30 x 6 admix_scenario
sum_by_rep_Q


# plot STRUCTURE  -------------------------------------------------
#admix_scenario_list = c("cons0.01","cons0.02","cons0.05","cons0.1","cons0.2","cons0.5")
admix_scenario_list = c("single0.2","single0.5","single0.8")
#immigration_rate_list = c(0.0001,0.0002, 0.0005, 0.001, 0.002, 0.005)
immigration_rate_list = c(0.002, 0.005,0.008)

tot_Q_long <- tot_Q %>% 
  mutate(NA_assignment_rate = 1-AQ_assignment_rate) %>% 
  filter(admix_scenario == admix_scenario_list[[1]]) %>% 
  #filter(simulation_replicate == "rep05") %>%
  arrange(pop, desc(AQ_assignment_rate)) %>% 
  # mutate(Ind = 1:90) %>%
  mutate(Ind = 1:900) %>%
  pivot_longer(cols = c("AQ_assignment_rate", "NA_assignment_rate"), names_to = "Source", values_to = "Q") 

ggplot(tot_Q_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1, show.legend = FALSE) +
  scale_fill_manual(values = c("#FFFF99", "#B15928"),
                    labels = c("Native", "Aquaculture")) +
  # geom_vline(xintercept = c(30.5, 60.5)) +
  # scale_x_continuous(breaks = c(15, 45, 75),
  #                    labels = c("AQ", "W1", "W2"),
  #                    expand = c(0, 0)) +
  geom_vline(xintercept = c(300.5, 600.5)) +
  scale_x_continuous(breaks = c(150, 450, 750),
                     labels = c("AQ", "W1", "W2"),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))+
  #labs(title = paste0("Consistent Annual Admixture Simulation (Fst=",Fst,", Immigration rate=", immigration_rate_list[[1]],")\nAdmixture Proportions for K=2"), 
  labs(title = paste0("Single Pulse Admixture Simulation (Fst=",Fst,", Immigration rate=", immigration_rate_list[[1]],")\nAdmixture Proportions for K=2"), 
  #labs(title = paste0(gen, " generation after a single pulse admixture; Simulated Fst=", Fst), 
       #subtitle = "Admixture Proportions for K=2", 
       y=NULL,x=NULL)

# plot single Q value distribution  -------------------------------------------------

# all runs of simulation together
all_tot_Q_plot <- tot_Q %>% 
  select(pop,simulation_replicate, AQ_assignment_rate, admix_scenario) %>% 
  filter(pop == "W1")

#admix_scenario_list = c("cons0.01","cons0.02","cons0.05","cons0.1","cons0.2","cons0.5")
admix_scenario_list = c("single0.01","single0.02","single0.05","single0.1","single0.2","single0.5")
immigration_rate_list = c(0.0001,0.0002, 0.0005, 0.001, 0.002, 0.005)

all_tot_Q_plot %>% 
    filter(admix_scenario == admix_scenario_list[[5]]) %>% 
    ggplot(aes(x=AQ_assignment_rate, y=after_stat(count/sum(count))))+
    geom_histogram(color = "red", fill="red", binwidth = 0.001)+
    scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.8)) +
    scale_x_continuous(limits = c(-0.001, 1.001)) +
    labs(title = paste0("After ", gen, " Generation of Annual Consistent Aquaculture Admixture; Simulated Fst=", Fst), 
         subtitle = paste0("Immigration rate per generation=", immigration_rate_list[[5]]), 
         x="Aquaculture Assignment Rate Q by STRUCTURE",y="Frequency") + 
    theme_classic()

# plot Q value distribution for all -------------------------------------------------

# all runs of simulation together
all_tot_Q_plot <- tot_Q %>% 
  select(pop,simulation_replicate, AQ_assignment_rate, admix_scenario) %>% 
  filter(pop == "W1")

admix_scenario_list = c("cons0.01","cons0.02","cons0.05","cons0.1","cons0.2","cons0.5")
immigration_rate_list = c(0.0001,0.0002, 0.0005, 0.001, 0.002, 0.005)

plot_list <- list()
for (i in 1:6){
  plot_list[[i]] <- all_tot_Q_plot %>% 
    filter(admix_scenario == admix_scenario_list[[i]]) %>% 
    ggplot(aes(x=AQ_assignment_rate, y=after_stat(count/sum(count))))+
      geom_histogram(color = "red", fill="red", binwidth = 0.001)+
      scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.8)) +
      scale_x_continuous(limits = c(-0.001, 1.001)) +
      labs(title = paste0("Immigration rate per generation=", immigration_rate_list[[i]]), x="",y="") + 
      theme_classic()
}

grid.arrange(grobs=plot_list, nrow=2, 
             top=textGrob(paste0("After ", gen, " Generations of Annual Consistent Aquaculture Admixture; Simulated Fst=", Fst), 
                          gp=gpar(fontsize=15,font=8)),
             bottom="Aquaculture Assignment Rate Q by STRUCTURE", 
             left="Frequency")

# plot summary stats  -------------------------------------------------

# Summarize at population level across individuals
sum_by_rep_Q_by_pop <- sum_by_rep_Q %>% 
  group_by(pop, admix_scenario) %>% 
  summarise(mean_across_rep = mean(mean),
            var_within_pop_averaged_across_rep = mean(var),
            var_across_rep = var(mean),
            mean_freq_unadmixed = mean(freq_unadmixed)) %>% 
  ungroup %>% 
  arrange(admix_scenario) %>% 
  filter(pop == "W1")

# plot
# freq_zeros <- sum_by_rep_Q_by_pop %>% 
#   select(admix_scenario, mean_freq_unadmixed) %>%
#   mutate(admix_scenario = factor(admix_scenario, levels = admix_cases))

admix_cases = c("cons0.01","cons0.02","cons0.05","cons0.1","cons0.2","cons0.5")
sum_by_rep_Q_W1 <- sum_by_rep_Q %>% 
  arrange(admix_scenario) %>% 
  filter(pop == "W1") %>% 
  mutate(admix_scenario = factor(admix_scenario, levels = admix_cases, 
                                 labels = c("0.0001", " 0.0002", " 0.0005",
                                            "0.001", "0.002", "0.005")))

# read in empirical data
str_sum_by_pop_ER <- read_tsv("/local/workdir/yc2644/CV_NYC_nemo_sim/NYC_ddRAD_str_sum_by_pop_ER.tsv", 
          col_names = TRUE)

str_mean_var_by_pop_ER <- str_sum_by_pop_ER %>% 
  mutate(admix_scenario = location, simulation_replicate = Group) %>% 
  select(simulation_replicate, admix_scenario, mean, var, freq_unadmixed)

mean_var_by_rep_Q_W1 <- sum_by_rep_Q_W1 %>% 
  select(simulation_replicate, admix_scenario, mean, var, freq_unadmixed)

mean_var_by_pop <- rbind(str_mean_var_by_pop_ER, mean_var_by_rep_Q_W1) %>% 
  mutate(admix_scenario = factor(admix_scenario,
                                 levels = c("0.0001", " 0.0002", " 0.0005",
                                            "0.001", "0.002", "0.005", "East River")))

plot_list <- list()

plot_list[[1]] <- ggplot(mean_var_by_pop,
       aes(x = admix_scenario, y = mean, group = admix_scenario, fill = admix_scenario)) +
  geom_boxplot(alpha = .7) +
  geom_jitter(width = .05, alpha = .4) +
  coord_cartesian(ylim = c(0, 0.15)) +
  guides(fill = "none") +
  theme_light() +
  scale_fill_manual(values=c(rep("#999999", 6), "red")) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.text = element_text(color="black", size=12)) +
  labs(
    x="",y="",
    #y="Population mean of aquaculture assignment rate",
    #title="Annual Consistent Admixture",
    #subtitle=paste0("10 Runs of Nemo simulation, Fst: ", Fst)
  )

plot_list[[2]] <- ggplot(mean_var_by_pop,
       aes(x = admix_scenario, y = var, group = admix_scenario, fill = admix_scenario)) +
  geom_boxplot(alpha = .7) +
  geom_jitter(width = .05, alpha = .4) +
  coord_cartesian(ylim = c(0, 0.07)) +
  guides(fill = "none") +
  theme_light() +
  scale_fill_manual(values=c(rep("#999999", 6), "red")) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.text = element_text(color="black", size=12)) +
  labs(
    x="",y="",
    #y="Within population variance",
    #title="Annual Consistent Admixture",
    #subtitle=paste0("10 Runs of Nemo simulation, Fst: ", Fst)
  )

plot_list[[3]] <- ggplot(mean_var_by_pop,
       aes(x = admix_scenario, y = freq_unadmixed, group = admix_scenario, fill = admix_scenario)) +
  geom_boxplot(alpha = .7) +
  geom_jitter(width = .05, alpha = .4) +
  coord_cartesian(ylim = c(0, 1)) +
  guides(fill = "none") +
  theme_light() +
  scale_fill_manual(values=c(rep("#999999", 6), "red")) +
  theme(axis.text = element_text(color="black", size=12)) +
  labs(
    x="",y="",
    #y="Proportion of unadmixed individuals",
    #title="Annual Consistent Admixture",
    #subtitle=paste0("10 Runs of Nemo simulation, Fst: ", Fst)
  )

mt = paste0("Annual consistent admixture over ", gen, " generations")
st = paste0("10 Runs of Nemo simulation, Fst: ", Fst)
title = paste(mt, st, sep = "\n")

grid.arrange(grobs=plot_list, nrow=3,
             top=title,
             bottom="Immigration rate per generation")
#6x15inches, portrait

# define the file path for the TSV file
# file_path <- "/local/workdir/yc2644/CV_NYC_nemo_sim/Q_sum_by_pop.tsv"

# # read in the existing data, if it exists
# if (file.exists(file_path)) {
#   existing_data <- read_delim(file_path)
# } else {
#   existing_data <- data.frame()
# }
# 
# # check if the new data already exists in the file
# if (!is_empty(existing_data)) {
#   sum_by_pop <- sum_by_pop %>% 
#     anti_join(existing_data, by = c("scenario", "pop"))
# }
# 
# # append the new data to the existing data and write to file
# write_tsv(rbind(existing_data, sum_by_pop), file = file_path, col_names = T)



# Summarize at individual level across simulation replicates
# result_df
# 
# result_df_summary <- result_df %>%
#   mutate(mean = rowMeans(.[,2:11]),
#          var = apply(.[,2:11], 1, var),
#          n_zeros = rowSums(.[,2:11] == 0)) 
# 
# result_df_summary
# 
# result_df_summary %>% 
#   mutate(pop = case_when(
#     grepl("^W1", ind) ~ "W1",
#     grepl("^W2", ind) ~ "W2",
#     grepl("^AQ", ind) ~ "AQ", TRUE ~ NA_character_)) %>% 
# select(ind, pop, mean, var) %>% 
#   ggplot(aes(x=ind, y=mean, fill = pop)) +
#   geom_bar(stat = "identity") +
#   theme_classic()






