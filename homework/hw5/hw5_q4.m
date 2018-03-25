close all; clear all;

img_file = './hw5_data/hw5_insurance_form.jpg';
img_uint8 = imread(img_file);
img_double = im2double(img_uint8);
[rows, cols] = size(img_uint8);

% Step 1: binarize image
thresh = graythresh(img_double);
img_bw = img_double < thresh;
figure;
temp = imshowpair(img_double, img_bw, 'montage');
imwrite(temp.CData, 'q4_binarize.png');

% Step 2: calculate hough transform
n_peaks = 40;
angles = -90 : 0.5 : 89.5;
[H, theta, rho] = hough(img_bw, 'Theta', angles);
peak_thresh = 0.4 * max(H(:));
peaks = houghpeaks(H, n_peaks, 'Threshold', peak_thresh);
theta_hist = hist(theta(peaks(:,2)), angles);

h = figure;
subplot(2, 1, 2);
imshow(imadjust(mat2gray(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit'); 
axis normal;
axis on;
grid on;
hold on;
plot(theta(peaks(:,2)), rho(peaks(:,1)), 'r^');
xlabel('\theta (degrees)'); 
ylabel('\rho');


subplot(2, 1, 1);
bar(angles, theta_hist, 'r'); 
grid on;
axis on;
axis normal;
xlabel('\theta (degrees)'); 
ylabel('Number of Peaks');
xlim([-90, 89.5]);
[~, idx] = max(theta_hist);
theta_max = angles(idx);
rotate_angle = theta_max + 90;
saveas(h, 'q4_hough.png');


% Step 3: rotate image
img_anti = imrotate(1 - img_double, rotate_angle, 'bilinear', 'crop');
img_orig = 1 - img_anti;
figure; 
temp = imshowpair(img_orig, img_anti, 'montage');
imwrite(temp.CData, 'q4_rotate.png');


% backup img_anti
img_anti_copy = img_anti;

% Step 4: vertical erode, vertical closing
SE = strel('arbitrary', ones(35, 1));
img_anti_eroded = imerode(img_anti, SE);

SE = strel('arbitrary', ones(201, 1));
img_anti_eroded_closed = imclose(img_anti_eroded, SE);
figure; 
temp = imshowpair(img_anti_eroded, img_anti_eroded_closed, 'montage'); 
imwrite(temp.CData, 'q4_vertical_close.png');


img_anti = max(img_anti, img_anti_eroded_closed);
figure;  
temp = imshowpair(img_anti_copy, img_anti, 'montage'); 
imwrite(temp.CData, 'q4_vertical_enhance.png');


% img_anti backup
img_copy = img_anti;

% Step 5: horizontal erode, horizontal closing
SE = strel('arbitrary', ones(1, 49));
img_anti_eroded = imerode(img_anti, SE);

SE = strel('arbitrary', ones(1, 301));
img_anti_eroded_closed = imclose(img_anti_eroded, SE);
figure;
temp = imshowpair(img_anti_eroded, img_anti_eroded_closed, 'montage');
imwrite(temp.CData, 'q4_horizontal_close.png');

img_anti = max(img_anti, img_anti_eroded_closed);
figure; 
temp = imshowpair(img_anti_copy, img_anti, 'montage');
imwrite(temp.CData, 'q4_horizontal_enhance.png');


% Enhanced image
img_enhanced = 1 - img_anti;
temp = imshowpair(img_double, img_enhanced, 'montage');
imwrite(temp.CData, 'q4_compare.png');
