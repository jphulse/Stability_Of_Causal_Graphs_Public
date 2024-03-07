library(dplyr)
library(pcalg)
data("prop-1")
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
    cat(paste(k, "\n"),  file=paste0("prop_versions_0",".txt"), append=T)
  }
  
}

## Load the second dataset
data("prop-2")

m.2 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.2), n = nrow(m.2))




pc.2 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.2@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("prop_versions_1",".txt"), append=T)
  }
  
}

## Load the third dataset
data("prop-3")

m.3 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.3), n = nrow(m.3))




pc.3 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)

for(j in 1: col) {
  for(k in pc.3@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("prop_versions_2",".txt"), append=T)
  }
  
}
## Load the fourth dataset
data("prop-4")

m.4 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.4), n = nrow(m.4))


pc.4 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
for(j in 1: col) {
  for(k in pc.4@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("prop_versions_3",".txt"), append=T)
  }
  
}

## Load the fifth dataset
data("prop-5")

m.5 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.5), n = nrow(m.5))


pc.5 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
for(j in 1: col) {
  for(k in pc.5@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("prop_versions_4",".txt"), append=T)
  }
  
}

## Load the fifth dataset
data("prop-6")

m.6 <- data.matrix(sample_n(data, nrow(data)))

suffStat <- list(C = cor(m.6), n = nrow(m.6))


pc.6 <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
for(j in 1: col) {
  for(k in pc.6@graph@edgeL[j]) {
    cat(paste(k, "\n"),  file=paste0("prop_versions_5",".txt"), append=T)
  }
  
}
cat(varNames, file="prop_versions_VarNames.txt")
print(pc.1@graph@edgeL)
