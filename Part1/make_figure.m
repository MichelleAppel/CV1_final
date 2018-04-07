d = load('datasets\vocab_size_800\data_RGB_sift_airplanes.mat');
features = d.features;
td = tsne(features);
color = zeros(length(td), 1);
color(374:end, :) = 5;
color(end, :) = 8;
scatter(td(:, 1), td(:, 2), 5, color)