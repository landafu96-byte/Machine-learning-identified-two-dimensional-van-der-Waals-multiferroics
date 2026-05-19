import os
import csv
import shutil
import numpy as np
import random

synthesis_dir = "/base/data/3d/syn"
unlabel_dir = "/base/data/3d/unlabel"

training_dir = "/base/data/train"
test_dir = "/dase/data/test"
atom_dir = "/base/atom_init.json"

train_size_p = 5000

if os.path.exists(training_dir):
    shutil.rmtree(training_dir)
os.makedirs(training_dir)

unlabeled_sample = os.listdir(unlabel_dir)
positive_sample = os.listdir(synthesis_dir)
test_sample = [i.split('.')[0] for i in os.listdir(test_dir) if i.endswith('cif')]

data = []
count = 0

random.shuffle(positive_sample)

for j in positive_sample:
    sample_id = j.split('.')[0]
    if sample_id not in test_sample:
        data.append([sample_id, 1])
        shutil.copy(os.path.join(synthesis_dir, j), os.path.join(training_dir, j))
        count += 1
        if count == train_size_p:
            break

unlabeled_sample_filtered = [f for f in unlabeled_sample if f.split('.')[0] not in test_sample]
select_list = np.random.choice(unlabeled_sample_filtered, size=train_size_p, replace=False)


for fname in select_list:
    sample_id = fname.split('.')[0]
    shutil.copy(os.path.join(unlabel_dir, fname), os.path.join(training_dir, fname))
    data.append([sample_id, 0])


shutil.copy(atom_dir, os.path.join(training_dir, 'atom_init.json'))

with open(os.path.join(training_dir, 'id_prop.csv'), 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(data)
