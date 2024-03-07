## Load libraries
library(pcalg)
library(dplyr)
## Read a file from the prop dataset and combine them as needed
combined <- read.csv("./data/prop/prop-1.csv")
## Reverse the column order, rows will be reshuffled randomly below
combinedR <- combined[, c(23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)]
combinedS.1.2 <- combined[, c(2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ,13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23)]

## Create the matrices
m <- data.matrix(sample_n(combined, nrow(combined)))
m.R <- data.matrix(sample_n(combinedR, nrow(combined)))
m.1.2 <- data.matrix(sample_n(combinedS.1.2, nrow(combined)))

suffStat <- list(C = cor(m), n = nrow(m))
suffStat.R <- list(C = cor(m.R), n = nrow(m.R))
suffStat.1.2 <- list(C = cor(m.1.2), n = nrow(m.1.2))

varNames <- colnames(combined)
varNames.R <- colnames(combinedR)
varNames.1.2 <- colnames(combinedS.1.2)

pc.norm <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01, skel.method="stable")

pc.R <- pc(suffStat.R, indepTest = gaussCItest, labels = varNames.R, alpha = .01, skel.method="stable")
pc.1.2 <- pc(suffStat.1.2, indepTest = gaussCItest, labels = varNames.1.2, alpha = .01, skel.method="stable")

if(require(igraph)) {
  par(mfrow = c(1,3))
  
 
  plot(pc.norm, main="ant_*, alpha.01, cols standard")
  plot(pc.R, main="All cols reversed")
  plot(pc.1.2, main="Swapped columns 1 and 2")
  
  
}