import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats

data = pd.read_csv('results/cross_alg.csv', header=None).squeeze()  


data_array = data.values
data_reshaped = data_array.reshape(10, 10)

plt.figure(figsize=(8, 6))
plt.grid(axis='y', alpha=.5, color='gray' )
sns.histplot(data_array, kde=True, color='blue', bins=20, stat='count')
for spine in plt.gca().spines.values():
    spine.set_visible(False)

plt.xlabel('Jaccard Index')
plt.ylabel('Count')
plt.title('')

plt.savefig('cross_alg_hist.png', dpi=600)
# Show the plot
plt.show()

