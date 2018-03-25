close all; clear;
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw3/hw3_data/';

% part (a)
clean_lic = imread(strcat(src_dir, 'hw3_license_plate_clean.png'));
figure
imshow(clean_lic);
noisy_lic = imread(strcat(src_dir, 'hw3_license_plate_noisy.png'));
figure
imshow(noisy_lic);

clean_lic_gray = 255 - rgb2gray(clean_lic); % inverse
imshow(clean_lic_gray);
noisy_lic_gray = 255 - rgb2gray(noisy_lic); % inverse

level = graythresh(clean_lic_gray);
clean_lic_bin = imbinarize(clean_lic_gray, level);
figure
imshow(clean_lic_bin);
imwrite(clean_lic_bin, 'q1_clean.png');

noisy_lic_bin = imbinarize(noisy_lic_gray, level);
figure
imshow(noisy_lic_bin);
imwrite(noisy_lic_bin, 'q1_noisy.png');

files = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

% figure
for n = 1 : length(files)
    tmp = imread(strcat(src_dir, 'Templates/', files(n), '.png'));
    tmp_gray = 255 - rgb2gray(tmp); % inverse
    tmp_bin = imbinarize(tmp_gray, level);
    subplot(6, 6, n);
    imshow(tmp_bin);
end
saveas(gcf,'q1_letters.png');

% part (b)
[rows, cols, channle] = size(clean_lic);
height = 20 : rows - 20;
width = 20 : cols - 20;
for n = 1 : length(files)
    tmp = imread(strcat(src_dir, 'Templates/', files(n), '.png'));
    tmp_gray = 255 - rgb2gray(tmp);     % inverse
    tmp_bin = imbinarize(tmp_gray, level);
    SE = imerode(tmp_bin, ones(3,3));   % erode to create struct element
    clean_lic_eroded = imerode(clean_lic_bin, SE);
    if sum(sum(clean_lic_eroded(height, width))) > 0
        figure
        clean_lic_dilate = imdilate(clean_lic_eroded, SE);
        orig_vs_dilate = max(0.5 .* clean_lic_gray, uint8(clean_lic_dilate * 255));
        imshow(orig_vs_dilate);
        imwrite(orig_vs_dilate, strcat('q1_clean_eroded_', files(n),'.png'));
    end
end

% part (c)
for n = 1 : length(files)
    tmp = imread(strcat(src_dir, 'Templates/', files(n), '.png'));
    tmp_gray = 255 - rgb2gray(tmp);     % inverse
    tmp_bin = imbinarize(tmp_gray, level);
    SE_fore = imerode(tmp_bin, ones(3, 3));   % erode to create struct element
    SE_back = imdilate(tmp_bin, ones(5, 5)) - imdilate(tmp_bin, ones(3, 3));
    clean_lic_hitmiss = bwhitmiss(clean_lic_bin, SE_fore, SE_back);
    if sum(sum(clean_lic_hitmiss(height, width))) > 0
        figure
        clean_lic_dilate = imdilate(clean_lic_hitmiss, SE_fore);
        orig_vs_dilate = max(0.5 .* clean_lic_gray, uint8(clean_lic_dilate * 255));
        imshow(orig_vs_dilate);
        imwrite(orig_vs_dilate, strcat('q1_clean_hitmiss_', files(n),'.png'));
    end
end

% part (d)
for n = 1 : length(files)
    tmp = imread(strcat(src_dir, 'Templates/', files(n), '.png'));
    tmp_gray = 255 - rgb2gray(tmp);     % inverse
    tmp_bin = imbinarize(tmp_gray, level);
    SE_fore = imerode(tmp_bin, ones(3, 3));   % erode to create struct element
    SE_back = imdilate(tmp_bin, ones(5, 5)) - imdilate(tmp_bin, ones(3, 3));
    noisy_lic_hitmiss = bwhitmiss(noisy_lic_bin, SE_fore, SE_back);
    if sum(sum(noisy_lic_hitmiss(height, width))) > 0
        figure
        clean_lic_dilate = imdilate(noisy_lic_hitmiss, SE_fore);
        orig_vs_dilate = max(0.5 .* noisy_lic_gray, uint8(noisy_lic_dilate * 255));
        imshow(orig_vs_dilate);
        imwrite(orig_vs_dilate, strcat('q1_noisy_hitmiss_', files(n),'.png'));
    end
end

% part (e)
for n = 1 : length(files)
    tmp = imread(strcat(src_dir, 'Templates/', files(n), '.png'));
    tmp_gray = 255 - rgb2gray(tmp);     % inverse
    tmp_bin = imbinarize(tmp_gray, level);
    SE_fore = imerode(tmp_bin, ones(3, 3));   % erode to create struct element
    noisy_lic_rank_fore = ordfilt2(noisy_lic_bin, 12, SE_fore);
    SE_back = imdilate(tmp_bin, ones(5, 5)) - imdilate(tmp_bin, ones(3, 3));
    noisy_lic_rank_back = ordfilt2(~noisy_lic_bin, 12, SE_back);
    noisy_lic_rank = min(noisy_lic_rank_fore, noisy_lic_rank_back);
    if sum(sum(noisy_lic_rank(height, width))) > 0
        figure
        noisy_lic_dilate = imdilate(noisy_lic_rank, SE_fore);
        orig_vs_dilate = max(0.5 .* noisy_lic_gray, uint8(noisy_lic_dilate * 255));
        imshow(orig_vs_dilate);
        imwrite(orig_vs_dilate, strcat('q1_noisy_rank_', files(n),'.png'));
    end
end