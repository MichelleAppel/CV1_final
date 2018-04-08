d = load('datasets\vocab_size_50\data_opponent_sift_cars.mat');
features = d.features;
td = tsne(features);
color = zeros(length(td), 1);
color(300:end, :) = 5;
color(end, :) = 8;

figure
scatter(td(:, 1), td(:, 2), 5, color)
title('T-sne of the features')
% legend('class 1','other classes','Location','southwest')
