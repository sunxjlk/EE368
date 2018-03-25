close all; clear all;

% part(a)
open('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_chroma_solid.fig');
hold all;
rgb2xyz = [0.490 0.310 0.200; 0.177 0.813 0.011; 0.000 0.010 0.990];
cubeRGB = [0 0 0;       % 1
           0 0 1;       % 2
           0 1 0;       % 3
           0 1 1;       % 4
           1 0 0;       % 5
           1 0 1;       % 6
           1 1 0;       % 7
           1 1 1].';    % 8
cubeXYZ = rgb2xyz * cubeRGB;
p = cubeXYZ.';
plot3([p(1, 1) p(2, 1)], [p(1, 2) p(2, 2)], [p(1, 3) p(2, 3)], 'b', 'LineWidth', 4); %(1, 2)
hold all;
plot3([p(3, 1) p(4, 1)], [p(3, 2) p(4, 2)], [p(3, 3) p(4, 3)], 'b', 'LineWidth', 4); %(3, 4)
hold all;
plot3([p(5, 1) p(6, 1)], [p(5, 2) p(6, 2)], [p(5, 3) p(6, 3)], 'b', 'LineWidth', 4); %(5, 6)
hold all;
plot3([p(7, 1) p(8, 1)], [p(7, 2) p(8, 2)], [p(7, 3) p(8, 3)], 'b', 'LineWidth', 4); %(7, 8)
hold all;
plot3([p(1, 1) p(3, 1)], [p(1, 2) p(3, 2)], [p(1, 3) p(3, 3)], 'b', 'LineWidth', 4); %(1, 3)
hold all;
plot3([p(2, 1) p(4, 1)], [p(2, 2) p(4, 2)], [p(2, 3) p(4, 3)], 'b', 'LineWidth', 4); %(2, 4)
hold all;
plot3([p(5, 1) p(7, 1)], [p(5, 2) p(7, 2)], [p(5, 3) p(7, 3)], 'b', 'LineWidth', 4); %(5, 7)
hold all;
plot3([p(6, 1) p(8, 1)], [p(6, 2) p(8, 2)], [p(6, 3) p(8, 3)], 'b', 'LineWidth', 4); %(6, 8)
hold all;
plot3([p(1, 1) p(5, 1)], [p(1, 2) p(5, 2)], [p(1, 3) p(5, 3)], 'b', 'LineWidth', 4); %(1, 5)
hold all;
plot3([p(2, 1) p(6, 1)], [p(2, 2) p(6, 2)], [p(2, 3) p(6, 3)], 'b', 'LineWidth', 4); %(2, 6)
hold all;
plot3([p(3, 1) p(7, 1)], [p(3, 2) p(7, 2)], [p(3, 3) p(7, 3)], 'b', 'LineWidth', 4); %(3, 7)
hold all;
plot3([p(4, 1) p(8, 1)], [p(4, 2) p(8, 2)], [p(4, 3) p(8, 3)], 'b', 'LineWidth', 4); %(4, 8)
hold all;

% part (b)
load('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_chroma_map.mat');
[row, col] = size(IN);
pic = zeros([row, col, 3]);
mask = zeros([row, col, 3]);
S = 2.0;
a = [S 0 0; 0 S 0; -S -S 0];
b = [0 0 S].';
RGB2XYZ = [0.490 0.310 0.200; 0.177 0.813 0.011; 0.000 0.010 0.990];
for r = 1 : row
    for c = 1 : col
        if IN(r, c)     % this is white part
             y = r / row;
             x = c / col;
             z = 1 - x - y; 
             XYZ = a * [x; y; z] + b;
             RGB = RGB2XYZ \ XYZ;
             pic(r, c, :) = max([0; 0; 0], min([1; 1; 1], RGB));
             if max(RGB) > 1 || min(RGB) < 0
                 mask(r, c, :) = [1; 1; 1];
             end
        end
    end
end
gamma = 2.2;
figure
subplot(1, 2, 1);
imshow(pic .^ (1 / gamma));
subplot(1, 2, 2);
imshow(mask);


