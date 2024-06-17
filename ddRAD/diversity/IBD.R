library(ade4)

setwd("/local/workdir/yc2644/CV_NYC_ddRAD/diversity")

dist1 <- read.delim("aquatic_dis_matrix.txt", header = TRUE, sep = "\t")
dist2 <- as.matrix(dist1)
rownames(dist2) <- colnames(dist1)
ddRAD_dist <- dist2[-18,-18]

gen1 <- read.table("pairwise.pruned.fst.txt",header=TRUE,sep="\t")
gen2 <- as.matrix(gen1)
rownames(gen2) <- colnames(gen1)
new_order <- c(11, 18, 9, 4, 7, 8, 5, 6, 12, 14, 16, 17, 15, 13, 19, 1, 10, 2, 3)
gen2 <- gen2[new_order,new_order]
ddRAD_gen <- gen2[-c(18,19), -c(18,19)]

gen <- quasieuclid(as.dist(ddRAD_gen))
geo <- quasieuclid(as.dist(ddRAD_dist))
plot(r1 <- mantel.randtest(geo,gen, nrepet = 10000), main = "Mantel test")
r1

library(ggplot2)
library(cowplot)
library(ggrepel)
library(lmodel2)

dim(ddRAD_dist)
dim(ddRAD_gen)
length(ddRAD_dist[lower.tri(ddRAD_dist)])
length(ddRAD_gen[lower.tri(ddRAD_gen)])

IBD <- data.frame(Fst = ddRAD_gen[lower.tri(ddRAD_gen)], Distance = ddRAD_dist[lower.tri(ddRAD_dist)]) %>% mutate(
  Group = c(rep("HR-HR", 8), rep("HR-ER", 8),
            rep("HR-HR", 7), rep("HR-ER", 8),
            rep("HR-HR", 6), rep("HR-ER", 8),
            rep("HR-HR", 5), rep("HR-ER", 8),
            rep("HR-HR", 4), rep("HR-ER", 8),
            rep("HR-HR", 3), rep("HR-ER", 8),
            rep("HR-HR", 2), rep("HR-ER", 8),
            rep("HR-HR", 1), rep("HR-ER", 8),
            rep("HR-ER", 8),
            rep("ER-ER", 28))
)
my.formula <- y ~ x
mod_neu = lmodel2(data=IBD, Fst ~ Distance, "interval", "interval", 95)
reg_neu = mod_neu$regression.results[which(mod_neu$regression.results$Method == "SMA"),]
names(reg_neu) = c("method", "intercept", "slope", "angle", "p-value")
reg_neu
ggplot(data = IBD, aes(x = Distance, y = Fst, color = Group)) +
  geom_point(size=2)+
  theme_bw() +
  theme(axis.title.y=element_text(size=15))+
  theme(axis.title.x=element_text(size=15))+
  theme(axis.text=element_text(size=15))+
  scale_y_continuous(name="Fst/(1-Fst)") +
  cowplot::theme_cowplot()+
  theme(panel.grid.major = element_line(color = "lightgrey",
                                        size = 0.1,
                                        linetype = "dashed"))+
  geom_abline(data = reg_neu, aes(intercept = intercept, slope = slope))

mean(gen2[18,-c(18,19)]) # FI1012
mean(gen2[19,-c(18,19)]) # FI1013a
mean(mean(gen2[18,-c(18,19)]),mean(gen2[19,-c(18,19)]))

range(gen2[18,-c(18,19)],gen2[19,-c(18,19)])

range(ddRAD_gen[ddRAD_gen>0])
