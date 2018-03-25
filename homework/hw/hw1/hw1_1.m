clear;
close all; 

% 1(b)
hdr1 = hdrread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_memorial.hdr');
gray1 = rgb2gray(hdr1);
hdr2 = hdrread('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_atrium.hdr');
gray2 = rgb2gray(hdr2);

figure
subplot(1,2,1);
imshow(hdr1);
subplot(1,2,2);
imshow(gray1);

figure
subplot(1,2,1);
imshow(hdr2);
subplot(1,2,2);
imshow(gray2);

% 1(c)
gamma1 = 2.2; 
gray1_in = gray1;
gray1_out = imadjust(gray1_in, [0 1], [0 1], 1/gamma1);

gamma2 = 2.8;
gray2_in = gray2;
gray2_out = imadjust(gray2_in, [0 1], [0 1], 1/gamma2);

figure
subplot(1,2,1);
imshow(gray1_out);
subplot(1,2,2);
imshow(gray2_out);

% 1(d)
% the same gamma
gamma_v1 = [2.2, 2.2, 2.2];
hdr1_in = hdr1;
hdr1_out = imadjust(hdr1_in, [0 1], [0 1], 1./gamma_v1);

gamma_v2 = [2.8, 2.8, 2.8];
hdr2_in = hdr2;
hdr2_out = imadjust(hdr2_in, [0 1], [0 1], 1./gamma_v2);

figure
subplot(1,2,1);
imshow(hdr1_out);
subplot(1,2,2);
imshow(hdr2_out);

% different gammas
gamma_u1 = [1.0, 2.0, 3.0];
hdr1_in = hdr1;
hdr1_out = imadjust(hdr1_in, [0 1], [0 1], 1./gamma_u1);

gamma_u2 = [3.0, 2.0, 1.0];
hdr2_in = hdr2;
hdr2_out = imadjust(hdr2_in, [0 1], [0 1], 1./gamma_u2);

figure
subplot(1,2,1);
imshow(hdr1_out);
subplot(1,2,2);
imshow(hdr2_out);