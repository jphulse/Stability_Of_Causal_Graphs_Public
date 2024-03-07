library(pcalg)
library(dplyr)
data("prop-1")
varNames <- colnames(data)

cat(varNames, file="prop_sub_10_VarNames.txt")
col <- ncol(data)

for(i in 0: 20) {
  ## Take a random sample of 90 % of the data
  m <- data.matrix(sample_n(data, 16623))
  suffStat <- list(C = cor(m), n = nrow(m))
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .1)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("prop_sub_10_", i, ".txt"), append=T)
    }
    
  }
  
}