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
    
    dirs = dir('../Caltech4/ImageData/');
    for k = 1:length(dirs)
        dirname = dirs(k).name;
        if endsWith(dirname,'train') % If training data directory
       
            path = strcat('../Caltech4/ImageData/', dirname);
            train_images = dir([path, '/*.JPG']); % Get images
            
            for im = 1:no_images_per_class
                 % Get descriptors of all feature points
                 [ ~, d ] = find_keypoints(imread(strcat(path, '/', train_images(im).name)), color_space, sift_method);

                 [ ~, no_feature_points ] = size(d); % Amount of feature points
            
                 descriptors(counter:counter + no_feature_points - 1, :) = d';
%                  size(d')
%                  length(nonzeros(d'))
                 counter = counter + no_feature_points;
          
                 if counter > max_length
                    break 
                 end
            end
       end
    end
    
    descriptors = descriptors(1:counter-1, :); % Cut off zeros
    descriptors = descriptors( any(descriptors, 2), :); % Delete zero rows
    size(descriptors)
    save(strcat('descriptors/', color_space, '_', sift_method, '_', no_vocab_images), 'descriptors');
end