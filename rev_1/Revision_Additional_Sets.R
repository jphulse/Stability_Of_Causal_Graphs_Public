library(pcalg)
library(dplyr)
library(igraph)

# Calculate the Jaccard value for two graphs, calculated by intersect over union, a 1.0 means the graphs are identical, a 0 means they share no edges
JACCARD <- function(pc1, pc2) {
  ## PCALGO objects are of type graphNel, use that to convert them to an adjacency matrix for easy calculations
  m1 <- as(pc1, "matrix")
  m2 <- as(pc2, "matrix")
  eCount1 <- 0
  eCount2 <- 0
  eCountBoth <- 0
  ## Matrix in R can be traversed like a large list of size m x n
  for(i in 1:(nrow(m1) * ncol(m1))) {
    
    ## If there is a 1 in this cell that means the edge exists so increment the 1st graph's count
    if(m1[i] == 1)
    { 
      eCount1 <- eCount1 + 1
    }
    ## If there is a 1 in this cell that means the edge exists so increment the 2nd graph's count
    if(m2[i] == 1) 
    {
      eCount2 <- eCount2 + 1
    }
    ## If both graph's cell is 1 increment them both
    if(m1[i] == 1 && m2[i] == 1) {
      eCountBoth <- eCountBoth + 1
    }
    
  }
  ## If any of these values are 0 the jaccard value will be 0
  if(eCount1 == 0 || eCount2 == 0 || eCountBoth == 0) {
    return(0)
  }
  ## Calculate Jaccard value and return
  value <- eCountBoth / (eCount1 + eCount2 - eCountBoth)
  print(value)
  return(value)
}

# Performs the experiment with 90% subsamples on input which is expected to be read 
# in from a csv.
SubTest <- function(input) {
  varNames <- colnames(input)
  col <- ncol(input)
  m <- data.matrix(sample_n(input, 90))
  suffStat <- list(C = cor(m), n = nrow(m))
  prime <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
  results <- numeric(0)
  for (i in 1: 20) {
    m <- data.matrix(sample_n(input, 90))
    suffStat <- list(C = cor(m), n = nrow(m))
    graph <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .01)
    jVal <- JACCARD(prime, graph)
    results <- c(results, jVal)
  }
  return(results)
}

# Runs the alpha experiment on the input dataset which is expected to be from a csv
AlphaTest <- function(input){
  results <- numeric(0)
  varNames <- colnames(input)
  col <- ncol(input)
  m <- data.matrix(sample_n(input, nrow(input)))
  suffStat <- list(C = cor(m), n = nrow(m))
  prime <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = .001)
  alph = .011
  while(alph < 1){
    graph <- pc(suffStat, indepTest = gaussCItest, labels = varNames, alpha = alph)
    jVal <- JACCARD(prime, graph)
    results <- c(results, jVal)
    alph <- alph + .01
  }
  return(results)
}

# Reports the average of the  experiment and the standard deviation to the given file
reportVals <- function(results, file) {
  avg_value <- mean(results)
  sd_value <- sd(results)
  avg_df <- data.frame(Average = avg_value, Stdev = sd_value)
  write.table(avg_df, file = file, sep = ",", col.names = !file.exists(file), 
              row.names = FALSE, append = TRUE)
  cat("Average value:", avg_value, "and stdev: ", sd_value, "has been written to", file, "\n")
}

# Reads the files and places them all in global vars for easy operations
read_files <- function() {
  config_dir <- "data/Config"
  process_dir <- "data/Process"
  config_files <- list.files(config_dir, pattern = "\\.csv$", full.names = TRUE)
  process_files <- list.files(process_dir, pattern = "\\.csv$", full.names = TRUE)
  
  for(file in config_files){
    name <- gsub(".*/(.*)\\.csv", "\\1", file)
    df <- read.csv(file)
    assign(name, df[sample(nrow(df), 100),], envir = .GlobalEnv)
    
  }
  
  for(file in process_files){
    name <- gsub(".*/(.*)\\.csv", "\\1", file)
    df <- read.csv(file)
    assign(name, df[sample(nrow(df), 100),], envir = .GlobalEnv)
    
  }
}
performOperations <- function(input, alphFile, subFile) {
  alphRes <- AlphaTest(input)
  subRes <- SubTest(input)
  reportVals(alphRes, alphFile)
  reportVals(subRes, subFile)
}

# Main area of the script reads in files and 
read_files()
for(i in 1:20){
  
  performOperations(SS_N, "rev_results/SSNAlph.csv", "rev_results/SSNSub.csv")
  performOperations(SS_O, "rev_results/SSOAlph.csv", "rev_results/SSOSub.csv")
  performOperations(SS_P, "rev_results/SSPAlph.csv", "rev_results/SSPSub.csv")
  performOperations(xomo_flight, "rev_results/XFlightAlph.csv", "rev_results/XFlightSub.csv")
  performOperations(xomo_ground, "rev_results/XGroundAlph.csv", "rev_results/XGroundSub.csv")
  performOperations(xomo_osp, "rev_results/XOSPAlph.csv", "rev_results/XOSPSub.csv")
  
  
}
  