library(pcalg)
library(dplyr)
data("prop-1")
varNames <- colnames(data)

cat(varNames, file="prop_super_VarNames.txt")
col <- ncol(data)

for(i in 0: 998) {
  m <- data.matrix(sample_n(data, nrow(data) * 10, replace = T))
  suffStat <- list(C = cor(m), n = nrow(m))
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("prop_super_", i, ".txt"), append=T)
    }
    
  }
  
}
