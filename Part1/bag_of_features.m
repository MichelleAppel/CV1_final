function [ BoF ] = bag_of_features(image, vocabulary, color_space, sift_method)

[ ~, descriptors ] = find_keypoints(image, color_space, sift_method);

descriptors = descriptors';

[~, I] = pdist2(vocabulary, double(descriptors), 'euclidean', 'Smallest', 1);

BoF = histcounts(I, size(vocabulary, 1));

BoF = BoF / sum(BoF); % Normalize

end