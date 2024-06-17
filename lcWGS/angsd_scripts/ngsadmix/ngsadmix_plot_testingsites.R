setwd("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix")

library(RColorBrewer)
library(tidyverse)

target="HHSV85FI"
pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)

# ddRAD n=5500 ------------------------------------------------------------------
K=2
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.ddRAD5500.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# lcWGS on RAD tags n=18871 ------------------------------------------------------------------
K=2
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.ddRAD.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=2500 ------------------------------------------------------------------
n=2500
K=2
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=5500 ------------------------------------------------------------------
n=5500
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=8000 ------------------------------------------------------------------
n=8000
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))


# n=10000 ------------------------------------------------------------------
n=10000
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=20000 ------------------------------------------------------------------
n=20000
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=50000 ------------------------------------------------------------------
n=50000
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=80000 ------------------------------------------------------------------
n=80000
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# n=100000 ------------------------------------------------------------------
n=format(100000, scientific = FALSE)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))


# n=200000 ------------------------------------------------------------------
n=format(200000, scientific = FALSE)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                       n,".qopt"))
pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))



# all ---------------------------------------------------------------------

q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5,42.5,66.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_1A","HH13a","SV0512a","CT5785"),
                     #labels = c("", "",""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))





# comparison plot ---------------------------------------------------------

all <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                       target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))
lcWGS_q <- cbind(pop, all) %>% 
  dplyr::select(p,ind,V1) %>% 
  dplyr::rename(all_lcWGS=V1) %>% 
  mutate(ind = str_replace_all(ind, "003a", "003")) %>% 
  mutate(ind = str_replace_all(ind, "008a", "008"))

ddRAD_q2 <- read_csv("/local/workdir/yc2644/CV_NYC_ddRAD/structure/n380_structure.csv") %>% 
  mutate(location = c(rep("Aquaculture",27), 
                      rep("Hudson River",189), 
                      rep("ddRAD\nEast River",164))) %>% 
  filter(location=="ddRAD\nEast River") %>% 
  dplyr::select(Group,Ind,P2) %>% 
  mutate(Ind = str_replace_all(Ind, "-", "_")) %>% 
  dplyr::rename(p=Group,ind=Ind,all_ddRAD=P2)

ddRAD_q <- read_csv("/local/workdir/yc2644/CV_NYC_ddRAD/structure/n380_structure.csv") %>% 
  dplyr::select(Group,Ind,P2) %>% 
  mutate(Ind = str_replace_all(Ind, "-", "_")) %>% 
  mutate(Group = str_replace_all(Group, "HH1013a", "HH13a")) %>% 
  mutate(Ind = str_replace_all(Ind, "HH1013a_0", "HH13a_")) %>% 
  dplyr::rename(p=Group,ind=Ind,all_ddRAD=P2)

real_Q <- full_join(ddRAD_q,lcWGS_q)

sites <- c(2500, 5500, 8000, 10000,20000,50000,80000,format(100000, scientific = FALSE),format(200000, scientific = FALSE))
q_list <- list()
for (n in sites) {
  file_name <- paste0("ngsadmix_K", K, "_run1_ALL_ds_Re0.2_",
                      target, "_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                      n, ".qopt")
  q_table <- read.table(file_name)
  q_list[[paste0("n", n)]] <- if(q_table$V1[1]>q_table$V2[1]) q_table$V1 else q_table$V2
}

Q <- cbind(lcWGS_q,as.data.frame(q_list))

Q2 <- inner_join(ddRAD_q2,Q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
Q_reorder <- Q %>%
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p,desc(all_lcWGS)) %>% 
  mutate(Ind = 1:96)

Q_reorder_long <- Q_reorder %>% 
  pivot_longer(cols = c("n2500","n5500","n8000","n10000","n20000",
                        "n50000","n80000","n100000","n200000"), 
               names_to = "Sites", values_to = "Q_levels") %>% 
  mutate(Sites = factor(Sites, levels=c("n2500","n5500","n8000","n10000","n20000",
                                        "n50000","n80000","n100000","n200000")))

Q_reorder_long

#library(wesanderson)

ggplot(subset(Q_reorder_long, p %in% c("SV0512a","CT5785")), 
       aes(x=Ind,y=all_lcWGS))+
  scale_x_continuous(breaks = c(53,83),labels = c("SV0512a","CT5785"),
                     expand = c(0.025, 0.025)) +
  geom_vline(xintercept = c(66.5),linetype = "dashed") +
  geom_point(color="red",size=2.5)+
  geom_point(aes(x=Ind, y=Q_levels,color=Sites),shape=1,size=2.5)+
  scale_color_manual(values=c("#0000FF", #2500,
                              "#3399FF", #5500
                              "#66B2FF", #8000
                              "#99CCFF", #10000
                              "#99FF99", #20000
                              "#FFFF00", #50000
                              "#FF8C00", #80000
                              "#FFA500", #100000
                              "#FF4500" #200000
                              )) +
  labs(x="", y="", title="AQ-sourced admixture level")+
  theme_bw() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))+
  facet_wrap(~Sites, nrow=3,
             #scales = "free_y",
             #labeller = as_labeller(immigration_rate_list)
  )

Q2_reorder <- Q2 %>%
  mutate(p =  factor(p, levels = c("SV0512a"))) %>%
  arrange(p,desc(all_lcWGS)) %>% 
  mutate(Ind = 1:17)

Q2_reorder_long <- Q2_reorder %>% 
  pivot_longer(cols = c("n2500","n5500","n8000","n10000","n20000",
                        "n50000","n80000","n100000","n200000"), 
               names_to = "Sites", values_to = "Q_levels") %>% 
  mutate(Sites = factor(Sites, levels=c("n2500","n5500","n8000","n10000","n20000",
                                        "n50000","n80000","n100000","n200000")))
Q2_reorder_long

# ## to use ---------------------------------------------------------------
ggplot(subset(Q2_reorder_long, 
              Sites %in% c("n2500","n5500","n8000","n10000","n20000","n50000")),
       aes(x=Ind,y=all_lcWGS))+
  geom_point(color="red",size=2.5)+
  geom_point(aes(x=Ind, y=all_ddRAD), color="brown",size=2.5)+
  geom_point(aes(x=Ind, y=Q_levels),shape=1,size=2.5,color="blue")+
  labs(x="Individuals", y="", title="Aquaculture(AQ_1)-Sourced Admixture Level")+
  theme_bw() +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 14))+
  facet_wrap(~Sites, nrow=2,
             #scales = "free_y",
             labeller = labeller(Sites = c("n2500" = "n=2,500", "n5500" = "n=5,500", 
                                           "n8000" = "n=8,000", "n10000" = "n=10,000", 
                                           "n20000" = "n=20,000", "n50000" = "n=50,000"))
  ) +
  theme(text = element_text(size = 14))

# get the dot images for legend
my_data_frame <- data.frame(x = c(1,1,1), y=c(1,2,3), col=c("ddRAD","lcWGS","Downsampled lcWGS")) %>% 
  mutate(col = factor(col, levels=c("ddRAD","lcWGS","Downsampled lcWGS")))
  

ggplot(my_data_frame, aes(x=x,y=y,color=col, shape=col))+
  geom_point(size=3.5) +
  scale_color_manual(values=c("brown", "red", "blue")) +
  scale_shape_manual(values=c(19,19,1))+
  theme_minimal()+
  theme(text = element_text(size = 14))+
  guides(color = guide_legend(nrow = 1))
  

## only HH, SV empirical
real_Q_subset <- real_Q %>%
  filter(p %in% c("FI1012","HH13a","SV0512a")) %>% 
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a"))) %>%
  arrange(p)

real_Q_reorder <- real_Q %>%
  filter(p %in% c("HH13a","SV0512a")) %>% 
  mutate(p =  factor(p, levels = c("HH13a","SV0512a"))) %>%
  arrange(p,desc(all_lcWGS)) %>% 
  mutate(Ind = 1:54)

ggplot(real_Q_reorder,
       aes(x=Ind,y=all_lcWGS))+
  scale_x_continuous(breaks = c(12,41),labels = c("HH1013a","SV0512a"),
                     expand = c(0.025, 0.025)) +
  geom_vline(xintercept = c(25.5),linetype = "dashed") +
  geom_point(color="red",size=2.5,shape=13)+
  geom_point(aes(x=Ind, y=all_ddRAD), color="brown",size=2.5,shape=13)+
  labs(x="", y="", title="AQ-sourced admixture level")+
  theme_bw() +
  theme(axis.ticks.x = element_blank(),
        #axis.text.x = element_blank(),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

# colored gradient panel
custom_colors <- c("#0000FF", "#3399FF", "#66B2FF", "#99CCFF", "#99FF99", "#FFFF00", "#FF8C00", "#FFA500", "#FF4500")
gradient_data <- data.frame(
  gradient = 1:length(custom_colors),
  color_label = sites
)
ggplot(gradient_data, aes(x = gradient, y = 1)) +
  geom_tile(aes(fill = custom_colors), width = 1, height = 1) +
  scale_fill_identity() +
  scale_x_continuous(breaks=1:9,labels=sites,expand=c(0,0))+
  scale_y_continuous(expand=c(0,0))+
  theme(legend.position = "none")+
  theme_minimal()+
  labs(x="", y="")+
  theme(axis.text.y=element_blank(),
    axis.text = element_text(color="black", size=12,face = "bold"))+
  theme(axis.text.x = element_text(margin = margin(t = -20))) 

# subset
ggplot(subset(Q_reorder_long, 
              p %in% c("SV0512a","CT5785") & Sites %in% c("q5500","q20000",
                                                          "q50000",
                                                          "q100000")), 
       aes(x=Ind,y=all))+
  scale_x_continuous(breaks = c(53,83),labels = c("SV0512a","CT5785"),
                     expand = c(0.025, 0.025)) +
  geom_vline(xintercept = c(66.5),linetype = "dashed") +
  geom_point(color="red",size=3)+
  geom_point(aes(x=Ind, y=Q_levels,color=Sites),shape=1,size=3)+
  scale_color_manual(values=c(
                              #"#99CCFF", #10000
                              "#FFA500", #100000
                              "#99FF99", #20000
                              # "#FF4500", #200000
                              # "#0000FF", #2500
                              "#FFFF00", #50000
                              "#3399FF" #5500
                              # "#66B2FF", #8000
                              #"#FF8C00" #80000
  )) +
  labs(x="", y="", title="AQ-sourced admixture level")+
  theme_bw() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))
