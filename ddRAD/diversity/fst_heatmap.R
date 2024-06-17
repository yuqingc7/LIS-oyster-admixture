#install_github("jokergoo/ComplexHeatmap")
#install.packages("dendsort")
library(export)
library(beanplot)
library(ggplot2)
library(hrbrthemes)
library(ComplexHeatmap)
library(circlize)
library(gplots)
library(dendsort)

setwd("/local/workdir/yc2644/CV_NYC_ddRAD/diversity")

dat1 <- read.delim("pairwise.pruned.fst.txt", header = TRUE, sep = "\t")
dat2 <- as.matrix(dat1)
rownames(dat2) <- colnames(dat2)
dat2

# need to rearrange the population orders (ER, HR, AQ)
new_order <- c(11, 18, 9, 4, 7, 8, 5, 6, 12, 14, 16, 17, 15, 13, 19, 1, 10, 2, 3)
dat2 <- dat2[new_order,new_order]

# rename AQ populations
rownames(dat2)[length(rownames(dat2))-1] <- "AQ_1A"
rownames(dat2)[length(rownames(dat2))] <- "AQ_1B"
colnames(dat2)[length(rownames(dat2))-1] <- "AQ_1A"
colnames(dat2)[length(rownames(dat2))] <- "AQ_1B"
dat2

write.matrix(dat2, file = "pairwise.pruned.fst.orderd.txt", sep = "\t")

fa = rep(c("Hudson River", "East River", "Aquaculture"), times = c(9,8,2))
fa_col = c("Hudson River" = "#FC8D62", "East River" = "#66C2A5", "Aquaculture" = "#8DA0CB")
dend1 = cluster_between_groups(dat2, fa)

annot = HeatmapAnnotation(Group = fa,col = list(Group = fa_col),
                        annotation_legend_param = list(
                                Group = list(title = "",
                                             nrow = 1)))

ht <- Heatmap(dat2, name = "Pairwise Fst",
        col = colorRamp2(c(0, 0.005,0.115), c("white", "skyblue", "orange")),
        rect_gp = gpar(col = "white", lwd = 2),
        cluster_rows = FALSE, 
        cluster_columns = FALSE,
        width = unit(14, "cm"), height = unit(8, "cm"),
        row_names_side = "left",
        row_names_gp = gpar(fontsize = 12),
        column_names_gp = gpar(fontsize = 12),
        column_names_rot = 45,
        top_annotation = annot)

draw(ht, merge_legend = F, heatmap_legend_side = "right", 
    annotation_legend_side = "top")


