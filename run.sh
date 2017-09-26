#!/bin/bash

# Copyright 2016-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# Modifications by Svebor Karaman (svebor.karaman@columbia.edu)
# - 10 runs
# - save model and data

exec 2> .stderr
ROOT="features/cifar-10-matlab-batches"

run_1000=true
run_5000=true
run_59000=true

run_onehot=false
run_LSH=false
run_topline=true

#save_model=""
#save_data=""
save_model=" --savemodel"
save_data=" --savedata"


seed_runs=(1 2 3 4 5 6 7 8 9 10)
#seed_runs=(1)
list_bits_LSH=(4 12 24 48 64)

if [[ "$run_1000" == true ]];
then
    echo "Experiments with 1000 labels and 300 anchors:"
    if [[ "$run_onehot" == true ]];
    then
        printf "One hot encoding:"
        #echo "python main.py --path "$ROOT" --labels 1000 --anchors 300 --code onehot"
        python main.py --path $ROOT --labels 1000 --anchors 300 --code onehot
    fi
    if [[ "$run_LSH" == true ]];
    then
        for nb_bits in "${list_bits_LSH[@]}"
        do
	    for seed in "${seed_runs[@]}"
            do
                printf "LSH run #"${seed}
                #echo "python main.py --path "$ROOT" --labels 1000 --anchors 300 --code lsh --nbits "$nb_bits" --seed "$seed
                python main.py --path $ROOT --labels 1000 --anchors 300 --code lsh --nbits $nb_bits --seed $seed
            done
        done
    fi
    if [[ "$run_topline" == true ]];
    then
        for seed in "${seed_runs[@]}"
        do
            printf "Topline run #"${seed}
            #echo "python main.py --path $ROOT --labels 1000 --anchors 300 --seed $seed ${save_model}"
            python main.py --path $ROOT --labels 1000 --anchors 300 --seed $seed ${save_model} ${save_data}
        done
    fi
    echo ""
fi

if [[ "$run_5000" == true ]];
then
    echo "Experiments with 5000 labels and 1000 anchors:"
    if [[ "$run_onehot" == true ]];
    then
        printf "One hot encoding:"
        python main.py --path $ROOT --labels 5000 --anchors 1000 --code onehot
    fi
    if [[ "$run_LSH" == true ]];
    then
        for nb_bits in "${list_bits_LSH[@]}"
        do
            for seed in "${seed_runs[@]}"
            do
                printf "LSH:"
            	python main.py --path $ROOT --labels 5000 --anchors 1000 --code lsh --nbits $nb_bits --seed $seed
	    done
        done
    fi
    if [[ "$run_topline" == true ]];
    then
        for seed in "${seed_runs[@]}"
        do
            printf "Topline run #"${seed}": "
            python main.py --path $ROOT --labels 5000 --anchors 1000 --seed $seed ${save_model} ${save_data}
        done
    fi
    echo ""
fi

if [[ "$run_59000" == true ]];
then
    echo "Experiment with 59000 labels and 1000 anchors: "
    if [[ "$run_onehot" == true ]];
    then
        printf "One hot encoding:"
	python main.py --path $ROOT --labels 59000 --anchors 1000 --code onehot
    fi
    if [[ "$run_LSH" == true ]];
    then
        for nb_bits in "${list_bits_LSH[@]}"
        do
            printf "LSH:"
            python main.py --path $ROOT --labels 59000 --anchors 1000 --code lsh --nbits $nb_bits
        done
    fi
    if [[ "$run_topline" == true ]];
    then
        for seed in "${seed_runs[@]}"
        do
            printf "Topline run #"${seed}
            python main.py --path $ROOT --labels 59000 --anchors 1000 --seed $seed ${save_model} ${save_data}
        done
    fi
    echo ""
fi
