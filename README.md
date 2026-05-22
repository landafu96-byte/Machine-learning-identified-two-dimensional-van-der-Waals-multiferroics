# Machine-learning-identified-two-dimensional-van-der-Waals-multiferroics

# PU_Bagging
## Requirements  
Before run the program, please ensure that the following packages are installed:   
- PyTorch
- pymatgen
- scikit-learn  

## Overview

This project implements a Positive–Unlabeled (PU) Bagging learning framework for accurate classification tasks.  
The framework employs an ensemble strategy, where multiple base learners are trained on bootstrapped datasets.  

In this implementation, Crystal Graph Convolutional Neural Network (CGCNN) is used as the base model.  
The program is for PU Bagging learning, which trains an ensemble model to realise accurate classification.    

## Training the Base Model
You can train the initial CGCNN model using:  

`python main.py $train_data_dir --task classification --epochs 40 --wd 0.0005 --lr 0.001 --momentum 0.95 --atom-fea-len 64 --n-conv 3 --n-h 1 --h-fea-len 128`  

  ## PU Bagging Training  
  PU Bagging training is performed using:  
  
  `bash PU.sh`  
  
  This script trains an ensemble of models based on different resampled datasets.  

  ## Transfer Learning

After training the initial PU Bagging model, transfer learning can be applied to further improve performance:  

`python transform.py train_data_dir --model_path origin_model_path --task classification --epochs 45 --wd 0.0005 --lr 0.002 --momentum 0.95 --atom-fea-len 64 --n-conv 3 --n-h 1 --h-fea-len 128 --lr-milestones 30`

To complete the full pipeline (PU Bagging + transfer learning), run:  

`bash transfer_pu.sh`

## Prediction

Once the model is trained, you can predict the synthesizability probability using:  

`bash Test.pbs`

## Notes
`PU.sh`, `transfer_pu.sh`, and `Test.pbs` are PBS job submission scripts. If you are using other job scheduling systems (e.g., Slurm), these scripts should be modified accordingly.

# Out-of-Plane Polarization

A Python program for calculating out-of-plane polarization in two-dimensional ferroelectric materials.

## Required Files

To calculate the out-of-plane polarization, the following four files are required:

- `POSCAR`
- `val.json`
- `NGZF.txt`
- `PLANAR_AVERAGE.dat`

---

## Preparing Required Files

### 1. POSCAR
`POSCAR` is the structure file of the material.  
Please ensure that the structure is correct.

### 2. PLANAR_AVERAGE.dat
During the VASP calculation, please set:

```bash
LCHARG = T
```
`PLANAR_AVERAGE.dat` is generated based on the resulting `CHGCAR`. It contains the charge density averaged over the x–y plane along the z-direction.

You can obtain this file using `VASPKIT` under your working directory:

```
(echo 316;echo 1;echo 3)|vaspkit
```

### 3. NGZF.txt
`NGZF.txt` contains the NGZF value, which represents the number of grid divisions along the z-direction in the VASP calculation.
It can be extracted from `OUTCAR` using:
```
grep NGZF OUTCAR | head -n 1 | awk '{print $8}' > NGZF.txt
```

### 4. val.json
`val.json` contains the number of valence electrons for each element in the structure.  
It can be generated using the `val.py` script under your working directory:

```
python val.py
```
---
## Usage
Your data should be organized in the following directory structure:

```
base path/
├──material_1  
│├──POSCAR  
│├──NGZF.txt  
│├──val.json  
│├──PLANAR_AVERAGE.dat  
├──material_2  
│├──...  
├──material_3  
│├──...  
├──...
```

Before running polar.py, please ensure that the following Python packages are installed:
-numpy
-pymatgen
-pandas
-argparse

Run the script with:
```
python polar.py your\base\path
```

The output file `polar.csv` will be generated under the base path.  

Output Format


|material | polar|
| ----------- | ----------- |
|material_1 | polar_1  |
|material_2 | polar_2  |
|... | ...|




