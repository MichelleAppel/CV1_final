function [net, info, expdir] = finetune_cnn(varargin)

addpath '../Dependencies/liblinear-2.20/windows'


%% Define options
%run(fullfile(fileparts(mfilename('fullpath')), ...
%  '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;
run('../Dependencies/matconvnet-1.0-beta25/matlab/vl_setupnn.m')

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [1];



%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment
image_height = 32; % Input for the CNN
image_width = 32; % Input for the CNN
num_channels = 3; % Input for the CNN
num_images = 1865+200; % number of train+test images

% Init variables
data = zeros(image_height, image_width, num_channels, num_images);
labels = zeros(num_images, 1);
sets = zeros(num_images, 1);

i = 0; % Counter for images
myDir = '../Caltech4/ImageData/'; % Parent directory
theDirectories = dir(myDir);
for k = 1 : length(theDirectories)
    baseDirName = theDirectories(k).name;
    fullDirName = fullfile(myDir, baseDirName);
    filePattern = fullfile(fullDirName, '*.jpg'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    prev_i = i;
    disp(fullDirName)
    % Get all images within this directory
    for im = 1 : length(theFiles)
        i = i + 1;
        baseFileName = theFiles(im).name;
        fullFileName = fullfile(fullDirName, baseFileName);
        image = imread(fullFileName); % Read image

        % Resize the image to 32x32x3
        resized_image = imresize(image, [image_height image_width]);

        % Add to data matrix (if grayscale image, add values to 3 channels).
        if size(resized_image, 3) == 3
            data(:, :, :, i) = resized_image;
        else
            data(:, :, 1, i) = resized_image;
            data(:, :, 2, i) = resized_image;
            data(:, :, 3, i) = resized_image;
        end
    end

    % Set labels of all images within this directory
    if contains(fullDirName, "airplanes")
        labels(prev_i+1:i, :) = 1; % airplanes (== 1)
    elseif contains(fullDirName, "cars")
        labels(prev_i+1:i, :) = 2; % cars (== 2)
    elseif contains(fullDirName, "faces")
        labels(prev_i+1:i, :) = 3; % faces (== 3)
    elseif contains(fullDirName, "motorbikes")
        labels(prev_i+1:i, :) = 4; % motorbikes (== 4)
    end

    % Set sets of all images within this directory
    if contains(fullDirName, "train")
        sets(prev_i+1:i, :) = 1; % train (== 1)
    elseif contains(fullDirName, "test")
        sets(prev_i+1:i, :) = 2; % test  (== 2)
    end

end
%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = single(data);
imdb.images.labels = single(labels);
imdb.images.set = single(sets);
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
