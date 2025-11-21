clear all, close all, clc
rng('default')
I=[53,56,68,72,81,82,83,128,135,137,139,145,163,166,172,180,187,71,61,112,170,171,149,157];

I_val = randsample(I,4)'
I_test = randsample(setdiff(I,I_val),10)'
I_train = setdiff(I,[I_val;I_test])'