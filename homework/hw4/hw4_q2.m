close all; clear all;

% part (a)
x = linspace(-pi, pi, 100);
y = linspace(-pi, pi, 100);
[omega_x, omega_y] = meshgrid(x, y);

S = 2;

GSx = sin(omega_x / 2 * (2 * S + 1)) ./ sin(omega_x / 2);
GSy = sin(omega_y / 2 * (2 * S + 1)) ./ sin(omega_y / 2);
GS = GSx .* GSy;
G2Sx = sin(omega_x / 2 * (4 * S + 1)) ./ sin(omega_x / 2);
G2Sy = sin(omega_y / 2 * (4 * S + 1)) ./ sin(omega_y / 2);
G2S = G2Sx .* G2Sy;
HS = GS / ((2 * S + 1) ^ 2) - G2S / ((4 * S + 1) ^ 2);

figure;
mesh(omega_x, omega_y, HS);
xlim([-pi pi]);
ylim([-pi pi]);
saveas(gcf, 'q2_mesh.png');

% part (d)
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw4/hw4_data/hw4_';

% file_name = 'cd_cover';
file_name = 'ornament';
img = im2double(imread(strcat(src_dir, file_name, '.jpg')));
figure;
imshow(img);
imwrite(img, strcat('q2_', file_name, '.png'));

f1 = fspecial('average', [2 * S + 1, 2 * S + 1]);
f2 = fspecial('average', [4 * S + 1, 4 * S + 1]);
part1 = imfilter(img, f1, 'replicate', 'conv');
part2 = imfilter(img, f2, 'replicate', 'conv');
fimg = part1 - part2;
ffimg = (fimg - min(min(fimg))) / max(max(fimg));
figure;
imshow(ffimg);
imwrite(ffimg, strcat('q2_filtered_', file_name, '.png'));
