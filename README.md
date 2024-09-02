# Stability_Of_Causal_Graphs_Public
Public Repository containing all of my scripts as well as necessary information to run and verify my independent undergraduate research from Spring 2024

## Download instructions
Install and download a compatable recent version of R studio to work with the pcalg package, see [pcalg manual](https://cran.r-project.org/web//packages/pcalg/pcalg.pdf) for method documentation about the package.  Here is the link to the [package source](https://cran.r-project.org/web/packages/pcalg/index.html), I ran my experiments directly through this as an imported project in RStudio, however the results should be reproducable regardless of where you place the scripts, although file paths may need to be modified accordingly.  The scripts can be ran directly through RStudio, and the Java file (if you choose to use that) can be ran in the form java Jaccard.java which has documentation for how to run it in the comments on the main method.

## Structure
The repository is structured into several different folders: here is the general layout:

Data:

  Input Data: The datasets utilized in the experiments in labeled .csv files that can be parsed by R.

  
  
    
  Observational Data: Output data, largely composed of Excel workbooks with Jaccard values which was the comparison metric utilized in experiments.
    
  Java:
  Contains the file Jaccard.java which is used to parse through labeled experiment output files from R. These experiment files each contain a representation of one graph object, as such they are all read and compared by this Java file which generates a very large singular output file.
 
    
  Scripts:
  
  R scripts which were used to perform various experiments on the datasets.  It is expected that the user has included the pcalg package in the RStudio environment, and has a compatible version of RStudio installed.

### Contributors
* Author: Jeremy Hulse (jphulse) Email: jphulse@ncsu.edu
* Mentor: Dr. Timothy Menzies


### Citations for pcalg package
Markus Kalisch, Martin Mächler, Diego Colombo, Marloes H. Maathuis, Peter Bühlmann (2012). “Causal Inference Using Graphical Models with the R Package pcalg.” Journal of Statistical Software, 47(11), 1–26. doi:10.18637/jss.v047.i11.

Alain Hauser, Peter Bühlmann (2012). “Characterization and greedy learning of interventional Markov equivalence classes of directed acyclic graphs.” Journal of Machine Learning Research, 13, 2409–2464. https://jmlr.org/papers/v13/hauser12a.html.
    
