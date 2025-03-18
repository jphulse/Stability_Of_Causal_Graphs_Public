import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats

data = pd.read_csv('results/cross_alg.csv', header=None).squeeze()  


data_array = data.values
data_reshaped = data_array.reshape(10, 10)
# Uncomment to make heatmap
# plt.figure(figsize=(8, 6))
# sns.heatmap(data_reshaped, cmap='coolwarm', annot=True, fmt='.2f', cbar=True)

# plt.title('')

# plt.savefig('cross_heatmap.png', dpi=300)

# plt.show() 
# plt.close()

plt.figure(figsize=(8, 6))
sns.histplot(data_array, kde=True, color='blue', bins=20, stat='count')

plt.xlabel('Jaccard Index')
plt.ylabel('Count')
plt.title('Histogram and KDE of Jaccard Indexes from Different algorithms')

# Show the plot
plt.show()

