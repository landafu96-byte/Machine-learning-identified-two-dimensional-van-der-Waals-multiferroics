#!/bin/sh
#PBS -N cgcnn
#PBS -l nodes=xxx:ppn=72
#PBS -l walltime=720:00:00

train_data_dir="/base/data/train"
model="/base/checkpoint.pth.tar"
model_path="/base/model/3D"
result_path="/base/result"

cd $PBS_O_WORKDIR
source ~/anaconda3/etc/profile.d/conda.sh
conda activate cgcnn

for i in {1..100}
do
python train_test_split.py
python main.py $train_data_dir --task classification --epochs 40  --wd 0.0005 --lr 0.001  --momentum 0.95 -b 98  \
 --atom-fea-len 64  --n-conv 3  --n-h 1 --h-fea-len 128  > log
cp checkpoint.pth.tar "$model_path/$i.pth.tar"
done


