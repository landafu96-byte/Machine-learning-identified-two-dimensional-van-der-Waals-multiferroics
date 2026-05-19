#!/bin/sh
#PBS -N cgcnn
#PBS -l nodes=xxx:ppn=72
#PBS -l walltime=720:00:00

train_data_dir="/base/data/train"
test_data_dir="/base/data/test"
model="/base/checkpoint.pth.tar"
org_model_path="/base/model/3D"
new_model_path="/base/model/2D"
result_path="/base/result"

cd $PBS_O_WORKDIR
source ~/anaconda3/etc/profile.d/conda.sh
conda activate cgcnn

for i in {1..100}
do
python train_test_split.py
python transform.py $train_data_dir --model_path "$org_model_path/$i.pth.tar" --task classification --epochs 45  --wd 0.0005 --lr 0.002  --momentum 0.95 -b 164  \
 --atom-fea-len 64  --n-conv 3  --n-h 1 --h-fea-len 128 --lr-milestones 30 > log
cp checkpoint.pth.tar "$new_model_path/$i.pth.tar"
python predict.py $model $test_data_dir >log1
cp test_results.csv "$result_path/test_results_$i.csv"
done

