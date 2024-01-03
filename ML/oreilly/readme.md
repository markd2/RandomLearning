# Hands on Machine Learning etc

2020 edition

Read through the first chapter of concepts, and stopped prior when digging
into the jupyter notebooks, so doing that now.

```
export ML_PATH=whatevers
```

I used $HOME/Projects/personal/RandomLearning/ML/oreilly/ml

Also stuffs in https://github.com/ageron/handson-ml2

Need some pythong modules:
  - jupyter, numpy, pands, matplotlib, and scikit-learn
  - could use homebrew for "anaconda" to get them, or pip them

They also suggest virtualenv (though I had so much pain with rubyenv that
I'm not going to do that yet)

https://www.anaconda.com/download (which I installed)
(also exists a web-based thing.  Didn't feel like making a lob-in)

added a fetch_housing_data function in fetchFile.py

```
import os
import pandas as pd

HOUSING_PATH = os.path.join("datsets", "housing")
def load_housing_data(housing_path = HOUSING_PATH):
    csv_path = os.path.join(housing_path, "housing.csv")
    return pd.read_csv(csv_path)
```

pandas dataframe is what's made from that pd.read_csv()

`head()` returns top five rows
`info()` for a quick description of the data, like a sql table description.

can dig in to it with `housing["ocean_proximity"].value_counts()`
`describe()` to show min/max/std dev, et

```
%matplotlib inline
import matplotlib.pyplot as plt
housing.hist(bins=50, figsize=(20,15))
plt.show()  # optional in jupyter
```

whoa.  hippograms.

