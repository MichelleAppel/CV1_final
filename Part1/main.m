run('../Dependencies/vlfeat-0.9.21/toolbox/vl_setup')

% init parameters
class = 'faces';
color_space = 'gray';
sift_method = 'sift';
K = 50;
no_vocab_images = 10;

% load (if already created) or create descriptors
file_name = strcat(color_space, '_', sift_method, '_', ...
    int2str(no_vocab_images), '.mat');
if exist(fullfile('descriptors', file_name), 'file')
    d = load(fullfile('descriptors', file_name));
    descriptors = d.descriptors;
    disp('Loaded descriptors.');
else
    descriptors = cat_descriptors(color_space, sift_method);
    disp('Created descriptors.');
end
    
% load (if already created) or create visual vocabulary
file_name = strcat('visual_vocab', '_', int2str(K), '_', ...
    color_space, '_', sift_method, '.mat');
if exist(fullfile('vocab', file_name), 'file')
    v = load(fullfile('vocab', file_name));
    visual_vocab = v.visual_vocab;
    disp('Loaded visual vocabulary.');
else
    visual_vocab = visual_vocabulary(descriptors, K, color_space, sift_method);
    disp('Created visual vocabulary.');
end

% load (if already trained) or train SVM model
file_name = strcat('model_', color_space, '_', sift_method, '_', class, '.mat');
if exist(fullfile('models', strcat('vocab_size_', int2str(K)), file_name), 'file')
    m = load(fullfile('models', strcat('vocab_size_', int2str(K)), file_name));
    model = m.model;
    disp('Loaded SVM model.');
else
    model = SVM(class, color_space, sift_method, K, visual_vocab);
    disp('Created SVM model.');
end

% predict on test data using trained model
[ predicted_label, accuracy ] = evaluate(class, color_space, sift_method, K, visual_vocab, model, true);
disp(predicted_label)
disp(accuracy)