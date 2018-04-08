%% main function 

addpath '../Dependencies/liblinear-2.20/matlab'

%% fine-tune cnn

%[net, info, expdir] = finetune_cnn();

%% extract features and train svm

expdir = 'data';
% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, 'weightDecay_0_0001_batchSize_50_numEpochs_40/net-epoch-40.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%
train_svm(nets, data);
