# Load the covariance matrix
cov <- as.matrix(read.table("/workdir/yc2644/CV_NYC_lcWGS/results_pca/ALL_ds_Re0.2_exDEBY_ALLsnplist_LDpruned_maf0.05_pval1e-6_pind0.86_cv30_noinver.covMat", header=F))
e <- eigen(cov)

# explained variance ratio of 1st component
# = explained variance of 1st component / (total of all explained variances)
e$values[1]/sum(e$values)

# explained variance ratio of 2nd component
e$values[2]/sum(e$values)

e$vectors

plot(x=e$vectors[,1],y=e$vectors[,2],type="p",ylab="PC 2 (2.064 %)",xlab="PC 1 (2.789 %)", main="PCA (No Inversions; LD pruned SNP list; Related individuals removed)",
     col=c(rep(1, 17), rep(2, 24), rep(3, 25), rep(4,30), rep(5,20), rep(6:7, each=10)), 
     pch=c(rep(1, 17), rep(2, 24), rep(3, 25), rep(4,30), rep(5,20), rep(6:7, each=10)))
legend("bottomleft", 
       legend=c("FI1012", "SV0512a", "HH1013a_merged", "CT5785", "CT5786", "NEH", "UMFS"), 
       col=1:8, pch=1:8, cex=0.8)

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
        scale_colour_manual(values=c("#8DA0CB", "#C77CFF","#00BFC4", "#FF61C3", "#FC8D62", "#66C2A5", "brown3"),
                            name = "Population", labels = c("AQ_1A", "AQ_2", "AQ_3", "AQ_4", "ER_1", "HR_4", "LIS")) +
        scale_shape_manual(values=c(17, 17, 17, 17, 4, 4, 4), name = "Population", 
                           labels = c("AQ_1A", "AQ_2", "AQ_3", "AQ_4", "ER_1", "HR_4", "LIS")) +
        geom_mark_ellipse(aes(color = pop),
#                              label = pop),
                          expand = unit(0,"mm"),
                          label.buffer = unit(0, 'mm'),
                          show.legend = F
        ) +
        scale_x_continuous(paste("PC1 (",round(pc.percent[1],3),"%", ")",sep="")) + 
        scale_y_continuous(paste("PC2 (",round(pc.percent[2],3),"%",")",sep=""))+ 
        theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
        theme(axis.text=element_text(size=12),
              text = element_text(size=18,family="Times"),
              panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(),
              panel.background = element_rect(colour = "black", size=0.5))

