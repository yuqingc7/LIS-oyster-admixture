setwd("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix")

library(RColorBrewer)
library(tidyverse)

pop <- read.table("ALL_ds_Re0.2_exDEBY.info", as.is=T)

#par(mfrow=c(3,2))
par(mfrow=c(1,1))

# Best K=5 after LD pruning -------------------------------------------------
pop <- read.table( "ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table("ngsadmix_K5_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")

pop_q <- cbind(pop, q)

x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V5 wild
  mutate(p =  factor(p, levels = x)) %>%
  arrange(p)  

plot_AQ <- pop_q_reorder %>% 
  mutate(AQ = 1-V5) %>% 
  dplyr::select(p, AQ)

str_sum_by_pop <- plot_AQ %>% 
  dplyr::select(p, AQ) %>% 
  group_by(p) %>% 
  summarise(count = n(), mean = mean(AQ), var = var(AQ)) %>% 
  ungroup() %>% 
  arrange(mean) %>% 
  mutate(location = c("Hudson River","Long Island Sound", "East River", rep("Aquaculture",4)))

str_sum_by_pop_ER <- str %>% 
  dplyr::select(Group, P2) %>% 
  group_by(Group) %>% 
  summarise(count = n(), mean = mean(P2), var = var(P2),
            num_zeros = sum(P2 <= mean(str_sum_by_pop$mean[1:8]))) %>% 
  mutate(freq_unadmixed = num_zeros/(count)) %>% 
  ungroup() %>% 
  dplyr::select(-num_zeros) %>% 
  arrange(mean) %>% 
  mutate(location = c(rep("Hudson River",9), rep("East River",8), rep("Aquaculture",2))) %>% 
  filter(location == "East River")

write_tsv(str_sum_by_pop_ER,
          file = "/local/workdir/yc2644/CV_NYC_nemo_sim/NYC_ddRAD_str_sum_by_pop_ER.tsv",
          col_names = TRUE)

# distribution for wild pops, zoomed in -------------------------------------------------
plot_list <- list()

plot_list[[1]] <- plot_AQ %>% filter(p == "HH13a") %>% 
  ggplot(aes(x=AQ, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#66C2A5", fill="#66C2A5", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,0.45)) +
  labs(title="Hudson River Native Populations",x="",y="") + 
  theme_classic()

plot_list[[2]] <- plot_AQ %>% filter(p == "SV0512a") %>% 
  ggplot(aes(x=AQ, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#FC8D62", fill="#FC8D62", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,0.45)) +
  labs(title="East River Native Populations",x="",y="") + 
  theme_classic()

plot_list[[3]] <- plot_AQ %>% filter(p == "CT5785") %>% 
  ggplot(aes(x=AQ, y=after_stat(count/sum(count))))+
  geom_histogram(color = "red", fill="red", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,0.45)) +
  labs(title="Long Island Sound Native Populations",x="",y="") + 
  theme_classic()

grid.arrange(grobs=plot_list, nrow=3, 
             top=textGrob("Aquaculture Assignment Rate Q by NGSAdmix, lcWGS data", 
                          gp=gpar(fontsize=15,font=8)),
             left="Frequency")


# distribution for admixed wild pops, zoomed in -------------------------------------------------
plot_list <- list()

plot_list[[1]] <- plot_AQ %>% filter(p == "SV0512a") %>% 
  ggplot(aes(x=AQ, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#FC8D62", fill="#FC8D62", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.2)) +
  coord_cartesian(xlim = c(0,0.45)) +
  labs(title="East River Native Populations",x="",y="") + 
  theme_classic()

plot_list[[2]] <- plot_AQ %>% filter(p == "CT5785") %>% 
  ggplot(aes(x=AQ, y=after_stat(count/sum(count))))+
  geom_histogram(color = "red", fill="red", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.2)) +
  coord_cartesian(xlim = c(0,0.45)) +
  labs(title="Long Island Sound Native Populations",x="",y="") + 
  theme_classic()

grid.arrange(grobs=plot_list, nrow=2, 
             top=textGrob("Aquaculture Assignment Rate Q by NGSAdmix, lcWGS data", 
                          gp=gpar(fontsize=15,font=8)),
             left="Frequency")

# structure plot  -------------------------------------------------

#ord <- order(pop[,1])
ord <- c(1:136)
labels <- c("AQ_1A", "AQ_2","AQ_3","AQ_4", "HR_4", "ER_1", "LIS")

barplot(t(pop_q_reorder[3:7])[,ord], col=c("#1F78B4","#A6CEE3","#FB9A99","#B2DF8A","#33A02C"), space=0, border=NA, 
        #        xlab="Individuals", 
        ylab = "Admixture proportions for K=5",
        cex.lab = 1.5)

text(sort(tapply(1:nrow(pop_q_reorder), pop_q_reorder[ord,1], mean)), -0.08, labels=labels, xpd=T)
abline(v=cumsum(sapply(unique(pop_q_reorder[ord,1]),function(x){sum(pop_q_reorder[ord,1]==x)})),col=1,lwd=1.2)
# 12 x 6


# ordered structure plot  -------------------------------------------------
pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V5)) %>% 
  mutate(Ind = 1:136) %>% 
  rename(AQ_4=V1, AQ_2=V2, AQ_3=V3, AQ_1A=V4, Native=V5) %>% 
  pivot_longer(cols = c("AQ_1A", "AQ_2","AQ_3","AQ_4", "Native"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  #scale_fill_manual(values = c("#33A02C","#A6CEE3","#B2DF8A","#1F78B4","#FB9A99"))+
  scale_fill_manual(values = c("#FFFF99","#C77CFF","#B15928","#FF61C3","#00BFC4"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5, 37.5, 47.5, 57.5, 82.5, 106.5)) +
  scale_x_continuous(breaks = c(8, 27, 43, 52, 70, 94, 121),
                     #labels = c("AQ_1A", "AQ_2","AQ_3","AQ_4", "HR_4", "ER_1", "LIS"),
                     labels = c("", "","","", "", "", ""),
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))

