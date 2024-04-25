# Performs a super-sample experiment on the Camel dataset (NOT USED IN PAPER)
library(pcalg)
library(dplyr)
data("camel-1.0")
varNames <- colnames(data)

cat(varNames, file="camel_super_VarNames.txt")
col <- ncol(data)

for(i in 0: 998) {
  m <- data.matrix(sample_n(data, nrow(data) * 10, replace = T))
  suffStat <- list(C = cor(m), n = nrow(m))
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("camel_super_", i, ".txt"), append=T)
    }
    
  }
  
}
