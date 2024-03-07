library(pcalg)
library(dplyr)
data("prop-1")
varNames <- colnames(data)

cat(varNames, file="prop_stoch_VarNames.txt")
col <- ncol(data)

for(i in 0: 20) {
  set.seed((i * i) + 2)
  ## Take a random sample of 90 % of the data
  m <- data.matrix(sample_n(data, nrow(data)))
  suffStat <- list(C = cor(m), n = nrow(m))
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .07, u2pd="retry" )
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("prop_stoch_", i, ".txt"), append=T)
    }
    
  }
  
}