#setwd("/local/workdir/yc2644/CV_NYC_ddRAD/structure")
setwd("~/Github/LIS-oyster-admixture/ddRAD/structure")

library(RColorBrewer)
library(tidyverse)

str <- read_csv("n380_structure.csv")

q <- as.data.frame(str)[,3:4]
pop <- as.data.frame(str)[, 1:2]

ord <- c(1:380)


# labels <- c("Aquac1","Aquac2","PM","TPZ","IRV","HH0512a","HH1013a","HH1013s","HH812s","HH912s","PRA",
#             "SV0512a","SV1013a","SV812s","SV912s","WFM","RI","AB","NTC")

labels <- c("AQ_1A","AQ_1B","1","2","3","HH0512a","HH1013a","HH1013s","HH812s","HH912s","5",
            "SV0512a","SV1013a","SV812s","SV912s","2","3","4","5")

barplot(t(q)[,ord], col=c("#FFFF99", "#B15928"), space=0, border=NA, 
        #xlab="Population Sample", 
        #ylab = "Admixture proportions for K=2", 
        #cex.lab = 2, 
        cex.axis = 1.5)
text(sort(tapply(1:380, pop[,1], mean)), -0.12, labels=labels, xpd=T, srt=45, cex=2)
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1.2)

brewer.pal(n=12, name = "Paired")
