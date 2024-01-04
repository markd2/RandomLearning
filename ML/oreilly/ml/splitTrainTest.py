#!/usr/bin/python3

import numpy as np

def split_train_test(data, test_ratio):
    shuffled_indicies = np.random.permmutation(len(data))
    test_set_size = int(len(data) * test_ratio)
    test_indicies = shuffled_indices[:test_set_size]
    train_indicies = shuffled_indices[test_set_size:]
    return data.iloc[train_indicies], data.iloc[test_indices]


