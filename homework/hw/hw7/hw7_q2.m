close all; clear all;
run('/Users/zhangrao/Documents/NOW/EE368/hw/vlfeat-0.9.21/toolbox/vl_setup.m');
cd('/Users/zhangrao/Documents/NOW/EE368/hw/hw7/hw7_data');

database_files = dir('poster_db/*.jpg');
thres_peak = 4;
thres_edge = 10;
shrink_to = 1000; % pixels
database_imgs = cell(size(database_files));
database_feats = cell(size(database_files));

% database pre-processing
for n = 1 : length(database_files)
    display(strcat(num2str(n), ': under processing'));
    img = imread(strcat('poster_db/', database_files(n).name));
    shrink_ratio = shrink_to / size(img, 2);
    img_shrink = imresize(img, shrink_ratio, 'bicubic');
    img_shrink_gray = rgb2gray(img_shrink);
    [fs, ds] = vl_sift(single(img_shrink_gray), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
    database_imgs{n} = img_shrink;
    database_feats{n}.f = fs;
    database_feats{n}.d = ds;
end

% inquery the database
query_images = {'hw7_poster_1.jpg', 'hw7_poster_2.jpg', 'hw7_poster_3.jpg'};
% query_feats = cell(size(query_images));
for n = 1 : length(query_images)
    display(strcat(num2str(n), ': query in the database'));
    img = imread(query_images{n});
    img_gray = rgb2gray(img);
    [fq, dq] = vl_sift(single(img_gray), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
    query_feats.f = fq;
    query_feats.d = dq;
    % start to compare match ratio
    max_ratio = 0;
    max_index = 0;
    for ii = 1 : length(database_files)
        match_result = sift_match(img, database_imgs{ii}, query_feats, database_feats{ii});
        if match_result.ransac > max_ratio
            max_ratio = match_result.ransac;
            max_index = ii;
        end
    end
    % show time
    sift_match(img, database_imgs{max_index}, query_feats, database_feats{max_index});
    if n < length(query_images)
        pause
    end
end