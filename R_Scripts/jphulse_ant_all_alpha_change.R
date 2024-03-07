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

a.001 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.001)
a.01 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.01)
a.02 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.02)
a.05 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.05)
a.10 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.10)
a.50 <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.50)

if(require(igraph)) {
  par(mfrow = c(2,3))
  
  plot(a.001, main = "Ant_*, alpha .001")
  plot(a.01, main="alpha .01")
  plot(a.02, main="alpha .02")
  plot(a.05, main="alpha .05")
  plot(a.10, main="alpha .10")
  plot(a.50, main="alpha .50")
}

print(5 %/%2 )