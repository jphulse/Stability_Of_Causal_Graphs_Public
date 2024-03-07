## Read a file from the prop dataset and combine them as needed
combined <- read.csv("./data/prop/prop-1.csv")
## Reverse the column order, rows will be reshuffled randomly below
combined <- combined[, c(23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]
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
  
  plot(skel.prop, main = "prop-1, alpha .01, rows randomly shuffled and columns reversed (Skeleton)")
  
  
  
}