# codes for plotting figures
setwd("/local/workdir/yc2644/CV_NYC_misc")
library(ggsci)
library(tidyverse)
library(ggplot2)

# lcWGS PCA ----------------------------------------------------------

# Load the covariance matrix
cov <- as.matrix(read.table("/workdir/yc2644/CV_NYC_lcWGS/results_pca/ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.covMat", header=F))
e <- eigen(cov)

# explained variance ratio of 1st component
# = explained variance of 1st component / (total of all explained variances)
e$values[1]/sum(e$values)

# explained variance ratio of 2nd component
e$values[2]/sum(e$values)

e$vectors

require(tidyverse)
df_e <- data.frame(pop = c(rep("AQ_1A", 17), rep("ER_1", 24), rep("HR_4", 25), rep("LIS",30), rep("AQ_2",20), rep("AQ_3", 10), rep("AQ_4", 10)),
                   EV1 = e$vectors[,1],    # the first eigenvector
                   EV2 = e$vectors[,2],    # the second eigenvector
                   EV3 = e$vectors[,3],    # the second eigenvector
                   EV4 = e$vectors[,4],    # the second eigenvector
                   stringsAsFactors = FALSE) %>% 
  mutate(grp = ifelse(grepl("AQ", pop), "Aquaculture", "Native"))
#                            ifelse(grepl("HH", pop), "Hudson River", 
#                                   ifelse(grepl("SV", pop), "East River", "Long Island Sound"))))
df_e  

require(ggforce)
ggplot(df_e, aes(x = EV1, y = EV2)) +        
  geom_point(size=2, aes(color=pop, shape=pop))+
  labs(color="Population", shape = "Population") +
  scale_colour_manual(values=c("#8DA0CB", "#4681a9","#E9C359", "#B55374", "#FC8D62", "#66C2A5", "brown3"),
                      name = "Population", labels = c("AQ_1A", "AQ_2", "AQ_3", "AQ_4", "SV0512a", "HH1013a", "Cv5785")) +
  scale_shape_manual(values=c(17, 17, 17, 17, 4, 4, 4), name = "Population", 
                     labels = c("AQ_1A", "AQ_2", "AQ_3", "AQ_4", "SV0512a", "HH1013a", "Cv5785")) +
  geom_mark_ellipse(aes(color = pop),
                    #                              label = pop),
                    expand = unit(0,"mm"),
                    label.buffer = unit(0, 'mm'),
                    show.legend = F
  ) +
  scale_x_continuous(paste("PC1 (",round(e$values[1]/sum(e$values)*100,3),"%", ")",sep="")) + 
  scale_y_continuous(paste("PC2 (",round(e$values[2]/sum(e$values)*100,3),"%",")",sep=""))+ 
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.text=element_text(size=14),
        text = element_text(size=14),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=0.5),
        legend.position = c(0.275,0.25),
        legend.background = element_rect(fill = "white", color = "white", size = 0.3),
        legend.box = "vertical",
        legend.title = element_text(size = 12))+
  guides(
    shape = guide_legend(ncol = 2, bycol = TRUE),
    color = guide_legend(ncol = 2, bycol = TRUE)
  )

ggsave("lcWGS_PCA.pdf", device = "pdf", width=12, height =11, unit="cm",
       dpi=600)
ggsave("lcWGS_PCA.png", device = "png", width=12.5, height =11, unit="cm",
       dpi=600)

# lcWGS NGSADMIX ---------------------------------
pop <- read.table( "/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)
q <- read.table("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K5_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")

pop_q <- cbind(pop, q)

x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V5 wild
  mutate(p =  factor(p, levels = x)) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V5)) %>% 
  mutate(Ind = 1:136) %>% 
  dplyr::rename(AQ_4=V1, AQ_2=V2, AQ_3=V3, AQ_1A=V4, Native=V5) %>% 
  pivot_longer(cols = c("AQ_1A", "AQ_2","AQ_3","AQ_4", "Native"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#4681a9","#8DA0CB","#B55374","#E9C359"))+
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
        plot.title = element_text(size = 16))+
  guides(fill = "none")

# lcWGS NGSADMIX only FI ---------------------------------
target="HHSV85FI"
K=2
pop <- read.table(paste0("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)

q <- read.table(paste0("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                         target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))

pop_q <- cbind(pop, q)

x <- c("FI1012","HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>% #V5 wild
  mutate(p =  factor(p, levels = x)) %>%
  arrange(p)  

pop_q_reorder_ord_long <- pop_q_reorder %>% 
  arrange(p, desc(1-V2)) %>% 
  mutate(Ind = 1:96) %>% 
  dplyr::rename(AQ_1A=V1, Native=V2) %>% 
  pivot_longer(cols = c("AQ_1A", "Native"), names_to = "Source", values_to = "Q") 

ggplot(pop_q_reorder_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99","#B15928"))+
  #                   labels = c("Native", "AQ_2","AQ_1A","AQ_4", "AQ_3")) +
  geom_vline(xintercept = c(17.5, 42.5, 66.5)) +
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
        plot.title = element_text(size = 16))+
  guides(fill = "none")


# ddRAD PCA ---------------------------------
library(SNPRelate)
# vcf
vcf.fn <- "/local/workdir/yc2644/CV_NYC_ddRAD/vcf/SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.vcf"
# VCF => GDS
snpgdsVCF2GDS(vcf.fn, "SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds", method="biallelic.only")
# summary
snpgdsSummary("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds")
# Open the GDS file
genofile <- snpgdsOpen("SNP.DP3g95p10maf05.HWE.mod.biallelic.all_exGRV.n396_indep_50_1_0.2_pruned.nochr156invers.n380_refil.recode.gds")

pca <- snpgdsPCA(genofile,autosome.only=FALSE)
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  EV3 = pca$eigenvect[,3],    # the second eigenvector
                  EV4 = pca$eigenvect[,4],    # the second eigenvector
                  stringsAsFactors = FALSE)

require(tidyverse)
meta <- read_tsv("/local/workdir/yc2644/CV_NYC_ddRAD/sample_lists/popmap_mod", col_names = F)
names(meta)[1] <- "sample.id"
names(meta)[2] <- "pop"
meta
length(sort(unique(meta$pop))) # 22 populations

dim(meta); dim(tab)
# tab_meta <- right_join(meta, tab, by="sample.id") %>% 
#   mutate(grp = ifelse(grepl("FI", pop), "Aquacultured", 
#                       ifelse(grepl("HH|IRV|PM|PRA|TPZ", pop), "Hudson River", "East River")))
tab_meta <- right_join(meta, tab, by="sample.id") %>% 
  mutate(grp = ifelse(grepl("FI1012", pop), "Aquaculture_1A", ifelse(grepl("FIS1013a", pop), "Aquaculture_1B",
                                                                     ifelse(grepl("HH|IRV|PM|PRA|TPZ", pop), "Hudson River", "East River"))))

dim(tab_meta)
length(sort(unique(tab_meta$pop))) # 19 populations

ggplot(tab_meta, aes(x = EV1, y = EV2)) + 
  geom_point(size=2, aes(color=grp, shape=grp))+
  geom_mark_ellipse(aes(color = grp
  ),
  expand = unit(0,"mm"),
  label.buffer = unit(0, 'mm'),
  show.legend = F
  ) +
  scale_colour_manual(values=c("#8DA0CB", "#8DA0CB","#FC8D62","#66C2A5"), name = "Population", 
                      labels = c("AQ_1A", "AQ_1B", "East River", "Hudson River")) +
  scale_shape_manual(values=c(17,2, 4, 4), name = "Population", 
                     labels = c("AQ_1A", "AQ_1B", "East River", "Hudson River")) +
  scale_x_continuous(paste("PC1 (",round(pc.percent[1],3),"%", ")",sep="")) + 
  scale_y_continuous(paste("PC2 (",round(pc.percent[2],3),"%",")",sep=""))+ 
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.text=element_text(size=14),
        text = element_text(size=14),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=0.5),
        legend.position = c(0.25,0.2),
        legend.background = element_rect(fill = "white", color = "white", size = 0.3),
        legend.box = "vertical",
        legend.title = element_text(size = 12),
        legend.key = element_rect(fill = "#f2f2f2",color="#f2f2f2"))+
  coord_cartesian(ylim=c(-0.425,0.25))

ggsave("ddRAD_PCA.pdf", device = "pdf", width=12, height =11, unit="cm",
       dpi=600)
ggsave("ddRAD_PCA.png", device = "png", width=12.5, height =11, unit="cm",
       dpi=600)

# ddRAD STRUCTURE ---------------------------------

str <- read_csv("/local/workdir/yc2644/CV_NYC_ddRAD/structure/n380_structure.csv") # P2 = aquaculture 
str_ord_long <- str %>% 
  arrange(factor(Group, levels = c("FI1012","FIS1013a","PM1012","TPZ0713","IRV1012",
                                   "HH0512a","HH1013a","HH1013s","HH812s","HH912s",
                                   "PRA1013a","SV0512a","SV1013a","SV812s","SV912s",
                                   "WFM812s","RI812s","AB812s","NTC1013a")),desc(P2)) %>% 
  mutate(Ind = 1:380) %>% 
  pivot_longer(cols = c("P1", "P2"), names_to = "Source", values_to = "Q") 

ggplot(str_ord_long, aes(x = Ind, y=Q, fill=reorder(Source, -Q))) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99", "#B15928"),
                    labels = c("Native", "Aquaculture")) +
  geom_vline(xintercept = c(13, 27,43,63,86,103,125,148,170,193,
                            216,236,259,282,305,325,338,360,380)+0.5,size=0.1) +
  scale_x_continuous(breaks = c(13, 27,43,63,86,103,125,148,170,193,
                                216,236,259,282,305,325,338,360,380), 
                     labels = c("", "","","", "", "", "","", "","","", "", "", "",
                                "", "","","", ""), 
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16)) +
  guides(fill = "none")

# AQ sources ---------------------------------

K=5
target="exDEBY"
all <- read.table(paste0("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
                         target,"_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt"))
pop <- read.table("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
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
  file_name <- paste0("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K", K, "_run1_ALL_ds_Re0.2_",
                      target, "_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
  q <- read.table(file_name)
  pop <- read.table(paste0("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
    dplyr::rename(p=V1, ind=V2)
  pop_q <- cbind(pop, q) %>% 
    filter(p %in% c("HH13a","SV0512a","CT5785")) %>% 
    mutate(p = factor(p, levels = c("HH13a","SV0512a","CT5785")))
  pop_q$q <- if(pop_q$V1[1] < pop_q$V2[1]) pop_q$V1 else pop_q$V2
  
  q_list[[paste0(target)]] <- pop_q$q
}

Q <- cbind(pop %>% filter(p %in% c("HH13a","SV0512a","CT5785")),as.data.frame(q_list))

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

ggplot(subset(sum_t, p %in% c("SV0512a", "Cv5785"))) +
  geom_bar(aes(x=p, y=`true Q`,fill=source),
           stat = 'identity', position = 'stack', width = 0.15, 
           color="black",just = -2.8) +
  scale_fill_manual(values=c("#8DA0CB", "#4681a9","#E9C359", "#B55374")) +
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


# sites -------------------------------------------------------------------

target="HHSV85FI"
K=2
pop <- read.table(paste0("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ALL_ds_Re0.2_",target,".info"), as.is=T) %>% 
  dplyr::rename(p=V1, ind=V2)

all <- read.table(paste0("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K",K,"_run1_ALL_ds_Re0.2_",
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
  file_name <- paste0("/local/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix/ngsadmix_K", K, "_run1_ALL_ds_Re0.2_",
                      target, "_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.n",
                      n, ".qopt")
  q_table <- read.table(file_name)
  q_list[[paste0("n", n)]] <- if(q_table$V1[1]>q_table$V2[1]) q_table$V1 else q_table$V2
}

Q <- cbind(lcWGS_q,as.data.frame(q_list))
Q2 <- inner_join(ddRAD_q2,Q)

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

ggplot(subset(Q2_reorder_long, 
              Sites %in% c("n2500","n5500","n8000","n10000","n20000","n50000")),
       aes(x=Ind,y=all_lcWGS))+
  geom_segment(aes(x=Ind, xend=Ind, y=all_lcWGS, yend=all_ddRAD), color="grey") +
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

