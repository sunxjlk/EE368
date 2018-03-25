close all; clear all;
run('/Users/zhangrao/Documents/NOW/EE368/hw/vlfeat-0.9.21/toolbox/vl_setup.m');
img = imread('/Users/zhangrao/Documents/NOW/EE368/hw/hw7/hw7_data/hw7_building.jpg');
img_gray = rgb2gray(img);

% part (a)
thres_peak = 4;
thres_edge = 10;
[frame, descriptor] = vl_sift(single(img_gray), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);

h1 = figure;
imshow(img_gray);
hold on;
vl_plotframe(frame);
saveas(h1, 'q1_a.png');

% part (b)
offsets = -100 : 20 : 100;
matches = zeros(size(offsets));
for n = 1 : length(offsets)
    offset = offsets(n);
    img_offset = uint8(double(img_gray) + offset);
    [frame_b, descriptor_b] = vl_sift(single(img_offset), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge, 'Frames', frame);
    match = vl_ubcmatch(descriptor, descriptor_b);
    matches(n) = size(match, 2); 
end

h2 = figure;
plot(offsets, matches / max(matches), '-o', 'LineWidth', 2); 
grid on;
title('robustness of brightness');
xlabel('brightness offest');
ylabel('match ratio');
xlim([min(offsets), max(offsets)]);
ylim([0, 1]);
saveas(h2, 'q1_b.png');

% part (c)
gammas = 0.50 : 0.25 : 2.00;
matches = zeros(size(gammas));
for n = 1 : length(gammas)
    gamma = gammas(n);
    img_double = im2double(img_gray);
    img_gamma = uint8((img_double .^ gamma) * 255);
    [frame_c, descriptor_c] = vl_sift(single(img_gamma), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge, 'Frames', frame);
    match = vl_ubcmatch(descriptor, descriptor_c);
    matches(n) = size(match, 2);
end

h3 = figure;
plot(gammas, matches / max(matches), '-o', 'LineWidth', 2); 
grid on;
title('robustness of contrast');
xlabel('constrast index');
ylabel('match ratio');
xlim([min(gammas), max(gammas)]);
ylim([0, 1]);
saveas(h3, 'q1_c.png');

% part (d)
sigmas = 0 : 5 : 30;
matches = zeros(size(sigmas));
for n = 1 : length(sigmas);
    sigma = sigmas(n);
    img_double = double(img_gray);
    img_gaussian = uint8(img_double + sigma * randn(size(img_double)));
    [frame_d, descriptor_d] = vl_sift(single(img_gaussian), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge, 'Frames', frame);
    match = vl_ubcmatch(descriptor, descriptor_d);
    matches(n) = size(match, 2);
end

h4 = figure;
plot(sigmas, matches / max(matches), '-o', 'LineWidth', 2); 
grid on;
title('robustness of additive gaussian noise');
xlabel('sigma');
ylabel('match ratio');
xlim([min(sigmas), max(sigmas)]);
ylim([0, 1]);
saveas(h4, 'q1_d.png');

% part (e)
sigmas = 1 : 10;
matches = zeros(size(sigmas));
for n = 1 : length(sigmas);
    sigma = sigmas(n);
    window = 10 * sigma + 1;
    kernel = fspecial('gaussian', [window, window], sigma);
    img_filter = imfilter(img_gray, kernel, 'symmetric');
    [frame_e, descriptor_e] = vl_sift(single(img_filter), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge, 'Frames', frame);
    match = vl_ubcmatch(descriptor, descriptor_e);
    matches(n) = size(match, 2);
end

h5 = figure;
plot(sigmas, matches / max(matches), '-o', 'LineWidth', 2); 
grid on;
title('robustness of gaussian filter');
xlabel('sigma');
ylabel('match ratio');
xlim([min(sigmas), max(sigmas)]);
ylim([0, 1]);
saveas(h5, 'q1_e.png');

