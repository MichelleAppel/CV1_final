function [ visual_vocab ] = visual_vocabulary(descriptors, K, color_space, sift_method)

    if nargin < 2
       K = 400; % Default vocabulary size 
    end
    if nargin < 3
        color_space = 'gray';
    end
    if nargin < 4
        sift_method = 'sift';
    end
    
    [ centroids, ~ ] = vl_kmeans(descriptors', K); % Assign clusters to descriptors
    visual_vocab = centroids';
    
    %save(strcat('vocab/visual_vocab', '_', string(K), '_', color_space, '_', sift_method), 'visual_vocab');
    file_name = strcat('vocab_', int2str(K), '_', color_space, '_', sift_method);
    save(fullfile('vocabs', strcat('vocab_size_', int2str(K)), file_name), 'visual_vocab');
     
end