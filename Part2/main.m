%% main function 

%addpath '../Dependencies/liblinear-2.20/windows'
addpath '../Dependencies/liblinear-2.20/matlab'
%run('../Dependencies/matconvnet-1.0-beta25/matlab/vl_setupnn.m')
run('../Dependencies/matconvnet-1.0-beta23/matlab/vl_setupnn.m')

%% fine-tune cnn

%[net, info, expdir] = finetune_cnn();

%% extract features and train svm

%expdir = 'data/weightDecay_0_0001_batchSize_50_numEpochs_120';
%model = 'net-epoch-120.mat';

%expdir = 'data/weightDecay_0_0001_batchSize_50_numEpochs_80';
%model = 'net-epoch-80.mat';

%expdir = 'data/weightDecay_0_0001_batchSize_50_numEpochs_40';
%model = 'net-epoch-40.mat';

%expdir = 'data/weightDecay_0_0001_batchSize_100_numEpochs_120';
%model = 'net-epoch-120.mat';

%expdir = 'data/weightDecay_0_0001_batchSize_100_numEpochs_80';
%model = 'net-epoch-80.mat';

expdir = 'data/weightDecay_0_0001_batchSize_100_numEpochs_40';
model = 'net-epoch-40.mat';

% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, model)); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%
train_svm(nets, data);
