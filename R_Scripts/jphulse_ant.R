## Load in the datasets into one combined instance across versions of ant
files <- list.files("./data/ant", pattern=".csv", full.names=T)
combined <- do.call("rbind", lapply(files, read.csv))
data(combined)

library(dplyr)
## Place date into the correlation matrix
m <- data.matrix(sample_n(combined, nrow(combined)))


## Make a list of the correlation matrix of the matrix version of the dataset
## and the number of rows in the mattrix
suffStat <- list(C = cor(m), n = nrow(m))

## Place the collumn names in a list for the pc alg
varNames <- colnames(combined)

## Just does the first part of the PC alg and gets the skeleton/ancestor graph
## This is before the d-separation, takes parameters of the list of the 
## correlation matrix and the number of rows in the matrix
## an independence test, I used gaussCItest which was reccomended in the manual
## labels of the variable names and nodes, and an Alpha to prevent against type 1 errors
skel.gmG8 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

## Does the full PC algorithm, same parameters as the skeleton method
pc.gmG8 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

if(require(igraph)) {
  par(mfrow = c(1,1))
  
  plot(pc.gmG8, main = "Ant_*")
  ## iplot(pc.gmG8)  This is an alternative plotting scheme
  
  
}