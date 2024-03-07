library(pcalg)
library(dplyr)
data("ant-1.3")
varNames <- colnames(data)
m <- data.matrix(sample_n(data, nrow(data)))
suffStat <- list(C = cor(m), n = nrow(m))
cat(varNames, file="ant_alpha_VarNames.txt")
col <- ncol(data)

for(i in 0: 15) {
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01 + i / 100)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("ant_alpha_", i, ".txt"), append=T)
    }
    
  }
  
}
