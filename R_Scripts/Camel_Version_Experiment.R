# Performs the version experiment for the Camel SE dataset (please see paper for experimental alg)

library(dplyr)
library(pcalg)
data("camel-1.0")
col <- ncol(data)


library(dplyr)
## Place date into the correlation matrix
m.1 <- data.matrix(sample_n(data, nrow(data)))


## Make a list of the correlation matrix of the matrix version of the dataset
## and the number of rows in the mattrix
suffStat <- list(C = cor(m.1), n = nrow(m.1))

## Place the collumn names in a list for the pc alg
varNames <- colnames(data)


## Does the full PC algorithm, same parameters as the skeleton method
pc.1 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
for(j in 1: col) {
  for(k in pc.1@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("camel_versions_0",".txt"), append=T)
  }
  
}

## Load the second dataset
data("camel-1.2")

m.2 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.2), n = nrow(m.2))




pc.2 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.2@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("camel_versions_1",".txt"), append=T)
  }
  
}

## Load the third dataset
data("camel-1.4")

m.3 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.3), n = nrow(m.3))




pc.3 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.3@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("camel_versions_2",".txt"), append=T)
  }
  
}

## Load the third dataset
data("camel-1.6")

m.4 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.4), n = nrow(m.4))




pc.4 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.4@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("camel_versions_3",".txt"), append=T)
  }
  
}
cat(varNames, file="camel_versions_VarNames.txt")
print(pc.1@graph@edgeL)
