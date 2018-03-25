close all; clear;

run('/Users/zhangrao/Documents/NOW/EE368/hw/vlfeat-0.9.21/toolbox/vl_setup.m');
cd('/Users/zhangrao/Documents/NOW/EE368/hw/hw7/hw7_data');

% training
load('hw7_training_descriptors.mat');
k = 10;
n_leaves = 10000;
[tree, assign] = vl_hikmeans(uint8(trainingDescriptors), k, n_leaves);

% testing
db_files = dir('painting_db/*.jpg');
qr_files = dir('painting_query/*.jpg');

% parameters
thres_peak = 2;
thres_edge = 15;

% reading database
db_feats = zeros(n_leaves, length(db_files));
db_imgs = cell(size(db_files));

for n = 1 : length(db_files)
    display(strcat(num2str(n), ': db under processing'));
    
    img = imread(strcat('painting_db/', db_files(n).name));
    img_gray = rgb2gray(img);
    [fs, ds] = vl_sift(single(img_gray), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
    
    % quantize descriptors through vocabulary tree
    tree_paths = vl_hikmeanspush(tree, ds);
    
    % compute histogram over leaf bins
    tree_hist = vl_hikmeanshist(tree, tree_paths);
    leaf_hist = tree_hist(end - n_leaves + 1 : end);
    leaf_pmf = leaf_hist / sum(leaf_hist);
    
    
    db_feats(:, n) = leaf_pmf;
    db_imgs{n} = img;
end

%% reading queries
qr_feats = zeros(n_leaves, length(qr_files));
qr_imgs = cell(size(qr_files));

tstart = tic;
for n = 1 : length(qr_files)
    display(strcat(num2str(n), ': query under processing'));
    
    % timer starts
    ts = tic;
    img = imread(strcat('painting_query/', db_files(n).name));
    img_gray = rgb2gray(img);
    [fs, ds] = vl_sift(single(img_gray), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);

    % quantize descriptors through vocabulary tree
    tree_paths = vl_hikmeanspush(tree, ds);
    
    % compute histogram over leaf bins
    tree_hist = vl_hikmeanshist(tree, tree_paths);
    leaf_hist = tree_hist(end - n_leaves + 1 : end);
    leaf_pmf = leaf_hist / sum(leaf_hist);
    
    % timer ends
    toc(ts);
    
    qr_feats(:, n) = leaf_pmf;
    qr_imgs{n} = img;
end
avg_extract_time = toc(tstart) / length(qr_files);

%%
n_largest = 10;
results = zeros(length(qr_files), n_largest); 

qstart = tic;
for ii = 1 : length(qr_files)
    display(strcat(num2str(ii), ': in query'));

    % timer starts
    qs = tic;
    
    % find top 10
    base = repmat(qr_feats(:, ii), [1, length(db_files)]);
    l1_dist = sum(abs(base - db_feats));
    [vals, idxs] = sort(l1_dist);
    results(ii, :) = idxs(1 : n_largest);
    
    % timer ends
    toc(qs);
    
    % plot and save
    figure; 
    h1 = imshowpair(qr_imgs{ii}, db_imgs{idxs(1)}, 'montage');
    imwrite(h1.CData, strcat('q3_query_', num2str(ii), '.png'));
    h2 = figure;
    for jj = 1 : n_largest
        subplot(2, 5, jj);
        imshow(db_imgs{idxs(jj)});
        title(num2str(vals(jj)));
    end
    saveas(h2, strcat('q3_max10_', num2str(ii), '.png'));
    
    % pause
    if ii < length(qr_files)
        pause
        close all;
    end
end
avg_query_time = toc(qstart) / length(qr_files);
