
class = 'faces';
color_space = 'RGB';
sift_method = 'dsift';
vocab_size = '400';

d = load(strcat('datasets\vocab_size_', vocab_size, '\data_', ...
    color_space, '_', sift_method, '_', class, '.mat'));

features = d.features;
td = tsne(features);

if strcmp(class, 'airplanes') || strcmp(class, 'motorbikes')
    boundary = 374;
elseif strcmp(class, 'faces')
    boundary = 300;
elseif strcmp(class, 'cars')
    boundary = 347;
end

figure
s1 = scatter(td(1:375, 1), td(1:375, 2), 5, [0 0.2 0.8]);
hold on
s2 = scatter(td(376:end, 1), td(376:end, 2), 5, [0 0.8 0]);

title(strcat({'T-sne of the BoF of '}, class, {' vs. other classes, vocab size: '}, ...
    vocab_size, {', '}, sift_method, {', '}, color_space, '.'))
legend(class, 'other')
[h, ~] = legend('show');


% legend('class 1','other classes','Location','southwest')