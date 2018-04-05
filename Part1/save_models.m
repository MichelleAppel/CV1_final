% v = load('vocab/visual_vocab_sift_gray_400.mat');
% vocab = v.visual_vocab;
% SVM('airplanes', vocab, 'gray', 'sift');
% SVM('cars', vocab, 'gray', 'sift');
% SVM('faces', vocab, 'gray', 'sift');
% SVM('motorbikes', vocab, 'gray', 'sift');

v = load('vocab/visual_vocab_sift_RGB_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'RGB', 'sift');
SVM('cars', vocab, 'RGB', 'sift');
SVM('faces', vocab, 'RGB', 'sift');
SVM('motorbikes', vocab, 'RGB', 'sift');

v = load('vocab/visual_vocab_sift_norm_rgb_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'norm_rgb', 'sift');
SVM('cars', vocab, 'norm_rgb', 'sift');
SVM('faces', vocab, 'norm_rgb', 'sift');
SVM('motorbikes', vocab, 'norm_rgb', 'sift');

v = load('vocab/visual_vocab_sift_opponent_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'opponent', 'sift');
SVM('cars', vocab, 'opponent', 'sift');
SVM('faces', vocab, 'opponent', 'sift');
SVM('motorbikes', vocab, 'opponent', 'sift');


% 
% v = load('vocab/visual_vocab_dsift_gray_400.mat');
% vocab = v.visual_vocab;
% SVM('airplanes', vocab, 'gray', 'dsift');
% SVM('cars', vocab, 'gray', 'dsift');
% SVM('faces', vocab, 'gray', 'dsift');
% SVM('motorbikes', vocab, 'gray', 'dsift');

v = load('vocab/visual_vocab_dsift_RGB_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'RGB', 'dsift');
SVM('cars', vocab, 'RGB', 'dsift');
SVM('faces', vocab, 'RGB', 'dsift');
SVM('motorbikes', vocab, 'RGB', 'dsift');

v = load('vocab/visual_vocab_dsift_norm_rgb_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'norm_rgb', 'dsift');
SVM('cars', vocab, 'norm_rgb', 'dsift');
SVM('faces', vocab, 'norm_rgb', 'dsift');
SVM('motorbikes', vocab, 'norm_rgb', 'dsift');

v = load('vocab/visual_vocab_dsift_opponent_400.mat');
vocab = v.visual_vocab;
SVM('airplanes', vocab, 'opponent', 'dsift');
SVM('cars', vocab, 'opponent', 'dsift');
SVM('faces', vocab, 'opponent', 'dsift');
SVM('motorbikes', vocab, 'opponent', 'dsift');