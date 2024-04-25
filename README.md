# Stability_Of_Causal_Graphs_Public
Public Repository containing all of my scripts as well as necessary information to run and verify my independent undergraduate research from Spring 2024

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
    
