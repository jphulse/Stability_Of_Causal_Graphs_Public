# plots random subsamples of ant 1.3
data("ant-1.3")
## Make a matrix of 113 (approx 90% of ant 1.3) 5 times for testing
m.1 <- data.matrix(sample_n(data, 113))
m.2 <- data.matrix(sample_n(data, 113))
m.3 <- data.matrix(sample_n(data, 113))
m.4 <- data.matrix(sample_n(data, 113))
m.5 <- data.matrix(sample_n(data, 113))

suffStat.1 <- list(C = cor(m.1), n=nrow(m.1))
suffStat.2 <- list(C = cor(m.2), n=nrow(m.2))
suffStat.3 <- list(C = cor(m.3), n=nrow(m.3))
suffStat.4 <- list(C = cor(m.4), n=nrow(m.4))
suffStat.5 <- list(C = cor(m.5), n=nrow(m.5))

varNames <- colnames(data)

pc.1 <- pc(suffStat.1, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.2 <- pc(suffStat.2, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.3 <- pc(suffStat.3, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.4 <- pc(suffStat.4, indepTest = gaussCItest, labels = varNames, alpha = .01)
pc.5 <- pc(suffStat.5, indepTest = gaussCItest, labels = varNames, alpha = .01)

if(require(igraph)) {
  par(mfrow = c(2, 3))
  plot(pc.1)
  plot(pc.2)
  plot(pc.3)
  plot(pc.4)
  plot(pc.5)
       
}



