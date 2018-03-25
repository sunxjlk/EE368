close all; clear;
img1_ref = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_painting_2_reference.jpg');
img1_tmp = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_painting_2_tampered.jpg');
% img1_ref = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_painting_1_reference.jpg');
% img1_tmp = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_painting_1_tampered.jpg');

img1_size = size(img1_ref);
mid_x = floor(img1_size(1) / 2);
mid_y = floor(img1_size(2) / 2);
dim1 = mid_x - 10 : 1 : mid_x + 10;
dim2 = mid_x - 10 : 1 : mid_x + 10;
dim3 = 1 : 1 : 3;

img1_ref_part = img1_ref(dim1, dim2, dim3);
mse = mean(mean(mean(img1_ref_part .^ 2)));
frame = img1_tmp;
shifted = frame;

for dx = -3 : 1 : 3
    for dy = -3 : 1 : 3
        A = [1 0 dx; 0 1 dy; 0 0 1];
        tform = maketform('affine', A.');
        [height, width, channels] = size(frame);
        frameTform = imtransform(frame, tform, 'bilinear', 'XData', [1 width], 'YData', [1 height], 'FillValues', zeros(channels, 1));
        se = mean(mean(mean((frameTform(dim1, dim2, dim3) - img1_ref_part) .^ 2))); 
        if se < mse
            mse = se;
            shifted = frameTform;
        end
    end
end

figure
diff = double(img1_ref) - double(shifted);
imshow(diff)

diff_sum = sum(abs(diff), 3);
binary_diff = diff_sum .* double(diff_sum > 30);
figure
imshow(binary_diff);

% gray_diff = rgb2gray(diff);
% binary_diff = gray_diff .* uint8(gray_diff >= 1);
% figure
% imshow(binary_diff);
