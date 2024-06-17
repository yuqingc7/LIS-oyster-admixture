setwd("/workdir/yc2644/CV_NYC_lcWGS/results_ngsadmix")

library(RColorBrewer)
library(tidyverse)

pop <- read.table("ALL_ds_Re0.2_exDEBY.info", as.is=T)

#par(mfrow=c(3,2))
par(mfrow=c(1,1))

# K=3 ---------------------------------------------------------------------
q <- read.table("ngsadmix_K3_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
ord <- order(pop[,1])
barplot(t(q)[,ord], col=brewer.pal(8, "Set2"), space=0, border=NA, xlab="Individuals", ylab = "Admixture proportions for K=3")
text(tapply(1:nrow(pop), pop[ord,1], mean), -0.08, unique(pop[ord,1]), xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)


# K=4 ---------------------------------------------------------------------

q <- read.table("ngsadmix_K4_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
ord <- order(pop[,1])
barplot(t(q)[,ord], col=brewer.pal(8, "Set2"), space=0, border=NA, xlab="Individuals", ylab = "Admixture proportions for K=4")
text(tapply(1:nrow(pop), pop[ord,1], mean), -0.1, unique(pop[ord,1]), xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)


# K=5 ---------------------------------------------------------------------

q <- read.table("ngsadmix_K5_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
ord <- order(pop[,1])
barplot(t(q)[,ord], col=brewer.pal(8, "Set2"), space=0, border=NA, xlab="Individuals", ylab = "Admixture proportions for K=5")
text(tapply(1:nrow(pop), pop[ord,1], mean), -0.1, unique(pop[ord,1]), xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)


# K=6 ---------------------------------------------------------------------

q <- read.table("ngsadmix_K6_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
ord <- order(pop[,1])
barplot(t(q)[,ord], col=brewer.pal(8, "Set2"), space=0, border=NA, xlab="Individuals", ylab = "Admixture proportions for K=6")
text(tapply(1:nrow(pop), pop[ord,1], mean), -0.1, unique(pop[ord,1]), xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)


# K=7 ---------------------------------------------------------------------

q <- read.table("ngsadmix_K7_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")
ord <- order(pop[,1])
barplot(t(q)[,ord], col=brewer.pal(8, "Set2"), space=0, border=NA, xlab="Individuals", ylab = "Admixture proportions for K=7")
text(tapply(1:nrow(pop), pop[ord,1], mean), -0.1, unique(pop[ord,1]), xpd=T)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)






# Best K after LD pruning -------------------------------------------------
pop <- read.table( "ALL_ds_Re0.2_exDEBY.info", as.is=T) %>% 
  rename(p=V1, ind=V2)
q <- read.table("ngsadmix_K5_run1_ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.qopt")

pop_q <- cbind(pop, q)

x <- c("FI1012","CT5786", "NEH", "UMFS", "HH13a", "SV0512a","CT5785")
pop_q_reorder <- pop_q %>%
  mutate(p =  factor(p, levels = x)) %>%
  arrange(p)  



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
