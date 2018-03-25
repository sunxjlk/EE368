close all; clear all;

% part (a)
[x, y] = meshgrid(linspace(-256, 256, 1 * 512 + 1), linspace(-256, 256, 1 * 512 + 1));
f_hat = -112;
f_zero = 128;
a_x = pi / 512;
a_y = pi / 512;
f_xy = f_hat * cos(a_x * x .^ 2 + a_y * y .^ 2) + f_zero;
img_f = uint8(f_xy);
figure
imshow(img_f);
imwrite(img_f, 'q3_part_a.png');

% part (b)
T = 2;
ft_xy = zeros(size(f_xy));
for i = 1 : size(y, 1)
    if mod(y(i), T) == 0
        ft_xy(i, :) = f_xy(i, :);
    end
end
img_ft = uint8(ft_xy);
figure
imshow(img_ft);
imwrite(img_ft, strcat('q3_part_b_T', num2str(T), '.png'));

% part (c)
gt_xy = zeros(size(f_xy));
for i = 1 : size(y, 1);
    if mod(y(i) - T / 2, T) == 0
        gt_xy(i, :) = f_xy(i, :);
    end 
end
img_gt = uint8(gt_xy);
figure
imshow(img_gt);
imwrite(img_gt, strcat('q3_part_c_T', num2str(T), '.png'));

