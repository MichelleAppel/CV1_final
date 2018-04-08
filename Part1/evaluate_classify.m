function [ accuracy ] = evaluate_classify(color_space, sift_method, ...
    vocab_size, save_results, predict_on_data)
% EVALUATE  Uses a trained binary classifier to predict on test data.
% trai1ned_model     One of 32 trained binary classifiers.
%                   (4 color_spaces x 2 SIFT x 4 classes = 32 class.)
% class             The class to predict (airplanes, cars, faces, motorbikes).
% color_space       % add description
% sift_method       % add description 
% vocabulary        % add description
% trained_model     % add description
% save_results      % add description
% predict_on_data   % add description


if nargin < 1
    color_space = 'norm_rgb';
end
if nargin < 2
    sift_method = 'sift';
end
if nargin < 3
   vocab_size = 50; 
end
if nargin < 4
    save_results = true;
end
if nargin < 5
    predict_on_data = 'test';
end

% TODO: put overlapping code (with SVM.m) into one function
path = strcat('../Caltech4/ImageSets/', predict_on_data, '.txt');
fid = fopen(path);
line = fgetl(fid); % Line in annotation file
line_count = 1;
while ischar(line)
    line_count = line_count + 1;
    line = fgetl(fid);
end
fclose(fid);

labels = zeros(line_count, 1);
pred_labels = zeros(line_count, 1);

image_names = cell(line_count, 1);

fid = fopen(path);
line = fgetl(fid); % Line in annotation file 

i = 1;
while ischar(line) %&& i < 2
   image_file = line; % Filename and label

   image_path = strcat('../Caltech4/ImageData/', image_file, '.JPG');
   image = imread(image_path);

   if startsWith(image_file, 'airplanes')
       label = 1;
   elseif startsWith(image_file, 'cars')
       label = 2;
   elseif startsWith(image_file, 'faces')
       label = 3;
   elseif startsWith(image_file, 'motorbikes')
       label = 4;          
   end
   
   [ predicted_label, scores ] = classify(image, vocab_size, color_space, sift_method);
   
   labels(i)      = label;
   pred_labels(i) = predicted_label;

   image_names(i) = cellstr(image_file);
   
   line = fgetl(fid);
   i = i + 1;
end
   
fclose(fid);

%%%%% PREDICT

similar_ind = pred_labels(1:i-1, :) == labels(1:i-1, :);

accuracy = sum(similar_ind)/length(similar_ind);

% results = [num2cell(scores) num2cell(predicted_label) num2cell(labels(1:i-1)) image_names(1:i-1)];
% 
% [~, idx] = sort(scores(:, 1), 'descend');
% sorted_results = results(idx, :);
% disp("      Score       Pred.    Real           Image")
% disp(sorted_results) 
  
% if save_results
%     file_str = strcat('results/vocab_size_', int2str(vocab_size), ...
%         '/results_', color_space, '_', sift_method, '_', class, '.mat');
%     save(file_str, 'sorted_results');
% end

disp(accuracy);

end