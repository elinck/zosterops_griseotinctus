library(ape)
library(phangorn)
library(tidyverse)
library(ggtree)

# read phylogeny
zosterops_raxml <- read.tree("~/Dropbox/zosterops_griseotinctus/zosterops_RAxML_bipartitions.tre")

# drop problematic sample
zosterops_raxml <- drop.tip(zosterops_raxml, "JF3087")

# fix sample name
zosterops_raxml$tip.label[7] <- "MACD10"

# read sample info
zosterops_info <- read_csv("~/Dropbox/zosterops_griseotinctus/samples.csv")

# merge tip labels and sample info, rename w/ locality
labels <- cbind.data.frame(1:length(zosterops_raxml$tip.label), zosterops_raxml$tip.label)
colnames(labels) <- c("order", "ID")
labels_df <- merge(labels, zosterops_info, by = "ID", all.x = TRUE)
labels_df$taxon <- gsub(". ", "_", labels_df$taxon)
labels_df$taxon <- gsub("\\.", "", labels_df$taxon)
labels_df$new_ID <- paste0(labels_df$ID, "_", labels_df$locality)
labels_df$new_ID <- paste0(labels_df$taxon, "_", labels_df$new_ID)
tip_labels <- labels_df[order(labels_df$order),]
tip_labels <- tip_labels$new_ID

# change tip labels on phylogeny
zosterops_raxml$tip.label <- tip_labels

# plot tree as ggtree object
zosterops_tree <- ggtree(zosterops_raxml) +
  geom_tiplab() +
  xlim(0,0.1)

# write to pdf
pdf("~/Dropbox/zosterops_griseotinctus/zosterops_griseotinctus_tree.pdf", width = 12, height = 8)
zosterops_tree
dev.off()