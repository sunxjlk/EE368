close all;
clear all;
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw4/hw4_data/hw4_satellite_';

file_no = 1;
img = im2double(imread(strcat(src_dir, num2str(file_no), '_degraded.tiff')));
img_copy = img;
figure
imshow(img);

% part (a)
[rows, cols] = size(img);
block = 16;
row_block = floor(rows / block);
col_block = floor(cols / block);
area_stds = ones(row_block, col_block);
for r = 1 : row_block
    rr = (r - 1) * block + 1 : min(r * block, rows);
    for c = 1 : col_block;
        cc = (c - 1) * block + 1 : min(c * block, cols);
        area = img(rr, cc);
        area_mean = mean(mean(area));
        area_std = sqrt(mean(mean((area - area_mean) .^ 2)));
        area_stds(r, c) = area_std;
    end
end
sort_stds = sort(reshape(area_stds, [1, row_block * col_block]));
min_std = sort_stds(20);

% part (b)
line_no = 280;
SE = strel('diamond', 12);
% figure
NumIterations = 6;
subplot(NumIterations + 2, 1, 1);
plot(img(line_no, :));
title('original image');
for iter = 1: NumIterations
    Im_d = imdilate(img, SE);
    Im_e = imerode(img, SE);
    Im_h = 0.5 * (Im_d + Im_e);
    % Perform the following test for each pixel
    mask_pos = (img > Im_h);
    mask_neg = ~mask_pos;
    values = img(line_no, :);
    img = double(mask_pos) .* Im_d + double(mask_neg) .* Im_e;
    subplot(NumIterations + 2, 1, 1 + iter)
    plot(values);
    title(strcat('iteration #', num2str(iter)));
end

% figure;
% imshow(img);
% imwrite(img, strcat('q4_sharp_', num2str(file_no), '.png'));

min_sigma = 11;
min_var = 1e12;
for sigma = 1 : 20
    kernal = fspecial('gaussian', [5 * sigma + 1, 5 * sigma + 1], sigma);
    blur_img = imfilter(img, kernal, 'conv', 'circular');
    part1 = img_copy / max(img_copy(:));
    part2 = blur_img / max(blur_img(:));
    tbd = abs(part1 - part2);
    tbd = tbd / max(tbd(:));
    variance = sum(tbd(:));
    if variance < min_var
        min_var = variance;
        min_sigma = sigma;
    end
end
min_sigma = min_sigma + 1;
subplot(NumIterations + 2, 1, NumIterations + 2);
plot(blur_img(line_no, :));
title('Gaussian blurred image');
saveas(gcf, strcat('q4_plot_', num2str(file_no), '.png'));

% part (c)
kernal = fspecial('gaussian', [5 * sigma + 1 5 * sigma + 1], min_sigma);
direct_inv = deconvwnr(img_copy, kernal, 0);
figure;
imshow(direct_inv);
imwrite(direct_inv, strcat('q4_inv_', num2str(file_no), '.png'));

% part (d)
wiener_img = deconvwnr(img_copy, kernal, min_std ^ 2 / var(img_copy(:)));
figure;
imshow(wiener_img);
imwrite(wiener_img, strcat('q4_wiener_', num2str(file_no), '.png'));