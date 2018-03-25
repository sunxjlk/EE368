close all; clear all;

src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw6/hw6_data/';
file_name = 'hw6_cover_';
file_num = 1;

img = imread(strcat(src_dir, file_name, num2str(file_num), '.jpg'));
img_bw = rgb2gray(img);
[rows, cols] = size(img_bw);
img_x_mid = cols / 2;
img_y_mid = rows / 2;

thres_peak = 4;
thres_edge = 10;

% part (a)
[frame, descriptor] = vl_sift(single(img_bw), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
img_old_x = frame(1,:);
img_old_y = frame(2,:);

h1 = figure;
imshow(img_bw); hold on;
vl_plotframe(frame);
saveas(h1, strcat('q2_a_', num2str(file_num), '.png'));


% part (b)
min_diff = 2;
angles = 0: 15: 360;
matches = zeros(size(angles));

for n = 1 : length(angles)
    angle = angles(n);
    % calculate all new coordinates
    img_r = imrotate(img_bw, angle, 'bicubic');
    
    % calculate new Harris key poing
    [new_frame, ~] = vl_sift(single(img_r), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
    img_new_x = new_frame(1, :);
    img_new_y = new_frame(2, :);
%     figure;
%     imshow(img_r); hold on;
%     plot(new_strongest);
    
    [rows_r, cols_r] = size(img_r);
    img_r_x_mid = cols_r / 2;
    img_r_y_mid = rows_r / 2;
    img_r_x = img_r_x_mid + (img_old_x - img_x_mid) * cosd(angle) + (img_old_y - img_y_mid) * sind(angle);
    img_r_y = img_r_y_mid + (img_old_y - img_y_mid) * cosd(angle) - (img_old_x - img_x_mid) * sind(angle);

    % compare one by one
    for ii = 1 : length(img_old_x)
        for jj = 1 : length(img_new_x)
            if abs(img_r_x(ii) - img_new_x(jj)) <= min_diff && abs(img_r_y(ii) - img_new_y(jj)) <= min_diff
                matches(n) = matches(n) + 1;
            end
        end
    end
end 

h2 = figure;
plot(angles, matches / max(matches), '-o', 'LineWidth', 2);
grid on;
xlim([0, 360]);
ylim([0, 1]);
xlabel('angle');
ylabel('match ratio');
title('repeatability against rotation');
saveas(h2, strcat('q2_b_', num2str(file_num), '.png'));


% part (c)
min_diff = 2;
scales = 1.2 .^ (0: 1: 8);
matches = zeros(size(scales));

for n = 1 : length(scales)
    scale = scales(n);
    % calculate all new coordinates
    img_r = imresize(img_bw, scale, 'bicubic');
    
    % calculate new Harris key poing
    [new_frame, ~] = vl_sift(single(img_r), 'PeakThresh', thres_peak, 'EdgeThresh', thres_edge);
    img_new_x = new_frame(1, :);
    img_new_y = new_frame(2, :);
%     figure;
%     imshow(img_r); hold on;
%     plot(new_strongest);
    
    [rows_r, cols_r] = size(img_r);
    img_r_x = img_old_x * scale;
    img_r_y = img_old_y * scale;

    % compare one by one
    for ii = 1 : length(img_old_x)
        for jj = 1 : length(img_new_x)
            if abs(img_r_x(ii) - img_new_x(jj)) <= min_diff && abs(img_r_y(ii) - img_new_y(jj)) <= min_diff
                matches(n) = matches(n) + 1;
            end
        end
    end
end 

h3 = figure;
semilogx(scales, matches / max(matches), '-o', 'LineWidth', 2);
grid on;
xlim([1, scale]);
ylim([0, 1]);
xlabel('scale');
ylabel('match ratio');
title('repeatability against scaling');
saveas(h3, strcat('q2_c_', num2str(file_num), '.png'));
