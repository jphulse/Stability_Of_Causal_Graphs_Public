# Propogates and plots the graph generated from the Prop datasets
files <- list.files("./data/prop", pattern=".csv", full.names=T)
combined <- do.call("rbind", lapply(files, read.csv))

library(dplyr)
## Place date into the correlation matrix
m <- data.matrix(sample_n(combined, nrow(combined)))


## Create a list of the correlation matrix and the number of rows 
suffStat = list(C = cor(m), n=nrow(m))

varNames <- colnames(combined)


## Make the skeleton for making an image of the ancestor graph of undirected edges
skel.prop <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

## Outputs the causal graph structure using gaussCItest, suffstat, the labels, and an alpha of .01
pc.prop <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Plot the graph
if(require(igraph)) {
  par(mfrow = c(1,1))
  
  plot(pc.prop, main = "Prop-*, alpha .01, rows randomly shuffled")
  
  
  
}

