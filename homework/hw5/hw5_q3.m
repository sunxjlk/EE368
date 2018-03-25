close all; clear all;

% part (a)

[xx, yy] = meshgrid(linspace(-pi, pi, 100), linspace(-pi, pi, 100));

% central difference
central_hx = -2 * 1j * sin(xx);
central_hy = -2 * 1j * sin(yy);

figure;
mesh(xx, yy, abs(central_hx)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_central_x.png');

figure;
mesh(xx, yy, abs(central_hy)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_central_y.png');


% Prewitt
prewitt_hx = -2 * 1j * sin(xx) .* (1 + 2 * cos(yy));
prewitt_hy = -2 * 1j * sin(yy) .* (1 + 2 * cos(xx));

figure;
mesh(xx, yy, abs(prewitt_hx)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_prewitt_x.png');

figure;
mesh(xx, yy, abs(prewitt_hy)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_prewitt_y.png');


% Sobel
sobel_hx = -2 * 1j * sin(xx) .* (2 + 2 * cos(yy));
sobel_hy = -2 * 1i * sin(yy) .* (2 + 2 * cos(xx));

figure;
mesh(xx, yy, abs(sobel_hx)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_sobel_x.png');

figure;
mesh(xx, yy, abs(sobel_hy)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_sobel_y.png');


% Roberts
roberts_hx = exp(-1j * xx) - exp(-1j * yy);
roberts_hy = 1 - exp(-1j * xx) .* exp(-1j * yy);

figure;
mesh(xx, yy, abs(roberts_hx)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_roberts_x.png');

figure;
mesh(xx, yy, abs(roberts_hy)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_roberts_y.png');


% part (b)
close all;

%  Gaussian
sigma = 1;
kernel = fspecial('gaussian', [6 * sigma + 1, 6 * sigma + 1], sigma);
g = freqz2(kernel, 100, 100);

figure;
mesh(xx, yy, abs(g));
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('Gausssian');
saveas(gcf, 'q3_gaussian.png');

% central difference x Gaussian
figure;
mesh(xx, yy, abs(central_hx .* g));
xlabel('\omega_x'); 
ylabel('\omega_y');
title('horizontal');
saveas(gcf, 'q3_g_central_x.png');

figure;
mesh(xx, yy, abs(central_hy .* g));
xlabel('\omega_x'); 
ylabel('\omega_y');
title('vertical');
saveas(gcf, 'q3_g_central_y.png');


% Prewitt x Gaussian
figure;
mesh(xx, yy, abs(prewitt_hx .* g));
xlabel('\omega_x'); 
ylabel('\omega_y');
title('horizontal');
saveas(gcf, 'q3_g_prewitt_x.png');


figure;
mesh(xx, yy, abs(prewitt_hy .* g));
xlabel('\omega_x'); 
ylabel('\omega_y');
title('vertical');
saveas(gcf, 'q3_g_prewitt_y.png');


% Sobel x Gaussian
figure;
mesh(xx, yy, abs(sobel_hx .* g));
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_g_sobel_x.png');

figure;
mesh(xx, yy, abs(sobel_hy .* g)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_g_sobel_y.png');

% Roberts x Gaussian
figure; 
mesh(xx, yy, abs(roberts_hx .* g)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('horizontal');
saveas(gcf, 'q3_g_roberts_x.png');

figure;
mesh(xx, yy, abs(roberts_hy .* g)); 
xlabel('\omega_x'); 
ylabel('\omega_y'); 
title('vertical');
saveas(gcf, 'q3_g_roberts_y.png');
