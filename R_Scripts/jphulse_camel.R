# Propogates and plots the graph generated from the camel datasets
## Read the files from the camel dataset and combine them as needed
files <- list.files("./data/camel", pattern=".csv", full.names=T)
combined <- do.call("rbind", lapply(files, read.csv))
data(combined)

library(dplyr)
## Place date into the correlation matrix
m <- data.matrix(sample_n(combined, nrow(combined)))

## Create a list of the correlation matrix and the number of rows 
suffStat = list(C = cor(m), n = nrow(combined))

## Make the skeleton for making an image of the ancestor graph of undirected edges
skel.cam <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

## Outputs the causal graph structure using gaussCItest, suffstat, the labels, and an alpha of .01
pc.cam <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Plot the graph
if(require(igraph)) {
  par(mfrow = c(1,1))
  
  plot(pc.cam, main = "Camel-*, alpha = .01, rows randomly shuffled")
  
  
  
}
