# This code was created for my semester research paper for CSC 591 at NCSU in Fall 2024
# The goal is to try to improve stability seen in causal discovery by using subsamples of synthetic
# and real data in order to predict the most stable algorithm to use on a dataset.  This was primarily inspired 
# by a paper published in 2019 C. Glymour, K. Zhang, and P. Spirtes, ‘‘Review of causal discovery meth-
# ods based on graphical models,’’ Frontiers in genetics, vol. 10, p. 524, 2019.
# where they discuss assumptions inherit in the models, and briefly discuss instability.
# That prompted me to look into dataset attributes and see if there was a way to use the existing innovations
# in causal discovery to make stability-maximizing predictions without needing to "reinvent the wheel" for every new dataset
#
#
# @author Jeremy P. Hulse CSC Undergraduate and Accelerated Master's Student at North Carolina State University

# General imports for files or system operations
import os 
import re 
import csv
# pip install portalocker
import portalocker
from typing import List

# Data formattingimports
import pandas as pd
import numpy as np

from pandas import DataFrame
from numpy import ndarray
# pip install causallearn
# causal learning imports
# Causallearn is a novel package for causal discovery associated with a 2024
# paper which is already being cited within other new literature, already having 47 citations 
# in the field make this a new representation of the latest and greatest in causal discovery
# and the 30 years of work that have gone into improving these methods
from causallearn.search.ConstraintBased import PC
from causallearn.search.ConstraintBased import FCI
from causallearn.search.ScoreBased import GES
from causallearn.search.FCMBased import lingam
# Not currently used, but provides utilities to draw the graphs and other fun stuff to play with, so I left it in
from causallearn.utils.GraphUtils import GraphUtils

# data processing or modification imports
from scipy import stats
import statsmodels.api as sm
import bisect



# INITIALIZATION, done first, regex and file info, to add more files SYNTHETIC data (exposed to RQ1 and RQ2)
# just simply place a file named train.csv in a new subdirectory from the data\\ directory.
# To add a new set of associated REAL datasets you can eithe rplace them within the specified subdirectories below,
# however I would suggest making a new folder data\\<my_new_folder> and placing them within that folder as *.csv files
# then add the path of that directory with the same syntax as the ones in the real_paths list manually
initial_path = 'data\\'
ant_path = 'data\\ant'
ivy_path = 'data\\ivy'
camel_path = 'data\\camel'
synapse_path = 'data\\synapse'
xerces_path = 'data\\xerces'
config_path = 'data\\Config'
Process_path = 'data\\Process'
real_pattern = r'.*\.csv$'

# gets all of the files from the directory that match the provided regex pattern
# optional found flags allows for separate search, see main code at the bottom for an example of how to use this
def get_files(directory, regex, found=[], synthetic=True):
    reg = re.compile(regex)
    for path, _, files in os.walk(directory):
        for file in files:
            if reg.search(file):
                found.append(os.path.join(path, file))
    
    return found

# Takes a 2D edgelist and turns them into an adjacency matrix for comparisons
# used for the graphs output by the pc algorithm
def turnEdgesToMatrix(edges, dim):
    matrix = np.zeros((dim, dim))
    for i, j in edges:
        matrix[i, j] = 1
    
    return matrix

# Turns an edgelist  from the fci part of causallearn into an adjacency matrix
# IMPORTANT only works on data labeled X1, X2, X3 ... XN, intended for use with fci output
def turnEdgeListToMatrix(list, dim):
    edges = []
    for edge in list:
        e1 = edge.get_numerical_endpoint1()
        e2 = edge.get_numerical_endpoint2()
        if e1 == -1:
            edges.append((int(edge.get_node1().get_name()[1:]) - 1, int(edge.get_node2().get_name()[1:]) - 1))
        elif (e1 == 2 and e2 != 1) or (e1 == 1 and e2 == 1):
            edges.append((int(edge.get_node1().get_name()[1:]) - 1, int(edge.get_node2().get_name()[1:]) - 1))
    
    return turnEdgesToMatrix(edges, dim)

# GES adjacency matrix process is slightly different from the others and done here
# this is done this way currently, although edges where there is a -1 are less
# certain, treated as undirected the same way they are handles in PC by converting them to 
# 1 on both sides, violates the DAG for the sake of consistency and fairness
def getGESAdjacencyMatrix(graph, dim):
    for i in range(dim):
        for j in range(dim):
            if graph[i, j] == -1:
                graph[i, j] = 1
    
    return graph

# Adjusts the LiNGAM matrix to fit our model for evaluation, there is potential to add an additional parameter to require a certain minimal threshold effect
# to be considered an edge, this would likely improve stability at the cost of edgecount but may not be helpful in accuracy
# potential area for hyperparameter optimization for stability
def modifyLinGamAdjacencyMatrix(mat, dim):
    for i in range(dim):
        for j in range(dim):
            if mat[i, j] != 0:
                mat[i, j] = 1
    return mat

# Calculates the Jaccard Index of two adjacency matrix causal graphs
# of size dim, the equation for this is the edges in g1 AND g2 over the edges
# in g1 OR g2, and this will be a value between 0 (least similar) and 1 (most similar)
def calculateJaccardIndex(g1, g2, dim):
    bothCount = 0
    eitherCount = 0
    for i in range(dim):
        for j in range(dim):
            if g1[i, j] == 1 or g2[i, j] == 1:
                eitherCount += 1
                if g1[i, j] == g2[i, j]:
                    bothCount += 1
    return bothCount / eitherCount if eitherCount > 0 else 0

# performs the pc algorithm and returns the appropriately formatted matrix                
def performPC(grid, dim, alph=.05):
    print(grid)
    print(grid.shape[0], grid.shape[1] )
    pc_graph = PC.pc(grid, show_progress=False)
    return turnEdgesToMatrix(pc_graph.find_adj(), dim)

# performs the FCI alg and returns the formatted matrix
def performFCI(grid, dim):
    _, fci_list = FCI.fci(grid, show_progress=False)
    return turnEdgeListToMatrix(fci_list, dim)

# performs the GES alg and returns the formatted matrix
def performGES(grid, dim):
    ges_graph = GES.ges(grid)
    return getGESAdjacencyMatrix(ges_graph['G'].graph, dim)

# performs the LiNGAM alg and returns the formatted matrix
def performLiNGAM(grid, dim):
    lin_model = lingam.DirectLiNGAM()
    lin_model.fit(grid)
    return modifyLinGamAdjacencyMatrix(lin_model.adjacency_matrix_, dim)




# Makes the four kinds of graphs for the REAl data given the 
# grid representation of the dataframe associated with the sample
def makeGraphs(grid):
    dim = grid.shape[1]
    pc_matrix = performPC(grid, dim)
    fci_matrix = performFCI(grid, dim)
    ges_matrix = performGES(grid, dim)
    lin_matrix = performLiNGAM(grid, dim)
    return pc_matrix, fci_matrix, ges_matrix, lin_matrix

def compareSets(s1, s2, dim) :
    results = []
    for g1, g2 in zip(s1, s2):
        results.append(calculateJaccardIndex(g1, g2, dim))
    return tuple(results)

def fix_invariance(df : DataFrame):

    return df.loc[:, df.var() != 0]


def fix_normal_data(df :DataFrame):
    df = fix_invariance(df)
    return df

# Runs a subsample
def run_sub(file, n=20, p=.9, big=False):
   df = pd.read_csv(file)
   df = fix_normal_data(df)
   if big:
       df = df.sample(100)
   sub = df.sample(frac=p)
   count = 0
   grid = sub.to_numpy()
   primes = makeGraphs(grid)
   totals = (0, 0, 0, 0)
   dim = grid.shape[1]
   for i in range(n):
    sub = df.sample(frac=p)
    grid = sub.to_numpy()
    graphs = makeGraphs(grid)
    totals = tuple(a + b for a, b in zip(totals, compareSets(primes, graphs, dim)))
    count += 1
   append_to_results(file, tuple(x / count for x in totals), "sub")

# runs inter project experiment returns a 3D numpy array
# indexes are in the following order
# 0, ant
# 1, camel
# 2, ivy
# 3 synapse
# 4 xerces
# each of these elements is a tuple  of 4 in order: (pc, fci, ges, lin)
def run_inter(ant, camel, ivy, synapse, xerces):
    a = pd.read_csv(ant)
    a = fix_normal_data(a)
    a_grid = a.to_numpy()
    dim = a_grid.shape[1]
    graphs = []
    a_graphs = makeGraphs(a_grid)
    c = pd.read_csv(camel)
    c = fix_normal_data(c)
    c_grid = c.to_numpy()
    c_graphs = makeGraphs(c_grid)
    i = pd.read_csv(ivy)
    i = fix_normal_data(i)
    i_grid = i.to_numpy()
    i_graphs = makeGraphs(i_grid)
    s = pd.read_csv(synapse)
    s = fix_normal_data(s)
    s_grid = s.to_numpy()
    s_graphs = makeGraphs(s_grid)
    x = pd.read_csv(xerces)
    x = fix_normal_data(x)
    x_grid = x.to_numpy()
    x_graphs = makeGraphs(x_grid)
    graphs.append(a_graphs)
    graphs.append(c_graphs)
    graphs.append(i_graphs)
    graphs.append(s_graphs)
    graphs.append(x_graphs)
    comparison_grid = np.zeros((5, 5, 4))
    for row in range(5):
        for col in range(row + 1, 5):
            comparison_grid[row, col] = compareSets(graphs[row], graphs[col], dim)
    output_comparison_grid_to_csv(comparison_grid)

# Flattens the 3D grid and prints it to a csv names results\\inter_project.csv
def output_comparison_grid_to_csv(comparison_grid):
    flattened_data = []

    for row in range(5):
        for col in range(row + 1, 5):  
            comparison_result = comparison_grid[row, col]
            flattened_data.append([row, col] + list(comparison_result))

    df = pd.DataFrame(flattened_data, columns=['Row', 'Column', 'pc', 'fci', 'ges', 'lin'])
    df.to_csv('results\\inter_project.csv', index=False)


# Runs the version experiment, should print to a file named after the earliest version
# as a csv with the average Jaccard value for pc, fci, ges, lin
def run_version(files):
    count = 0
    df_i = pd.read_csv(files[0])
    df_i = fix_normal_data(df_i)
    grid_i = df_i.to_numpy()
    dim = grid_i.shape[1]
    graphs_i = makeGraphs(grid_i)
    totals = (0,0,0,0)
    for i in range(len(files) -1):
        release_next = files[ i + 1]
        df_next = pd.read_csv(release_next)
        df_next = fix_normal_data(df_next)
        grid_next = df_next.to_numpy()
        graphs_next = makeGraphs(grid_next)
        totals = tuple(a + b for a, b in zip(totals, compareSets(graphs_i, graphs_next, dim)))
        count += 1
        graphs_i = graphs_next
    append_to_results(files[0], tuple(x / count for x in totals), "version")


    

    
# Writes the results in a tuple in the form of 
# PC, fci, ges, lin into a file with their appropriate average jaccard values
def append_to_results(file, my_tuple, extension=None):
    folder, filename = file.split("\\")[1], file.split("\\")[2]
    if extension:
        filename = f"{filename.split('.')[0]}_{extension}.{filename.split('.')[1]}"
    result_folder = f'results\\{folder}'
    result_file = f'{result_folder}\\{filename}'
    if not os.path.exists(result_folder):
        os.makedirs(result_folder)
    with open(result_file, mode='a', newline='') as output_file:
        writer = csv.writer(output_file)        
        writer.writerow(my_tuple)
       




    

    

config_files = get_files(config_path, real_pattern)
process_files = get_files(Process_path, real_pattern, found=[])
ant_files = get_files(ant_path, real_pattern, found=[])
ivy_files = get_files(ivy_path, real_pattern, found=[])
camel_files = get_files(camel_path, real_pattern, found=[])
synapse_files = get_files(synapse_path, real_pattern, found=[])
xerces_files = get_files(xerces_path, real_pattern, found=[])

for file in config_files:
    run_sub(file, big=True)
for file in process_files:
    run_sub(file, big=True)
for file in ant_files:
    run_sub(file)
for file in ivy_files:
    run_sub(file)
for file in camel_files:
    run_sub(file)
for file in synapse_files:
    run_sub(file)
for file in xerces_files:
    run_sub(file)

run_inter(ant_files[-1], camel_files[-1], ivy_files[-1], synapse_files[-1], xerces_files[-1])
for files in [ant_files, camel_files, ivy_files, synapse_files, xerces_files]:
    run_version(files)


