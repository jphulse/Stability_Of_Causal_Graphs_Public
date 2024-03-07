library(dplyr)
library(pcalg)
data("ant-1.3")
## Make a matrix of 113 (approx 90% of ant 1.3) 5 times for testing
m.1 <- data.matrix(sample_n(data, nrow(data)))


suffStat.1 <- list(C = cor(m.1), n=nrow(m.1))


varNames <- colnames(data)

pc.1 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .001)
pc.2 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.3 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .05)
pc.4 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .1)
pc.5 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .25)



if(require(igraph)) {
  par(mfrow = c(2, 3))
  plot(pc.1, main="alpha .001")
  plot(pc.2, main="alpha .01")
  plot(pc.3, main="alpha .05")
  plot(pc.4, main="alpha .1")
  plot(pc.5, main="alpha .25")
       
}

sink("ant_1.3_alpha_VarNames.txt")
print(varNames)
sink("ant_1.3_alpha_0.txt")
print(pc.1@graph@edgeL)

sink("ant_1.3_alpha_1.txt")
print(pc.2@graph@edgeL)

sink("ant_1.3_alpha_2.txt")
print(pc.3@graph@edgeL)

sink("ant_1.3_alpha_3.txt")
print(pc.4@graph@edgeL)

sink("ant_1.3_alpha_4.txt")
print(pc.5@graph@edgeL)

sink(paste0("ant_1.3_alpha", 4, "_test.txt"))
print("test")



