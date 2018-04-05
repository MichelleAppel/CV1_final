function [ visual_vocab ] = visual_vocabulary(descriptors, K, color_space, sift_method)

    if nargin < 2
       K = 400; % Default vocabulary size 
    end
    
    [ centroids, ~ ] = vl_kmeans(descriptors', K); % Assign clusters to descriptors
    visual_vocab = centroids';
    
    save(strcat('vocab/visual_vocab', '_', string(K), '_', color_space, '_', sift_method), 'visual_vocab');

end