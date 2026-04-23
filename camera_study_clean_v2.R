# Description: Camera Study (Huffman and Frazier)
# Author: Jessene Aquino-Thomas
# Date: 13/Jun/2022
# Last Edited: 2/Feb/2023
# Cleaned and organized for GitHub: 23/Apr/2026
# Output: R file

# Load Libraries 
library(tidyverse)
library(ggthemes)
library(scales)
library(zoo)
library(vegan)
library(BiodiversityR)
library(VennDiagram) 
library(ggThemeAssist)
library(betapart)
library(adespatial)

# Import csv file 
# Remember to update the csv to the new Quarter 
camera_all <- read.csv(file = "Camera Study.csv")

# Checking that data imported correctly 
head(camera_all)
str(camera_all)
View(camera_all)
colnames(camera_all)

# Changing column name to something easier to type
names(camera_all)[names(camera_all) == 'ï..Site'] <- "site"
colnames(camera_all)

# making it a character
camera_all$Cam.Num <- as.character(as.integer(camera_all$Cam.Num))
camera_all$Num.of.Indiv <- as.character(camera_all$Num.of.Indiv)
camera_all$Year <- as.character(as.integer(camera_all$Year))

#combine site and habitat into one column
camera_all$site.habitat <- paste(camera_all$site, camera_all$Habitat.type, 
                                 sep = "/")
# making site a factor
camera_all$site <- as.factor(camera_all$site)
# making site/habitat a factor
camera_all$site.habitat <- as.factor(camera_all$site.habitat)

#combine month and year into one column 
camera_all$Month <- as.integer(factor(camera_all$Month, levels = month.name))
camera_all$month.year <- as.yearmon(paste(camera_all$Year, 
                                          camera_all$Month), "%Y %m")
str(camera_all)
tail(camera_all)
View(camera_all)

# species table only
camera_all_species <- camera_all[ ,13:57]
colnames(camera_all_species)

# no gopher tortoise 
camera_no_GT <- camera_all[camera_all$GT != 1, ]   
camera_no_GT <- camera_no_GT[ ,-40] 
species_no_GT <- camera_no_GT[ ,-9]

str(camera_no_GT)
colnames(camera_no_GT)

# =============================================================================
# DIVERSITY INDICES
# =============================================================================

#Gamma
diversityresult(camera_all_species, index = "richness", method = "pooled")

diversityresult(species_no_GT[sapply(species_no_GT, is.numeric)], 
                index = "richness", method = "pooled")

#Alpha for sites
# species number by group/site
specnumber(camera_all_species, groups = camera_all$site)
specnumber(camera_all_species, groups = camera_all$site.habitat)

# no GT
specnumber(species_no_GT[sapply(species_no_GT, is.numeric)], groups = species_no_GT$site.habitat)

# =============================================================================
# SPECIES ACCUMULATION CURVES
# =============================================================================

accumcomp(camera_all_species, y = camera_all, factor = "site.habitat", 
          plotit = TRUE, xlim = c(0,3350), xlab = "Observations", 
          ylab = "Species Richness")

# make and change the theme
BioR.theme <- theme(
  panel.background = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.line = element_line("gray25"),
  text = element_text(size = 12, family = "Arial"),
  axis.text = element_text(size = 10, colour = "gray25"),
  axis.title = element_text(size = 14, colour = "gray25"),
  legend.title = element_text(size = 14),
  legend.text = element_text(size = 14),
  legend.key = element_blank())

extrafont::loadfonts(device = "win")

accum <- accumcomp(camera_all_species, y = camera_all, factor = "site.habitat", 
          method = "exact", conditioned = FALSE, plotit = FALSE)

accum.long1 <- accumcomp.long(accum, ci = NA, label.freq = 5)

plotaccum <- ggplot(data = accum.long1, aes(x = Sites, y = Richness, ymax = UPR, 
                               ymin = LWR)) +
  scale_x_continuous(expand = c(0,1), sec.axis = dup_axis(labels = NULL,
                                                          name = NULL)) +
  scale_y_continuous(sec.axis = dup_axis(labels = NULL, name = NULL)) +
  geom_line(aes(color = Grouping), size = 2) +
  geom_point(data = subset(accum.long1, labelit == TRUE),
             aes(color = Grouping, shape = Grouping), size = 5) +
  geom_ribbon(aes(color = Grouping), alpha = 0.2, show.legend = FALSE) +
  BioR.theme +
  scale_color_grey() +
  theme(legend.position = c(0.87, 0.25)) +
  labs(x = "Observations", y = "Species Richness", color = "Sites", shape = "Sites")

print(plotaccum)

# without GT
accum <- accumcomp(species_no_GT[sapply(species_no_GT, is.numeric)], 
                   y = species_no_GT, factor = "site.habitat", 
                   method = "exact", conditioned = FALSE, plotit = FALSE)

accum.long1 <- accumcomp.long(accum, ci = NA, label.freq = 5)

plotaccum <- ggplot(data = accum.long1, aes(x = Sites, y = Richness, ymax = UPR, 
                                            ymin = LWR)) +
  scale_x_continuous(expand = c(0,1), sec.axis = dup_axis(labels = NULL,
                                                          name = NULL)) +
  scale_y_continuous(sec.axis = dup_axis(labels = NULL, name = NULL)) +
  geom_line(aes(color = Grouping), size = 2) +
  geom_point(data = subset(accum.long1, labelit == TRUE),
             aes(color = Grouping, shape = Grouping), size = 5) +
  geom_ribbon(aes(color = Grouping), alpha = 0.2, show.legend = FALSE) +
  scale_color_grey() +
  theme(legend.position = c(0.87, 0.25)) +
  labs(x = "Observations", y = "Species Richness", color = "Sites", shape = "Sites")

print(plotaccum)

diversityresult(species_no_GT[sapply(species_no_GT, is.numeric)], index = "chao")

# =============================================================================
# SHANNON DIVERSITY
# =============================================================================

# the month is int still for the first one
richness <- diversitycomp(camera_all[sapply(camera_all, is.numeric)], 
                          y = camera_all, factor1 = "site.habitat", 
                          index = "richness", method = "pooled")

richness <- diversitycomp(species_no_GT[sapply(species_no_GT, is.numeric)], 
                          y = species_no_GT, factor1 = "site.habitat", 
                          index = "richness", method = "pooled")

S <- diversitycomp(camera_all[sapply(camera_all, is.numeric)], y = camera_all, 
              factor1 = "site.habitat", index = "Simpson", method = "pooled")

H <- diversitycomp(camera_all[sapply(camera_all, is.numeric)], y = camera_all, 
                   factor1 = "site.habitat", index = "Shannon",
                   method = "pooled")

diversitycomp(species_no_GT[sapply(species_no_GT, is.numeric)], 
              y = species_no_GT, 
              factor1 = "site.habitat", index = "Shannon",
              method = "pooled")

diversitycomp(species_no_GT[sapply(species_no_GT, is.numeric)], 
              y = species_no_GT, 
              factor1 = "site.habitat", index = "chao",
              method = "pooled")

# Shannon diversity values for plotting
h_all <- H$Shannon  # with GT included
h_no_GT <- diversitycomp(species_no_GT[sapply(species_no_GT, is.numeric)], 
                         y = species_no_GT, 
                         factor1 = "site.habitat", index = "Shannon",
                         method = "pooled")$Shannon

#tables for each site/habitat area 
FAU.Grass <- camera_all[camera_all$site.habitat %in% c('FAU/Grass'), ]
FAU.Scrub <- camera_all[camera_all$site.habitat %in% c('FAU/Scrub'), ]
JDSP.Scrub <- camera_all[camera_all$site.habitat %in% c('JDSP/Scrub'), ]
PJP.Pine <- camera_all[camera_all$site.habitat %in% c('PJP/Pine'), ]

# no GT versions
FAU.Grass.noGT <- species_no_GT[species_no_GT$site.habitat %in% c('FAU/Grass'), ]
FAU.Scrub.noGT <- species_no_GT[species_no_GT$site.habitat %in% c('FAU/Scrub'), ]
JDSP.Scrub.noGT <- species_no_GT[species_no_GT$site.habitat %in% c('JDSP/Scrub'), ]
PJP.Pine.noGT <- species_no_GT[species_no_GT$site.habitat %in% c('PJP/Pine'), ]

# =============================================================================
# SPECIES PLOTS BY SITE  
# =============================================================================

# New facet label names for sites
site.labs <- c("FAU Grass", "FAU Scrub", "Johnathan Dickinson", "Pine Jog")
names(site.labs) <- c("FAU/Grass", "FAU/Scrub", "JDSP/Scrub", "PJP/Pine")

# defining the sites to include before using the filter operation 
sites_to_include <- c("FAU/Grass", "FAU/Scrub", "JDSP/Scrub", "PJP/Pine")

# FAU Grass species 
camera_all_species.FG <- camera_all[ ,13:58] %>% 
  filter(site.habitat == "FAU/Grass")
colnames(camera_all)
colnames(camera_all_species.FG)

# sum the observations for each species/column for the site 
colsumspecies.FG <- colSums(camera_all_species.FG[sapply(camera_all_species.FG, 
                                                         is.numeric)])
# making into data frame 
colsumspecies.FG <- as.data.frame(colsumspecies.FG)
# rename the column 
colsumspecies.FG <- colsumspecies.FG %>% 
  rename(observations = "colsumspecies.FG")
#changing the column name and turning into the the tidyverse tibble 
colsumspecies.FG <- tibble::rownames_to_column(colsumspecies.FG, "Species")

str(colsumspecies.FG)

# plot the graph 
# Reorder following the value of another column:
colsumspecies.FG[which(colsumspecies.FG$observations > 0), ] %>%
  mutate(Species = fct_reorder(Species, desc(observations))) %>%
  ggplot(aes(x = Species, y = observations)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.6, width = 0.4) +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  geom_text(aes(label = observations), vjust = -0.3, size = 3.5) +
  ggtitle("FAU Grass") +
  xlab("") +
  ylab("Number Observed") + 
  theme(axis.title.x = element_text(size = 14, face = "bold", 
                                    margin = margin(t = 10))) +
  theme(axis.title.y = element_text(size = 14, face = "bold", 
                                    margin = margin(r = 10))) +
  theme(strip.text.x = element_text(size = 18, face = "bold")) +
  theme(legend.title = element_blank()) +
  expand_limits(y = c(0, 2400)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 

# FAU Scrub species 
camera_all_species.FS <- camera_all[ ,13:58] %>% 
  filter(site.habitat == "FAU/Scrub")

# sum the observations for each species/column for the site 
colsumspecies.FS <- colSums(camera_all_species.FS[sapply(camera_all_species.FS, 
                                                         is.numeric)])
# making into data frame 
colsumspecies.FS <- as.data.frame(colsumspecies.FS)
#changing the column name and turning into the the tidyverse tibble 
colsumspecies.FS <- tibble::rownames_to_column(colsumspecies.FS, "Species")
# rename the column 
colsumspecies.FS <- colsumspecies.FS %>% 
  rename(observations = "colsumspecies.FS")

# plot the graph 
colsumspecies.FS[which(colsumspecies.FS$observations > 0), ] %>%
  mutate(Species = fct_reorder(Species, desc(observations))) %>%
  ggplot(aes(x = Species, y = observations)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.6, width = 0.4) +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  geom_text(aes(label = observations), vjust = -0.3, size = 3.5) +
  ggtitle("FAU Scrub") +
  xlab("") +
  ylab("Number Observed") + 
  theme(axis.title.x = element_text(size = 14, face = "bold", 
                                    margin = margin(t = 10))) +
  theme(axis.title.y = element_text(size = 14, face = "bold", 
                                    margin = margin(r = 10))) +
  theme(strip.text.x = element_text(size = 18, face = "bold")) +
  theme(legend.title = element_blank()) +
  expand_limits(y = c(0, 1020)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 

# JDSP Scrub species 
camera_all_species.JS <- camera_all[ ,13:58] %>% 
  filter(site.habitat == "JDSP/Scrub")

# sum the observations for each species/column for the site 
colsumspecies.JS <- colSums(camera_all_species.JS[sapply(camera_all_species.JS, 
                                                         is.numeric)])
# making into data frame 
colsumspecies.JS <- as.data.frame(colsumspecies.JS)
#changing the column name and turning into the the tidyverse tibble 
colsumspecies.JS <- tibble::rownames_to_column(colsumspecies.JS, "Species")
# rename the column 
colsumspecies.JS <- colsumspecies.JS %>% 
  rename(observations = "colsumspecies.JS")

# plot the graph 
colsumspecies.JS[which(colsumspecies.JS$observations > 0), ] %>%
  mutate(Species = fct_reorder(Species, desc(observations))) %>%
  ggplot(aes(x = Species, y = observations)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.6, width = 0.4) +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  geom_text(aes(label = observations), vjust = -0.3, size = 3.5) +
  ggtitle("Johnathan Dickinson") +
  xlab("") +
  ylab("Number Observed") + 
  theme(axis.title.x = element_text(size = 14, face = "bold", 
                                    margin = margin(t = 10))) +
  theme(axis.title.y = element_text(size = 14, face = "bold", 
                                    margin = margin(r = 10))) +
  theme(strip.text.x = element_text(size = 18, face = "bold")) +
  theme(legend.title = element_blank()) +
  expand_limits(y = c(0, 1280)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 

# PJP Pine species 
camera_all_species.PP <- camera_all[ ,13:58] %>% 
  filter(site.habitat == "PJP/Pine")

# sum the observations for each species/column for the site 
colsumspecies.PP <- colSums(camera_all_species.PP[sapply(camera_all_species.PP, 
                                                         is.numeric)])
# making into data frame 
colsumspecies.PP <- as.data.frame(colsumspecies.PP)
#changing the column name and turning into the the tidyverse tibble 
colsumspecies.PP <- tibble::rownames_to_column(colsumspecies.PP, "Species")
# rename the column 
colsumspecies.PP <- colsumspecies.PP %>% 
  rename(observations = "colsumspecies.PP")

# plot the graph 
colsumspecies.PP[which(colsumspecies.PP$observations > 0), ] %>%
  mutate(Species = fct_reorder(Species, desc(observations))) %>%
  ggplot(aes(x = Species, y = observations)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.6, width = 0.4) +
  scale_x_discrete(guide = guide_axis(angle = 90)) +
  geom_text(aes(label = observations), vjust = -0.3, size = 3.5) +
  ggtitle("Pine Jog") +
  xlab("") +
  ylab("Number Observed") + 
  theme(axis.title.x = element_text(size = 14, face = "bold", 
                                    margin = margin(t = 10))) +
  theme(axis.title.y = element_text(size = 14, face = "bold", 
                                    margin = margin(r = 10))) +
  theme(strip.text.x = element_text(size = 18, face = "bold")) +
  theme(legend.title = element_blank()) +
  expand_limits(y = c(0, 1400)) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 

# =============================================================================
# PREPARE WIDE FORMAT DATA
# =============================================================================

# reorganizes datasheet wide
colsumspecies.FG_wide <- colsumspecies.FG %>% 
  pivot_wider(names_from = "Species", 
              values_from = "observations") 
# adding site name 
colsumspecies.FG_wide <- colsumspecies.FG_wide %>%
  add_column(site = "FG", .before = "BasiliskLizard")

# reorganizes datasheet wide
colsumspecies.FS_wide <- colsumspecies.FS %>% 
  pivot_wider(names_from = "Species", 
              values_from = "observations") 
# adding site name 
colsumspecies.FS_wide <- colsumspecies.FS_wide %>%
  add_column(site = "FS", .before = "BasiliskLizard")

# reorganizes datasheet wide
colsumspecies.JS_wide <- colsumspecies.JS %>% 
  pivot_wider(names_from = "Species", 
              values_from = "observations") 
# adding site name 
colsumspecies.JS_wide <- colsumspecies.JS_wide %>%
  add_column(site = "JS", .before = "BasiliskLizard")

# reorganizes datasheet wide
colsumspecies.PP_wide <- colsumspecies.PP %>% 
  pivot_wider(names_from = "Species", 
              values_from = "observations") 
# adding site name 
colsumspecies.PP_wide <- colsumspecies.PP_wide %>%
  add_column(site = "PP", .before = "BasiliskLizard")

colsumspecies.wide <- bind_rows(colsumspecies.FG_wide, colsumspecies.FS_wide,
                                colsumspecies.JS_wide, colsumspecies.PP_wide)

View(colsumspecies.wide)

#converts from abundance to P/A
pa.colsumspecies.wide <- colsumspecies.wide %>% 
  mutate_if(is.numeric, ~1 * (. > 0))

View(pa.colsumspecies.wide)

# =============================================================================
# VENN DIAGRAM
# =============================================================================

#identity of species present for each site
species.FG <- which(colsumspecies.FG_wide > 0, arr.ind = TRUE)
species.FG <- species.FG[-1, -1]

species.FS <- which(colsumspecies.FS_wide > 0, arr.ind = TRUE)
species.FS <- species.FS[-1, -1]

species.JS <- which(colsumspecies.JS_wide > 0, arr.ind = TRUE)
species.JS <- species.JS[-1, -1]

species.PP <- which(colsumspecies.PP_wide > 0, arr.ind = TRUE)
species.PP <- species.PP[-1, -1]

# creating the function
display_venn <- function(x, ...){
  library(VennDiagram)
  grid.newpage()
  venn_object <- venn.diagram(x, filename = NULL, ...)
  grid.draw(venn_object)
}

#pops up in the plot section
display_venn(
  list(species.FG, species.FS, species.JS, species.PP),
  main = "All Species",
  main.pos = c(0.5, 1.0),
  main.cex = 2,
  category.names = c("FAU Grass", "FAU Scrub", "Johnathan Dickinson", 
                     "Pine Jog"),
  fill = c("yellow", "red", "cyan", "forestgreen"),
  cex = 1.5)

# Chart saves to file 
venn.diagram(
  x = list(species.FG, species.FS, species.JS, species.PP),
  filename = 'venn_diagramm.png',
  main = "All Species",
  main.pos = c(0.5, 1.0),
  main.cex = 2,
  category.names = c("FAU Grass", "FAU Scrub", "Johnathan Dickinson", 
                     "Pine Jog"),
  fill = c("yellow", "red", "cyan", "forestgreen"),
  cex = 1.5)

# =============================================================================
# BETA DIVERSITY ANALYSIS
# =============================================================================

### calculate beta diversity 
bd <- beta.div(pa.colsumspecies.wide[ ,-1], method = "sorensen", sqrt.D = "FALSE")
# Which are the significant LCBD indice
signif <-  which(bd$p.LCBD <= 0.05)
nonsignif <-  which(bd$p.LCBD > 0.05)

# calculate beta diversity components for Sorensen 
BDLG_dec <- beta.div.comp(pa.colsumspecies.wide[ ,-1], coef = "S")
BDLG_dec$part

# calculate the local contribution to beta diversity
# replacement/Turnover
local.repl <- LCBD.comp(BDLG_dec$repl, sqrt.D = TRUE)
local.repl

# Difference/nestedness 
local.rich <- LCBD.comp(BDLG_dec$rich, sqrt.D = TRUE)
local.rich

# make data fame for the plot of nestedness and turnover 
site <- c("FG", "FS", "JS", "PP")
group <- c("turnover/replacement", "turnover/replacement", 
           "turnover/replacement", "turnover/replacement", 
           "nestednes/richnesss", "nestednes/richnesss", 
           "nestednes/richnesss", "nestednes/richnesss")
value <- c(local.repl$LCBD, -local.rich$LCBD)  # negative for nestedness
turnover <- local.repl$LCBD
nestedness <- local.rich$LCBD

df <- data.frame(site, turnover, nestedness)
df2 <- data.frame(site, group, value)

print(df)
print(df2)

# beta diversity partitioning plot 
ggplot(df2, aes(x = site, y = value, fill = group)) +
  geom_bar(stat = "identity",position = "identity",
           show.legend = TRUE,
           color = "white") +
  geom_text(aes(label = round(value, 3),
                hjust = ifelse(value < 0, 1.5, -0.5)),
                vjust = 0.5,
            size = 3) +
  geom_hline(yintercept = 0, color = 1, lwd = 0.2) +
  xlab("Site") +
  ylab(expression(paste(beta))) + 
  scale_y_continuous(labels = abs, limits = c(min(df2$value) - 0.12,
                                max(df2$value) + 0.15)) +
  theme_bw() + 
  coord_flip()  + 
  theme(legend.position = "bottom") +
  theme(legend.title=element_blank())

#calculate species contribution to beta diversity
scbd <- beta.div(colsumspecies.wide[ ,-1], method = "hellinger")
scbd
# Which are the significant LCBD indice
signif <-  which(scbd$p.LCBD <= 0.05)
nonsignif <-  which(scbd$p.LCBD > 0.05)
# what is the average contribution to beta diversity 
mean(scbd$SCBD)
min(scbd$SCBD)
max(scbd$SCBD)
sp.ab.mean <- which(scbd$SCBD > mean(scbd$SCBD))
sp.ab.median <- which(scbd$SCBD > median(scbd$SCBD))

# plot of the effect on beta diversity largest effect on beta diversity 
colnames(colsumspecies.wide)

BDRB <- beta.div(colsumspecies.wide[ ,-1], method = "hellinger")
RBSCBD = data.frame(BDRB$SCBD)
RBSCBD <- as_tibble(rownames_to_column(RBSCBD, var = "SPECIES"))
abun <- RBSCBD[c(8, 16, 17, 18, 20, 25, 33, 34, 38, 39), ]
ggplot(abun, aes(x = SPECIES, y = BDRB.SCBD)) + 
  geom_bar(aes(fill = SPECIES), stat = "identity") +
  scale_y_continuous(breaks = 0:10) +
  coord_polar() + 
  scale_fill_grey() +
  labs(x = "", y = "") +
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank() 
  ) 

print("Analysis complete!")
