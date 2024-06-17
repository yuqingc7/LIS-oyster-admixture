setwd("/local/workdir/yc2644/CV_NYC_ddRAD/structure")

library(RColorBrewer)
library(tidyverse)
library(grid)

str <- read_csv("n380_structure.csv") # P2 = aquaculture 

str_plot <- str %>% dplyr::select(Group, P2) %>% 
  mutate(location = c(rep("Aquaculture",27), 
                      rep("Hudson River",189), 
                      rep("East River",164)))


# distribution for 3 pops -------------------------------------------------

plot_list <- list()
location_list = c("Aquaculture", "Hudson River", "East River")

plot_list[[1]] <- str_plot %>% filter(location == location_list[[1]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
    geom_histogram(color = "black", fill="white", binwidth = 0.001)+
    scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
    coord_cartesian(xlim = c(0,1))+ 
    theme_classic()

plot_list[[2]] <- str_plot %>% filter(location == location_list[[2]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
    geom_histogram(color = "black", fill="white", binwidth = 0.001)+
    scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
    coord_cartesian(xlim = c(0,1))+ 
    theme_classic()

plot_list[[3]] <- str_plot %>% filter(location == location_list[[3]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
  geom_histogram(color = "black", fill="white", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,1))+
  theme_classic()

  #facet_grid(location ~ .) +

grid.arrange(grobs=plot_list, nrow=3)

# distribution for 2 wild pops, zoomed in -------------------------------------------------

plot_list <- list()
location_list = c("Aquaculture", "Hudson River", "East River")

plot_list[[1]] <- str_plot %>% filter(location == location_list[[2]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#66C2A5", fill="#66C2A5", binwidth = 0.01)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,0.3))+
  labs(title="Hudson River Native Populations",x="",y="") + 
  theme_classic()

plot_list[[2]] <- str_plot %>% filter(location == location_list[[3]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#FC8D62", fill="#FC8D62", binwidth = 0.01)+
  scale_y_continuous(labels = scales::percent, limits = c(-0.01,0.6)) +
  coord_cartesian(xlim = c(0,0.3))+
  labs(title="East River Native Populations",x="",y="") + 
  theme_classic()

grid.arrange(grobs=plot_list, nrow=2, 
             top=textGrob("Aquaculture Assignment Rate Q by STRUCTURE, ddRAD data", 
                          gp=gpar(fontsize=15,font=8)),
             left="Frequency")

# distribution for admixed wild pops, zoomed in -------------------------------------------------

location_list = c("Aquaculture", "Hudson River", "East River")

str_plot %>% filter(location == location_list[[3]]) %>% 
  ggplot(aes(x=P2, y=after_stat(count/sum(count))))+
  geom_histogram(color = "#FC8D62", fill="#FC8D62", binwidth = 0.001)+
  scale_y_continuous(labels = scales::percent, limits = c(0,0.25)) +
  coord_cartesian(xlim = c(0,0.3))+
  labs(title="East River Native Populations, ddRAD data",
       x ="Aquaculture Assignment Rate Q by STRUCTURE", y = "Frequency") + 
  theme_classic()
  


# summary by pops  -------------------------------------------------
str_sum_by_pop <- str %>% dplyr::select(Group, P2) %>% 
  group_by(Group) %>% 
  summarise(count = n(), mean = mean(P2), var = var(P2)) %>% 
  ungroup() %>% 
  arrange(mean) %>% 
  mutate(location = c(rep("Hudson River",9), rep("East River",8), rep("Aquaculture",2)))

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

# structure plot  -------------------------------------------------
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
abline(v=cumsum(sapply(unique(pop[ord,1]),function(x){sum(pop[ord,1]==x)})),col=1,lwd=1)

brewer.pal(n=12, name = "Paired")

# ordered structure plot  -------------------------------------------------
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
        plot.title = element_text(size = 16))

# ordered structure plot by group  -------------------------------------------------

str_ord_long <- str %>% 
  mutate(location = c(rep("Aquaculture",27), 
                      rep("Hudson River",189), 
                      rep("East River",164))) %>% 
  arrange(location, desc(P2)) %>% 
  mutate(Ind = 1:380) %>% 
  pivot_longer(cols = c("P1", "P2"), names_to = "Source", values_to = "Q") 

ggplot(str_ord_long, aes(x = Ind, y=Q, fill=Source)) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99", "#B15928"),
                    labels = c("Native", "Aquaculture")) +
  geom_vline(xintercept = c(27.5, 191.5)) +
  scale_x_continuous(breaks = c(13, 110, 290), 
                     labels = c("AQ_1", "East River", "Hudson River"), 
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="ddRAD data: Assignment Rate Q by STRUCTURE")+
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12),
        plot.title = element_text(size = 16))
  
# ordered structure plot (SV and HH)  -------------------------------------------------
str_ord_long_filtered <- str %>% 
  mutate(location = c(rep("Aquaculture",27), 
                      rep("Hudson River",189), 
                      rep("East River",164))) %>% 
  filter(str_detect(Group, "FI1012|SV0512a|HH1013a")) %>% 
  arrange(location, desc(P2)) %>% 
  mutate(Ind = 1:55) %>% 
  pivot_longer(cols = c("P1", "P2"), names_to = "Source", values_to = "Q") 

ggplot(str_ord_long_filtered, aes(x = Ind, y=Q, fill=Source)) +
  geom_col(position = position_stack(), width=1) +
  scale_fill_manual(values = c("#FFFF99", "#B15928"),
                    labels = c("Native", "Aquaculture")) +
  geom_vline(xintercept = c(13.5, 33.5)) +
  scale_x_continuous(breaks = c(6, 24, 45), 
                     labels = c("AQ_1A", "SV0512a", "HH1013a"), 
                     expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x="", y="", title="ddRAD data: Assignment Rate Q by STRUCTURE")+
  theme_classic()+
  theme(axis.ticks.x = element_blank(),
        legend.title = element_blank(),
        axis.text = element_text(color="black", size=12),
        legend.text = element_text(color="black", size=12))

