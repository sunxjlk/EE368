close all;
clear all;

load('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_XYZ.mat');
wl = wavelength;
x = XYZSpectra(:, 1);
y = XYZSpectra(:, 2);
z = XYZSpectra(:, 3);
figure
h1 = plot(wl, x, 'r', wl, y, 'g', wl, z, 'b');
set(h1, 'LineWidth', 2);
grid on;
legend('x', 'y', 'z');
xlabel('wavelength');
ylabel('tristimulus values');

load('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_light.mat');
figure
plot(wl, light1Spectrum, 'LineWidth', 2);
grid on;
xlabel('wavelength');
ylabel('strength');

load('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_face.mat');
[row, col, deep] = size(face1Spectrum);
reshapeLight1Spectrum = reshape(light1Spectrum, [1, 1, deep]);
repeatLight1Spectrum = repmat(reshapeLight1Spectrum, [row, col, 1]);
face1light1 = face1Spectrum .* repeatLight1Spectrum;    % add light

load('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_display.mat');
xx = display1Spectra(:, 1);
yy = display1Spectra(:, 2);
zz = display1Spectra(:, 3);
figure
h2 = plot(wl, xx, 'r', wl, yy, 'g', wl, zz, 'b');
set(h2, 'LineWidth', 2);
grid on;
xlabel('wavelength');
ylabel('strength');

rgb2xyz = XYZSpectra.' * display1Spectra;
xyz2rgb = inv(rgb2xyz);
face1light1xyz = reshape(face1light1, [row * col, deep]) * XYZSpectra;  % to xyz
face1light1rgb = reshape(face1light1xyz * xyz2rgb.', [row, col, 3]);    % to rgb

gamma = 2.2;
faceBeforeGamma = face1light1rgb ./ max(face1light1rgb(:));
faceAfterGamma = faceBeforeGamma .^ (1 / gamma);
figure
imshow(faceAfterGamma);

x = 47;
y = 149;
sampleLight = reshape(face1light1(y, x, :), [1, 73]);
figure
plot(wl, sampleLight, 'LineWidth', 2);
grid on;
xlabel('wavelength');
ylabel('strength');

temp = reshape(face1light1rgb(y, x, :), [3, 1]);
sampleDisplay = reshape(display1Spectra * temp, [1, 73]);
figure
plot(wl, sampleDisplay, 'LineWidth', 2);
grid on;
xlabel('wavelength');
ylabel('strength');