function [ visual_vocab ] = save_visual_vocabulary(descriptors, color_space, sift_method, no_vocab_images, max_length, K, filename)

    if nargin < 2
       color_space = 'gray';
    end
    if nargin < 3
       sift_method = 'sift';
    end
    if nargin < 4
       no_vocab_images = 1000; % Default number of images to make the vocabulary with
    end
    if nargin < 5
        max_length = 6000000; % Default maximum amount of descriptors
    end
    if nargin < 1 || isempty(descriptors)
        descriptors = cat_descriptors(color_space, sift_method, no_vocab_images, max_length);
    end
    if nargin < 6
       K = 400; % Default vocabulary size 
    end
    if nargin < 7
       filename = strcat(sift_method, '_', color_space, '_', string(K)); % Default filename
    end
    
    %save(strcat('descriptors/descriptors_', filename), 'descriptors') % Save the descriptors
    
    visual_vocab = visual_vocabulary(descriptors, K); % Create visual vocabulary
    save(strcat('vocab/visual_vocab_', filename), 'visual_vocab') % Save the visual vocabulary
end