# Experiment testing on Ivy with a shifting alpha, the number of iterations can be changed to make this test as small or large as one wants by adjusting the bounds of the outer for loop
library(pcalg)
library(dplyr)
data("ivy-1.1")
varNames <- colnames(data)
m <- data.matrix(sample_n(data, nrow(data)))
suffStat <- list(C = cor(m), n = nrow(m))
cat(varNames, file="ivy_alpha_VarNames.txt")
col <- ncol(data)

for(i in 0: 14) {
  pc <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01 + i / 100)
  for(j in 1: col) {
    for(k in pc@graph@edgeL[j]) {
      cat(paste(k, "\n"),  file=paste0("ivy_alpha_", i, ".txt"), append=T)
    }
    
  }
  
}
