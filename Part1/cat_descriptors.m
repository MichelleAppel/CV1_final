function [ descriptors ] = cat_descriptors(color_space, sift_method, no_vocab_images, max_length)

if nargin < 1
    color_space = 'gray';
end
if nargin < 2
    sift_method = 'sift';
end
if nargin < 3
   no_vocab_images = 1000; % Default number of images to make the vocabulary with
end
if nargin < 4
    max_length = 1000000; % Default maximum amount of descriptors
end

no_classes = (length(dir(['../Caltech4/ImageSets', '/*.txt'])) - 2)/2;
no_images_per_class = floor(no_vocab_images / no_classes);

if strcmp(color_space, 'gray')
    dimensions = 128;
else
    dimensions = 384;
end
% length = 383607 for grayscale
descriptors = zeros(max_length, dimensions);
counter = 1;

file_name = strcat('vocab.txt');
path = strcat('../Caltech4/ImageSets/', file_name);

fid = fopen(path);
line = fgetl(fid); % Line in annotation file

while ischar(line)
   
    image_path = strcat('../Caltech4/ImageData/', line, '.JPG');
    image = imread(image_path);
    
    [ ~, d ] = find_keypoints(image, color_space, sift_method);
    
    [ ~, no_feature_points ] = size(d); % Amount of feature points
    
    descriptors(counter:counter + no_feature_points - 1, :) = d';
    counter = counter + no_feature_points;
    
    line = fgetl(fid);
    
    if counter > max_length
        break 
    end
end

descriptors = descriptors(1:counter-1, :); % Cut off zeros
descriptors = descriptors( any(descriptors, 2), :); % Delete zero rows (which aren't there if correct)
size(descriptors)

save(strcat('descriptors/', color_space, '_', sift_method, '_', int2str(no_vocab_images)), 'descriptors');
end