library(dplyr)
library(pcalg)
data("xerces-1.2")
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
    cat(paste(k, "\n"),  file=paste0("xerces_versions_0",".txt"), append=T)
  }
  
}

## Load the second dataset
data("xerces-1.3")

m.2 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.2), n = nrow(m.2))




pc.2 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.2@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("xerces_versions_1",".txt"), append=T)
  }
  
}

## Load the third dataset
data("xerces-1.4")

m.3 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.3), n = nrow(m.3))




pc.3 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.3@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("xerces_versions_2",".txt"), append=T)
  }
  
}


cat(varNames, file="xerces_versions_VarNames.txt")
print(pc.1@graph@edgeL)
