clear all; close all;

% part (a)
page1 = imread('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_book_page_1.jpg');
page1 = imread('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_book_page_2.jpg');
level1 = graythresh(page1);
imbin1 = imbinarize(page1, level1);
figure
subplot(1, 2, 1);
imshow(imbin1);
subplot(1, 2, 2);
histogram(double(page1) ./ max(max(max(double(page1))))); hold on;
ypoints = linspace(0, 3e5, 5);
xpoints = level1 * ones(1, 5);
plot(xpoints, ypoints, 'linewidth', 2);
txt1 = strcat('T = ', num2str(level1));
text(xpoints(3),ypoints(3),txt1);
ylabel('frequency');

% part (b)
threshold = 0.12;  
wd_size = 11; % window size
wd_half = floor((wd_size - 1) / 2);
image = imread('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_book_page_2.jpg');
imgcopy = zeros(size(image));
[nRows, nCols] = size(image);
for col = 1 : nCols
    left = max(1, col - wd_half);
    right = min(nCols, col + wd_half);
    subimg = image(1 : nRows, left : right);
    sublevel = graythresh(subimg);
    submean = mean(mean(double(subimg)));
    subvar = sum(sum((subimg - submean) .^ 2)) / double(nCols * nRows);
    if subvar > threshold
        imgcopy(:, col) = imbinarize(image(:,col), sublevel);
    else
        imgcopy(:, col) = 255;
    end
end
figure
imshow (imgcopy);





