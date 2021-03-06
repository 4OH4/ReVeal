#!/bin/bash

# ./full_run.sh -i input_dir (parsed cpgs) -o output_dir -n name of folder

while getopts i:o:n: flag
do
    case "${flag}" in
        i) inpdir=${OPTARG};;
        o) outpdir=${OPTARG};;
        n) name=${OPTARG};;
    esac
done

mkdir -p "$outpdir/data/full_experiment_real_data/$name";
mkdir -p "$outpdir/data/full_experiment_real_data_processed";
mkdir -p "$outpdir/model";
mkdir -p "$outpdir/ggnn_input";
mkdir -p "$outpdir/after_ggnn/$name";

#TODO: include Nick's slicer_all.sh to prep parsed directories for all c functions

python data_processing/create_ggnn_input.py --project "$name" --input "$inpdir" --output "$outpdir/data/";

python data_processing/extract_slices.py --project "$name" --input "$inpdir" --text_in "$outpdir/data/" --output "$outpdir/data/";

python data_processing/create_ggnn_data.py --input "$outpdir/data/" --project "$name" --csv "$inpdir/parsed/" --src "$inpdir/raw_code/" --wv "data/chrome_debian/raw_code_deb_chro.100" --output "$outpdir/data/full_experiment_real_data/$name/$name.json";

python data_processing/full_data_prep_script.py --project "$name" --input "$inpdir" --base "$outpdir/data/full_experiment_real_data/" --output "$outpdir/data/full_experiment_real_data_processed";

python data_processing/split_data.py --input "$outpdir/data/full_experiment_real_data_processed/$name-full_graph.json" --output "$outpdir/ggnn_input" --percent 50 --name "$name";

python Devign/main.py --model_type ggnn --dataset "$name" --input_dir "$outpdir/ggnn_input/$name/" --feature_size 169;

python Devign/run_model.py --model "models/$name/GGNNSumModel-model.bin" --dataset "$outpdir/ggnn_input/$name/processed.bin" --output_dir "$outpdir/after_ggnn/" --name "$name";
