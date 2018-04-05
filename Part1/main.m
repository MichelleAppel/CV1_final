run('../Dependencies/vlfeat-0.9.21/toolbox/vl_setup')

d = load('descriptors\gray_sift_1000.mat');
descriptors = d.descriptors;

class = 'airplanes';
color_space = 'gray';
sift_method = 'sift';

% tic
% K = 10;
% visual_vocab = visual_vocabulary(descriptors, K, color_space, sift_method);
% toc

% v = load(strcat('vocab/visual_vocab', '_', string(K), '_', color_space, '_', sift_method));
% visual_vocab = v.visual_vocab;


% tic
% model = SVM(class, color_space, sift_method, K, visual_vocab);
% toc

m = load('models/vocab_size_800/model_gray_sift_airplanes');
model = m.model;

[ predicted_label, accuracy ] = evaluate(class, color_space, sift_method, K, visual_vocab, model, true);


disp(predicted_label)
disp(accuracy)

