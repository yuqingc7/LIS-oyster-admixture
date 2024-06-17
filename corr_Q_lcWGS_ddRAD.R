target="HHSV85FI"
pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)

K=2

all <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                         target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))
lcWGS_q <- cbind(pop, all) %>% 
  dplyr::select(p,ind,V1) %>% 
  dplyr::rename(all_lcWGS=V1) %>% 
  mutate(ind = str_replace_all(ind, "003a", "003")) %>% 
  mutate(ind = str_replace_all(ind, "008a", "008"))

ddRAD_q <- read_csv("/local/workdir/yc2644/CV_NYC_ddRAD/structure/n380_structure.csv") %>% 
  dplyr::select(Group,Ind,P2) %>% 
  mutate(Ind = str_replace_all(Ind, "-", "_")) %>% 
  mutate(Group = str_replace_all(Group, "HH1013a", "HH13a")) %>% 
  mutate(Ind = str_replace_all(Ind, "HH1013a_0", "HH13a_")) %>% 
  dplyr::rename(p=Group,ind=Ind,all_ddRAD=P2)

real_Q <- full_join(ddRAD_q,lcWGS_q)

## only HH, SV empirical
# real_Q_subset <- real_Q %>%
#   filter(p %in% c("FI1012","HH13a","SV0512a")) %>% 
#   mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a"))) %>%
#   arrange(p)

# real_Q_subset <- real_Q %>%
#   filter(p %in% c("HH13a","SV0512a")) %>% 
#   mutate(p =  factor(p, levels = c("HH13a","SV0512a"))) %>%
#   arrange(p)

real_Q_subset <- real_Q %>%
  filter(p %in% c("SV0512a")) %>% 
  mutate(p =  factor(p, levels = c("SV0512a"))) %>%
  arrange(p)

# correlation test --------------------------------------------------------
library("ggpubr")

shapiro.test(real_Q_subset$all_ddRAD) #data is not normal
shapiro.test(real_Q_subset$all_lcWGS) #data is not normal
ggqqplot(real_Q_subset$all_ddRAD)
# Note that, if the data are not normally distributed, 
# it’s recommended to use the non-parametric correlation, 
# including Spearman and Kendall rank-based correlation tests.

cor.test(real_Q_subset$all_ddRAD, real_Q_subset$all_lcWGS, method=c("kendall"),
         exact=FALSE)

cor.test(real_Q_subset$all_ddRAD, real_Q_subset$all_lcWGS, method=c("spearman"),
         exact=FALSE)

ggscatter(real_Q_subset, x = "all_ddRAD", y = "all_lcWGS", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "spearman",
          xlab = "ddRAD", ylab = "lcWGS",
          title = "Spearman Test for\nInferred Aquaculture Admixture Levels")



