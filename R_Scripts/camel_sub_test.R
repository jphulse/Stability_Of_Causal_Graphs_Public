# performs a 90% subsample test on the Camel dataset
library(pcalg)
library(dplyr)
data("camel-1.0")
varNames <- colnames(data)

cat(varNames, file="camel_sub_VarNames.txt")
col <- ncol(data)

for(i in 0: 20) {
  ## Take a random sample of 90 % of the data
  m <- data.matrix(sample_n(data, 306))
  suffStat <- list(C = cor(m), n = nrow(m))
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("camel_sub_", i, ".txt"), append=T)
    }
    
  }
  
}
