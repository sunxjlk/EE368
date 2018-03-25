close all; clear;
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw3/hw3_data/hw3_';

str = 'building';
% str = 'train';
image = imread(strcat(src_dir, str, '.jpg'));

% part (a)
wd = 5;
proc_img = medfilt2(image, [wd wd]);
% figure
himage = imshowpair(image, proc_img, 'montage');
imwrite(himage.CData, strcat('q4_denoise_', str, '_', num2str(wd), '.png'));

% part (b)
w = [0 1 1 1 0;
     1 2 2 2 1;
     1 2 4 2 1;
     1 2 2 2 1;
     0 1 1 1 0];
[rows, cols] = size(image);
image_i = image;
image_o = zeros(rows, cols);

for r = [1, 2, rows - 1, rows - 2]
    for c = [1, 2, cols - 1, cols - 2]
        image_o(r, c) = image_i(r, c);
    end
end

for r = 3 : rows - 2
    for c = 3 : cols - 2
        num = sum(sum(w));
        set = zeros(1, num);
        idx = 1;
        for dr = -2 : 2
            for dc = -2 : 2
                weight = w(3 + dr, 3 + dc);
                pixel = image_i(r + dr, c + dc);
                for k = 1 : weight
                    set(idx) = pixel;
                    idx = idx + 1;
                end
            end
        end
        image_o(r, c) = uint8(median(set));
    end
end

figure
himage = imshowpair(image_i, image_o, 'montage');
imwrite(himage.CData, strcat('q4_weighted_denoise_', str, '.png'));