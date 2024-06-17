setwd("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix")

library(RColorBrewer)
library(tidyverse)


# HHSVFI ------------------------------------------------------------------

target="HHSVFI"
K=2

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","SV0512a","HH13a"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:66) %>% 
  rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("AQ_1A","Native"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5, 42.5)) +
  scale_x_continuous(breaks = c(8, 30, 55),
                     labels = c("AQ_1A","SV0512a", "HH1013a"),
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





# HHSV8586 ------------------------------------------------------------------
target="HHSV8586"
K=2

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("CT5786","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:99) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#C77CFF"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(20.5, 45.5,69.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_2","HH13a","SV0512a","CT5785"),
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

target="HHSV8586"
K=3

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("CT5786","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:99) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#C77CFF"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(20.5, 45.5,69.5)) +
  scale_x_continuous(breaks = c(10, 32, 58, 85),
                     labels = c("AQ_2","HH13a","SV0512a","CT5785"),
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



# HHSV85FI ------------------------------------------------------------------
target="HHSV85FI"
K=2

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

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

target="HHSV85FI"
K=3

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5, 42.5,66.5)) +
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

target="HHSV85FI"
K=4

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("FI1012","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:96) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3","V4"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#F2BB66","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5, 42.5,66.5)) +
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



# HHSV85UMFS ------------------------------------------------------------------
target="HHSV85UMFS"
K=2

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("UMFS","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:89) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FF61C3"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(10.5,35.5,59.5)) +
  scale_x_continuous(breaks = c(5, 22, 46, 74),
                     labels = c("AQ_4","HH13a","SV0512a","CT5785"),
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

target="HHSV85UMFS"
K=3

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("UMFS","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V3)) %>% 
  mutate(Ind = 1:89) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#FF61C3"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(10.5,35.5,59.5)) +
  scale_x_continuous(breaks = c(5, 22, 46, 74),
                     labels = c("AQ_4","HH13a","SV0512a","CT5785"),
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

target="HHSV85UMFS"
K=4

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("UMFS","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:89) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3","V4"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#F2BB66","#FF61C3"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(10.5,35.5,59.5)) +
  scale_x_continuous(breaks = c(5, 22, 46, 74),
                     labels = c("AQ_4","HH13a","SV0512a","CT5785"),
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



# HHSV85NEH ------------------------------------------------------------------
target="HHSV85NEH"
K=2

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("NEH","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V1)) %>% 
  mutate(Ind = 1:89) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#00BFC4"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(10.5,35.5,59.5)) +
  scale_x_continuous(breaks = c(5, 22, 46, 74),
                     labels = c("AQ_3","HH13a","SV0512a","CT5785"),
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

target="HHSV85NEH"
K=3

pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

#x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V2 wild
  mutate(p =  factor(p, levels = c("NEH","HH13a","SV0512a","CT5785"))) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V3)) %>% 
  mutate(Ind = 1:89) %>% 
  #rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("V1","V2","V3"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#FFED5F","#00BFC4"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(10.5,35.5,59.5)) +
  scale_x_continuous(breaks = c(5, 22, 46, 74),
                     labels = c("AQ_3","HH13a","SV0512a","CT5785"),
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




# comparison plot ------------------------------------------------------------------

K=5
target="exDEBY"
all <- read.table(paste0("ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                         target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))
pop <- read.table("ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
  dplyr::rename(p=V1,ind=V2)
x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
all_q <- cbind(pop, all) %>% 
  mutate(p =  factor(p, levels = x)) %>%
  arrange(p) %>%
  dplyr::rename(AQ_4=V1, AQ_2=V2, AQ_3=V3, AQ_1A=V4, Native=V5) 

K=2
targets <- c("HHSV8586","HHSV85FI","HHSV85UMFS","HHSV85NEH")

q_list <- list()
for (target in targets) {
  file_name <- paste0("ngsadmix_K", K, "_run1_ALL_ds_Re0.2_",
                      target, "_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
  q <- read.table(file_name)
  pop <- read.table(paste0("ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
    dplyr::rename(p=V1, ind=V2)
  pop_q <- cbind(pop, q) %>% 
    filter(p %in% c("HH13a","SV0512a","CT5785")) %>% 
    mutate(p = factor(p, levels = c("HH13a","SV0512a","CT5785")))
  pop_q$q <- if(pop_q$V1[1] < pop_q$V2[1]) pop_q$V1 else pop_q$V2
  
  q_list[[paste0(target)]] <- pop_q$q
}

Q <- cbind(pop %>% filter(p %in% c("HH13a","SV0512a","CT5785")),as.data.frame(q_list))

# Q_reorder <- Q %>%
#   mutate(p =  factor(p, levels = c("HH13a","SV0512a","CT5785"))) %>%
#   arrange(p,desc(all)) %>% 
#   mutate(Ind = 1:79)
# 
# Q_reorder_long <- Q_reorder %>% 
#   pivot_longer(cols = c("n2500","n5500","n8000","n10000","n20000",
#                         "n50000","n80000","n100000","n200000"), 
#                names_to = "Sites", values_to = "Q_levels") %>% 
#   mutate(Sites = factor(Sites, levels=c("n2500","n5500","n8000","n10000","n20000",
#                                         "n50000","n80000","n100000","n200000")))
# Q_reorder_long

sum_true <- all_q %>% 
  dplyr::group_by(p) %>% 
  dplyr::summarise(
    AQ_1A = mean(AQ_1A),
    AQ_2 = mean(AQ_2),
    AQ_3 = mean(AQ_3),
    AQ_4 = mean(AQ_4)
  ) %>% 
  filter(p %in% c("HH13a","SV0512a","CT5785")) %>% 
  mutate(case="true")

sum_test <- Q %>% 
  dplyr::group_by(p) %>% 
  dplyr::summarise(
    AQ_1A = mean(HHSV85FI),
    AQ_2 = mean(HHSV8586),
    AQ_3 = mean(HHSV85NEH),
    AQ_4 = mean(HHSV85UMFS)
  ) %>% 
  mutate(case="test")

sum <- bind_rows(sum_test, sum_true) %>% 
  pivot_longer(cols = c("AQ_1A","AQ_2","AQ_3","AQ_4"), 
               names_to = "source", values_to = "Q") %>% 
  unite(case_source, source, case,sep = "_", remove=F) %>% 
  mutate(p = factor(p, levels = c("HH13a","SV0512a","CT5785")))

sum

library(ggpattern)
ggplot(sum, aes(x=p,y=Q,fill=source,pattern=case)) +
  geom_bar_pattern(stat = "identity", position = position_dodge(width = 0.8), width = 0.7,
                   color="black",
                   pattern_fill="black",
                   pattern_angle = 45,
                   pattern_density = 0.1,
                   pattern_spacing = 0.025,
                   pattern_key_scale_factor = 0.6) +
  scale_fill_manual(values=c("#B15928","#C77CFF",
                             "#FF61C3","#00BFC4")) +
  scale_pattern_manual(values=c(test="none",true="stripe")) +
  theme_bw() +
  guides(pattern = guide_legend(override.aes = list(fill = "white")),
         fill = guide_legend(override.aes = list(pattern = "none")))

sum_true_t <- all_q %>% 
  dplyr::group_by(p) %>% 
  dplyr::summarise(
    AQ_1A = mean(AQ_1A),
    AQ_2 = mean(AQ_2),
    AQ_3 = mean(AQ_3),
    AQ_4 = mean(AQ_4)
  ) %>% 
  filter(p %in% c("HH13a","SV0512a","CT5785")) %>% 
  pivot_longer(cols = c("AQ_1A","AQ_2","AQ_3","AQ_4"), 
               names_to = "source", values_to = "true Q")

sum_test_t <- Q %>% 
  dplyr::group_by(p) %>% 
  dplyr::summarise(
    AQ_1A = mean(HHSV85FI),
    AQ_2 = mean(HHSV8586),
    AQ_3 = mean(HHSV85NEH),
    AQ_4 = mean(HHSV85UMFS)
  ) %>% 
  pivot_longer(cols = c("AQ_1A","AQ_2","AQ_3","AQ_4"), 
               names_to = "source", values_to = "Q")

sum_t <- left_join(sum_true_t,sum_test_t) %>% 
  mutate(p = ifelse(p == "CT5785", "Cv5785", p)) %>% 
  mutate(p = factor(p, levels = c("HH13a","SV0512a","Cv5785")))

# ## to use ---------------------------------------------------------------

ggplot(subset(sum_t, p %in% c("SV0512a", "Cv5785"))) +
  geom_bar(aes(x=p, y=`true Q`,fill=source),
           stat = 'identity', position = 'stack', width = 0.8, alpha=0.5) +
  scale_fill_manual(values=c("#B15928","#C77CFF",
                             "#FF61C3","#00BFC4"
                             )) +
  labs(x="", y="", title="lcWGS: Population Average of Aquaculture-Sourced Admixture Levels",
       fill="Source of\nAdmixture")+
  theme_bw() +
  geom_bar(aes(x=p,y=Q,fill=source),
           stat = "identity", position = position_dodge(width = 0.8), width = 0.7, color="black")+
  theme(axis.ticks.x = element_blank(),
        #axis.text.x = element_blank(),
        #legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        legend.title = element_text(color="black", size=12),
        plot.title = element_text(size = 14))

ggplot(subset(sum_t, p %in% c("SV0512a", "Cv5785"))) +
  geom_bar(aes(x=p, y=`true Q`,fill=source),
           stat = 'identity', position = 'stack', width = 0.15, 
           color="black",just = -2.8) +
  scale_fill_manual(values=c("#B15928","#C77CFF", 
                             "#FF61C3","#00BFC4"
  )) +
  labs(x="", y="", title="lcWGS: Population Average of Aquaculture-Sourced Admixture Levels",
       fill="Source of\nAdmixture")+
  theme_bw() +
  geom_bar(aes(x=p,y=Q,fill=source),
           stat = "identity", position = position_dodge(width = 0.8), width = 0.6, 
           color="black")+
  geom_vline(xintercept = c(1.6),linetype = "dashed") +
  theme(axis.ticks.x = element_blank(),
        #axis.text.x = element_blank(),
        #legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text = element_text(color="black", size=12, hjust=-0.1),
        legend.text = element_text(color="black", size=12),
        legend.title = element_text(color="black", size=12),
        plot.title = element_text(size = 14)) +
  scale_x_discrete(expand = expansion(add=c(0.5,0.7)))
