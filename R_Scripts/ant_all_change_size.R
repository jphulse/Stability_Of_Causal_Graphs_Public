## Load in the datasets into one combined instance across versions of ant
files <- list.files("./data/ant", pattern=".csv", full.names=T)
combined <- do.call("rbind", lapply(files, read.csv))
data(combined)

library(dplyr)
## Place date into the correlation matrix
m <- data.matrix(sample_n(combined, nrow(combined)))
m_2 <- data.matrix(sample_n(combined, nrow(combined) * 2, replace=T))
m_4 <- data.matrix(sample_n(combined, nrow(combined) * 4, replace=T))
m_8 <- data.matrix(sample_n(combined, nrow(combined) * 8, replace=T))
m_16 <- data.matrix(sample_n(combined, nrow(combined) * 16, replace=T))
m_32 <- data.matrix(sample_n(combined, nrow(combined) * 32, replace=T))

## Make a list of the correlation matrix of the matrix version of the dataset
## and the number of rows in the mattrix
suffStat <- list(C = cor(m), n = nrow(m))
suffStat_2 <- list(C = cor(m_2), n = nrow(m_2))
suffStat_4 <- list(C = cor(m_4), n = nrow(m_4))
suffStat_8 <- list(C = cor(m_8), n = nrow(m_8))
suffStat_16 <- list(C = cor(m_16), n = nrow(m_16))
suffStat_32 <- list(C = cor(m_32), n = nrow(m_32))




## Place the collumn names in a list for the pc alg
varNames <- colnames(combined)

a <- pc(suffStat, indepTest = gaussCItest, labels=varNames, alpha=.01)
a.2 <- pc(suffStat_2, indepTest = gaussCItest, labels=varNames, alpha=.01)
a.4 <- pc(suffStat_4, indepTest = gaussCItest, labels=varNames, alpha=.01)
a.8 <- pc(suffStat_8, indepTest = gaussCItest, labels=varNames, alpha=.01)
a.16 <- pc(suffStat_16, indepTest = gaussCItest, labels=varNames, alpha=.010)
a.32 <- pc(suffStat_32, indepTest = gaussCItest, labels=varNames, alpha=.01)

if(require(igraph)) {
  par(mfrow = c(2,3))
  
  plot(a, main = "Ant_*, normal size")
  plot(a.2, main="double size")
  plot(a.4, main="4X")
  plot(a.8, main="8X")
  plot(a.16, main="16X")
  plot(a.32, main="32X")
}