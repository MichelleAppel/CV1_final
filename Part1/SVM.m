function [ model ] = SVM(class, color_space, sift_method, ...
    vocab_size, vocabulary, save_model)
% https://www.csie.ntu.edu.tw/~cjlin/liblinear/
%addpath ../Dependencies/liblinear/windows/
addpath ../Dependencies/liblinear-2.20/matlab/

if nargin < 2
    class = 'airplanes';
end
if nargin < 3
    color_space = 'gray';
end
if nargin < 4
    sift_method = 'sift';
end
if nargin < 5
    % load vocabulary
    file_name = strcat('vocab/visual_vocab_', ...
        int2str(vocab_size), '_', sift_method, '_', color_space, '.mat');
    vocabulary_wrap = load(file_name);
    vocabulary = vocabulary_wrap.visual_vocab;
end
if nargin < 6
    save_model = true;
end

[ vocab_size, ~ ] = size(vocabulary);

file_name = strcat(class, '_test.txt');
path = strcat('../Caltech4/Annotation/', file_name);

fid = fopen(path);
line = fgetl(fid); % Line in annotation file
line_count = 0;
while ischar(line)
   line_count = line_count + 1;
   line = fgetl(fid);
end
fclose(fid);

labels = zeros(line_count, 1 );
features = zeros(line_count, vocab_size);

fid = fopen(path);
line = fgetl(fid); % Line in annotation file

image_no = 1;
while ischar(line)
   split_line = strsplit(line); % Filename and label

   image_file = char(split_line(1));

   image_path = strcat('../Caltech4/ImageData/', image_file, '.JPG');
   image = imread(image_path);

   label = str2double(split_line(2)); % Label of the image 
   BoF = bag_of_features(image, vocabulary, color_space, sift_method)'; % Bag of features for the image
   labels(image_no)      = label;
   features(image_no, :) = BoF;

   line = fgetl(fid);
   image_no = image_no + 1;
end

fclose(fid);

if save_model
   save(strcat('dataset/vocab_size_', int2str(vocab_size) , '/data_', ...
       color_space, '_', sift_method, '_', class), 'labels', 'features');
end

disp('Start training SVM...')
model = train(labels, sparse(features));

if save_model
   save(strcat('models/vocab_size_', int2str(vocab_size) , '/model_', ...
       color_space, '_', sift_method, '_', class), 'model');
end
disp('Finished training, model saved.')

end