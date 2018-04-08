function [ avg_precision ] = avg_precision(vocab_size, color_space, sift_method, class)

if nargin < 1
    vocab_size = 200;
end
if nargin < 2
    color_space = 'gray';
end
if nargin < 3
    sift_method = 'sift';
end
if nargin < 4
    class = 'airplanes';
end

file_name = strcat('results/vocab_size_', int2str(vocab_size), ...
    '/results_', color_space, '_', sift_method, '_', class, '.mat');
results = load(file_name);
results = results.sorted_results;
% results is sorted from large to small values, but the highest certainty
% of the current class starts with the lowest (negative) value,
% so flip the order
results = flipud(results);
%scores = results(:, 1:2);
%predicted = results(:, 3);
%correct = results(:, 4);
file_names = results(:, 5);

m_c = 50;   % no test images per class
n = 200;    % total amount of test images

summation = 0;
x_i = 0;
for i = 1:n
    if contains(file_names{i}, class)
        x_i = x_i + 1;
        summation = summation + x_i / i;
    end
end
avg_precision = summation / m_c; % avg precision for one class

end
