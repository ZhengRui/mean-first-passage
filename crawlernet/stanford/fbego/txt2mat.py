import pandas as pd
import numpy as np
import scipy.io as sio

data = pd.read_csv('results_20x50.txt', header=None)

def f(s):
    return float(s.split('=')[-1].strip())

data[0] = data[0].apply(f)
data[1] = data[1].apply(f)
data[2] = data[2].apply(f)
data[3] = data[3].apply(f)
data.sort([0,1,2], inplace=True)

print data
m = data.groupby([0,1])[3].mean().values
s = data.groupby([0,1])[3].std().values

m = np.lib.pad(m, (0, 63-len(m)), 'constant')
s = np.lib.pad(s, (0, 63-len(s)), 'constant')
m = m.reshape(21,3)
s = s.reshape(21,3)

sio.savemat('mean_std_20x50.mat', {'mmean':m, 'sstd':s})
