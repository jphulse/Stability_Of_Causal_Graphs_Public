## Read a file from the prop dataset and combine them as needed
combined <- read.csv("./data/prop/prop-1.csv")
## Reverse the column order, rows will be reshuffled randomly below
reverse <- combined[, c(23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]
library(dplyr)
## Place data into the correlation matrix
m <- data.matrix(sample_n(combined, nrow(combined)))
r <- data.matrix(sample_n(reverse, nrow(reverse)))

## Create a list of the correlation matrix and the number of rows 
suffStat = list(C = cor(m), n=nrow(m))
rSuffStat = list(C = cor(r), n=nrow(r))

varNames <- colnames(combined)
rNames <- colnames(reverse)




## Make the skeleton for making an image of the ancestor graph of undirected edges
skel.prop <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)
skel.r <- skeleton(rSuffStat, indepTest = gaussCItest, labels = rNames, alpha =.01)


## Outputs the causal graph structure using gaussCItest, suffstat, the labels, and an alpha of .01
pc.prop <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.r <- pc(rSuffStat, indepTest = gaussCItest, labels = rNames, alpha =.01)


## Plot the graph
if(require(igraph)) {
  par(mfrow = c(2,1))
  
  plot(pc.prop, main = "prop-1, alpha .01, rows randomly shuffled and columns default")
  plot(pc.r, main = "prop-1, alpha .01, rows random, columns reversed")
  
  
  
}