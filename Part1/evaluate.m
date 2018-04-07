function [ predicted_label, accuracy ] = evaluate(class, color_space, sift_method, ...
    vocab_size, vocabulary, trained_model, save_results)
% EVALUATE  Uses a trained binary classifier to predict on test data.
% trai1ned_model     One of 32 trained binary classifiers.
%                   (4 color_spaces x 2 SIFT x 4 classes = 32 class.)
% class             The class to predict (airplanes, cars, faces, motorbikes).
% color_space       % add description
% sift_method       % add description 
% vocabulary        % add description
% trained_model     % add description
% save_results      % add description


if nargin < 1
    class = 'airplanes';
end
if nargin < 2
    color_space = 'gray';
end
if nargin < 3
    sift_method = 'sift';
end
if nargin < 4
    % load vocabulary
    file_name = strcat('vocab_', int2str(vocab_size), '_', color_space, '_', sift_method, '_');
    vocabulary_wrap = load(fullfile('vocabs', strcat('vocab_size_', int2str(vocab_size)), file_name));
    vocabulary = vocabulary_wrap.visual_vocab;    
end
if nargin < 5
    % load trained model
    file_name = strcat('model_', color_space, '_', sift_method, '_', class);
    trained_model_wrap = load(fullfile('models', strcat('vocab_size_', int2str(vocab_size)), file_name));
    trained_model = trained_model_wrap.model;
end
if nargin < 6
    save_results = true;
end

% TODO: put overlapping code (with SVM.m) into one function
path = strcat('../Caltech4/Annotation/', class, '_test.txt');
fid = fopen(path);
line = fgetl(fid); % Line in annotation file
line_count = 1;
while ischar(line)
    line_count = line_count + 1;
    line = fgetl(fid);
end
fclose(fid);

labels = zeros(line_count, 1);
features = zeros(line_count, vocab_size);
image_names = cell(line_count, 1);

fid = fopen(path);
line = fgetl(fid); % Line in annotation file 

i = 1;
while ischar(line) %&& i < 2
   split_line = strsplit(line); % Filename and label

   image_file = char(split_line(1));

   image_path = strcat('../Caltech4/ImageData/', image_file, '.JPG');
   image = imread(image_path);

   label = str2double(split_line(2)); % Label of the image           
   BoF = bag_of_features(image, vocabulary, color_space, sift_method)'; % Bag of features for the image

   labels(i)      = label;
   features(i, :) = BoF;
   image_names(i) = cellstr(image_file);
   
   line = fgetl(fid);
   i = i + 1;
end
   
fclose(fid);

disp(features(1:10, :))

%%%%% PREDICT

[ predicted_label, scores ] = predict(trained_model, features(1:i-1, :));

similar_ind = predicted_label == labels(1:i-1, :);

accuracy = sum(similar_ind)/length(similar_ind);

disp(scores);

% results = [num2cell(score) num2cell(predicted_label) num2cell(labels(1:i-1)) image_names(1:i-1)];
% 
% disp(predicted_label)
% disp(score)

%  [~, idx] = sort(score(:, 1), 'descend');
%  sorted_results = results(idx, :);
%  disp("      Score     Pred.  Real           Image")
%  disp(sorted_results)
% 
%  
% if save_results
%      file_name = strcat('temp_results/vocab_size_', int2str(vocab_size), ...
%          '/results_', color_space, '_', sift_method, '_', class, '.mat');
%      save(file_name, 'sorted_results');
% end

end
