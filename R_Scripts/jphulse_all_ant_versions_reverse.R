# Plots graphs generated from all ant datasets with column order reversed to see if it makes a difference in graph outputs
## Load the first dataset and reverse the columns
data("ant-1.3")
data <- data[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

library(dplyr)
## Place date into the correlation matrix
m <- data.matrix(sample_n(data, nrow(data)))


## Make a list of the correlation matrix of the matrix version of the dataset
## and the number of rows in the mattrix
suffStat <- list(C = cor(m), n = nrow(m))

## Place the collumn names in a list for the pc alg
varNames <- colnames(data)

## Just does the first part of the PC alg and gets the skeleton/ancestor graph
## This is before the d-separation, takes parameters of the list of the 
## correlation matrix and the number of rows in the matrix
## an independence test, I used gaussCItest which was reccomended in the manual
## labels of the variable names and nodes, and an Alpha to prevent against type 1 errors
skel.1.3 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

## Does the full PC algorithm, same parameters as the skeleton method
pc.1.3 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Load the second dataset and reverse the columns
data("ant-1.4")
data <- data[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

m <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m), n = nrow(m))

varNames <- colnames(data)

skel.1.4 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

pc.1.4 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Load the third dataset and reverse the columns
data("ant-1.5")
data <- data[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

m <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m), n = nrow(m))

varNames <- colnames(data)

skel.1.5 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

pc.1.5 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Load the fourth dataset and reverse the columns
data("ant-1.6")
data <- data[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

m <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m), n = nrow(m))

varNames <- colnames(data)

skel.1.6 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

pc.1.6 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Load the fifth dataset and reverse the columns
data("ant-1.7")
data <- data[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

m <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m), n = nrow(m))

varNames <- colnames(data)

skel.1.7 <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

pc.1.7 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

## Load in the datasets into one combined instance across versions of ant
files <- list.files("./data/ant", pattern=".csv", full.names=T)
combined <- do.call("rbind", lapply(files, read.csv))
data(combined)
combined <- combined[, c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]

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
skel.combined <- skeleton(suffStat, indepTest = gaussCItest, labels = varNames, alpha =.01)

## Does the full PC algorithm, same parameters as the skeleton method
pc.combined <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

if(require(igraph)) {
  par(mfrow = c(2,3))
  
  plot(pc.1.3, main = "Ant-1.3, alpha .01, all cols reversed ")
  plot(pc.1.4, main = "Ant-1.4")
  plot(pc.1.5, main="Ant-1.5")
  plot(pc.1.6, main="Ant-1.6")
  plot(pc.1.7, main = "Ant-1.7")
  plot(pc.combined, main="All ant versions combined, alpha .01,")
  ## iplot(pc.gmG8)  This is an alternative plotting scheme
  
  
}
