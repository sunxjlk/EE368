close all;
% load images
road1 = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_dark_road_1.jpg');
road2 = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_dark_road_2.jpg');
road3 = imread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_dark_road_3.jpg');

% plot hist
figure
subplot(1, 2, 1);
imshow(road1);
subplot(1, 2, 2);
imhist(road1)
ylim auto

figure
subplot(1, 2, 1);
imshow(road2);
subplot(1, 2, 2);
imhist(road2);
ylim auto

figure
subplot(1, 2, 1);
imshow(road3);
subplot(1, 2, 2);
imhist(road3);
ylim auto


% plot histeq
road1_eq = histeq(road1);
road2_eq = histeq(road2);
road3_eq = histeq(road3);

figure
subplot(1, 2, 1);
imshow(road1_eq);
subplot(1, 2, 2);
imhist(road1_eq);
ylim auto

figure
subplot(1, 2, 1);
imshow(road2_eq);
subplot(1, 2, 2);
imhist(road2_eq);
ylim auto

figure
subplot(1, 2, 1);
imshow(road3_eq);
subplot(1, 2, 2);
imhist(road3_eq);
ylim auto

% plot adaptive histeq
road1_adp = adapthisteq(road1, 'NumTiles',[16 16],'ClipLimit', 0.012);
road2_adp = adapthisteq(road2, 'NumTiles',[16 16],'ClipLimit',0.012);
road3_adp = adapthisteq(road3, 'NumTiles',[16 16],'ClipLimit',0.012);

figure
subplot(1, 2, 1);
imshow(road1_adp);
subplot(1, 2, 2);
imhist(road1_adp);
ylim auto

figure
subplot(1, 2, 1);
imshow(road2_adp);
subplot(1, 2, 2);
imhist(road2_adp);
ylim auto

figure
subplot(1, 2, 1);
imshow(road3_adp);
subplot(1, 2, 2);
imhist(road3_adp);
ylim auto

