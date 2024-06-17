setwd("/local/workdir/yc2644/CV_NYC_nemo_sim/structure_rep_sum")

library(tidyverse)

# run after "merge_Q_across_K_str_repeats.R"
# 
# s=1000 # 1000 or 40
# pre_ad_gen=11400 #11400 or 10440
#ad_gen = pre_ad_gen+1 #c(1,2,3,5,10,15,20,30)

# s=3270 # 1000 or 40
# pre_ad_gen=13670 #11400 or 10440
s=280 # 1000 or 40
pre_ad_gen=10680

total_rep = 10

scenario = "cons" # "cons" or "single"
#admix_cases = c("single0.1","single0.2","single0.5","single0.8","single1")
admix_cases = c("cons0.001", "cons0.002", "cons0.005", "cons0.01", "cons0.02", "cons0.05")

#for (tdiff in c(0,1,2,3,5,10,15,20)){
for (tdiff in c(0,1,5,10,20,30)){

  #ad_gen = pre_ad_gen+tdiff
  ad_gen = pre_ad_gen+tdiff+1
  
  for (x in seq_along(admix_cases)){
    
    admix = admix_cases[x]
    
    # create a list of file names
    file_list <- paste0("2pop_ntrl_eq10400_s", s,"_", admix, "_rep", sprintf("%02d", 1:total_rep), "_", ad_gen, "_merged_Q.txt")
    
    # read in all files
    df_list <- map(file_list, ~ read_tsv(.x, col_names = F))
      
    for (i in 1:length(df_list)) {
      col_min <- df_list[[i]] %>% filter(grepl("W1", df_list[[i]][[1]])) %>% 
        summarize(col_min = if_else(sum(X2 < X3) >= sum(X3 < X2), "X2", "X3"))
      df_list[[i]] <- df_list[[i]] %>% dplyr::select(X1, !!col_min$col_min) %>% dplyr::rename(ind = 1)
      colnames(df_list[[i]])[2] <- paste0("rep", sprintf("%02d", i))
    }
    
    # join the rest of the files to the first file
    for (i in 2:length(df_list)) {
      df_list[[1]] <- left_join(df_list[[1]], df_list[[i]], by = "ind")
    }
    
    # Extract the final data frame
    result_df <- df_list[[1]]
    
    # Make tidy data
    result_df_tidy <- result_df %>% 
      pivot_longer(paste0("rep", sprintf("%02d", 1:total_rep)), 
                   names_to = 'simulation_replicate', values_to = 'AQ_assignment_rate') %>% 
      mutate(pop = case_when(
        grepl("^W1", ind) ~ "W1",
        grepl("^W2", ind) ~ "W2",
        grepl("^AQ", ind) ~ "AQ", TRUE ~ NA_character_)) %>% 
      dplyr::select(ind, pop, simulation_replicate, AQ_assignment_rate) %>%
      mutate(pop_diff = paste0("eq10400_s", s), 
             admix_scenario = admix, 
             gen_to_admix = ad_gen - pre_ad_gen,
             total_sim_rep = total_rep)
    
    # get a mean admixture level for W2 unadmixed
    sum_by_pop <- result_df_tidy %>% 
      group_by(pop,admix_scenario) %>% 
      dplyr::summarise(mean = mean(AQ_assignment_rate), 
                var = var(AQ_assignment_rate),
                num_zeros = sum(AQ_assignment_rate == 0))
    
    # define unadmixed individuals in W1 by comparing it with W2 mean level
    sum_by_rep_pop <- result_df_tidy %>% 
      group_by(simulation_replicate, pop) %>% 
      dplyr::summarise(mean = mean(AQ_assignment_rate), 
                var = var(AQ_assignment_rate),
                num_zeros = sum(AQ_assignment_rate <= sum_by_pop$mean[3])) %>% 
      ungroup() %>% 
      arrange(pop) %>% 
      mutate(freq_unadmixed = num_zeros/(30)) %>% 
      dplyr::select(-num_zeros) %>% 
      mutate(pop_diff = paste0("eq10400_s", s), 
             admix_scenario = admix, 
             gen_to_admix = ad_gen - pre_ad_gen,
             total_sim_rep = total_rep)
    
    # define the file path for the TSV file
    #file_path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/2pop_ntrl_eq10400_s", s,"_", admix, "_", ad_gen, "_total_rep", total_rep, "_tidy_Q.tsv")
    #write_tsv(result_df_tidy, file = file_path, col_names = T)
    
    file_tot_path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/2pop_ntrl_eq10400_s", s, "_", scenario, "_g", ad_gen-pre_ad_gen, "_total_rep", total_rep, "_tidy_Q.tsv")
    if (x == 1) {
      write_tsv(result_df_tidy, file = file_tot_path, col_names = TRUE, append = FALSE)
    } else {
      write_tsv(result_df_tidy, file = file_tot_path, append = TRUE)
    }
    
    file_sum_path = paste0("/local/workdir/yc2644/CV_NYC_nemo_sim/nemo_rep_sum/2pop_ntrl_eq10400_s", s, "_", scenario, "_g", ad_gen-pre_ad_gen, "_total_rep", total_rep, "_sum_by_rep_pop_Q.tsv")
    if (x == 1) {
      write_tsv(sum_by_rep_pop, file = file_sum_path, col_names = TRUE, append = FALSE)
    } else {
      write_tsv(sum_by_rep_pop, file = file_sum_path, append = TRUE)
    }
  }
}
