#!/bin/bash

nNodes=$1
nChains=$2
minK=$3
logPrefix=$4

matlab -nojvm -r "addpath(genpath('~/workspace/MeanFirstPassage')); mfpsimulatemu($nNodes, $nChains, $minK); quit;" > ${logPrefix}${nNodes}_${nChains}x${minK}.out 2>&1


### example: 
### ./task.sh 64 1 6000 "../networkbase/Dolphin/"
### ./task.sh 2000 1 800 "../networkbase/BA/"
### ./task.sh 3282 1 500 "../networkbase/12/"
### ./task.sh 3282 1 500 "../networkbase/sierpinski/"
### ./task.sh 2188 1 750 "../networkbase/Tgraph/"
