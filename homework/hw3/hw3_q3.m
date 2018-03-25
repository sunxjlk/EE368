close all; clear;
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw3/hw3_data/';

img = imread(strcat(src_dir, 'hw3_road_sign_school_blurry.jpg'));
figure
imshow(img);
imwrite(img, 'q3_blur.png');

% structuring element
% SE = zeros(21, 21);
% SE(2: 20, 6: 16) = 1;
% SE(6: 16, 2: 20) = 1;
SE = strel('diamond', 12);
figure
imshow(SE.Neighborhood);
imwrite(SE.Neighborhood, 'q3_se.png');

figure
subplot(7, 1, 1);
plot(img(338, :));
title('original image');
NumIterations = 6;
for iter = 1: NumIterations
    Im_d = imdilate(img, SE);
    Im_e = imerode(img, SE); 
    Im_h = 0.5 * (Im_d + Im_e);
    % Perform the following test for each pixel
    mask_pos = (img > Im_h);
    mask_neg = ~mask_pos;
    values = img(338, :);
    img = uint8(mask_pos) .* Im_d + uint8(mask_neg) .* Im_e;
    subplot(7, 1, 1 + iter)
    plot(values);
    title(strcat('iteration #', num2str(1 + iter)));
end
saveas(gcf,'q3_plot.png')

figure
imshow(img);
imwrite(img, 'q3_sharpen.png');
