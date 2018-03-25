close all; clear all;

% global parameters
train_dir = {'non-glasses-training', 'glasses-training'};
test_dir = {'non-glasses-testing', 'glasses-testing'};
train_idx{1} = 0 : 1 : 152; 
train_idx{2} = 0 : 1 : 66;
test_idx{1} = 153 : 1 : 280; 
test_idx{2} = 67 : 1 : 118;
cols = 88;
rows = 100;
orig_shape = [rows, cols];

% part (a)
% training samples
img_sum_vec = 0;
train_img{1} = zeros(cols * rows, length(train_idx{1}));
train_img{2} = zeros(cols * rows, length(train_idx{2}));

% accumulate for calculating mean
for n = 1 : 2
    cnt = 1;
    for idx = train_idx{n}
        file_name = sprintf('./hw5_data/%s/%03d.jpg', train_dir{n}, idx);
        img = im2double(imread(file_name));
        img_vec = img(:);
        train_img{n}(:, cnt) = img_vec;
        cnt = cnt + 1;
        img_sum_vec = img_sum_vec + img_vec;
    end
end

% compute mean and show
n_samples = length(train_idx{1}) + length(train_idx{2});
img_mean_vec = img_sum_vec / n_samples;
img_mean = reshape(img_mean_vec, orig_shape);
figure;
imshow(img_mean); 
title('Mean Face');
imwrite(img_mean, 'q2_mean_face.png');

% part (b)
% remove mean from the original train images
train_img_sub_mean = zeros(cols * rows, length(train_idx{1}) + length(train_idx{2}));
cnt = 1;
for n = [1, 2]
    for nn = 1 : size(train_img{n}, 2)
        img_vec = train_img{n}(: , nn) - img_mean_vec;
        train_img_sub_mean(:, cnt) = img_vec;
        cnt = cnt + 1;
    end
end

% S-K method
[V, ~] = eig(train_img_sub_mean.' * train_img_sub_mean);
eig_vec_pca = train_img_sub_mean * V(: , end : -1 : 1);

% normalize to have the same L2 norm
for n = 1 : size(eig_vec_pca, 2)
    eig_vec_pca(:, n) = eig_vec_pca(:, n) / norm(eig_vec_pca(:, n));
end
mat_pca = eig_vec_pca(:, 1 : 100).';

% plot eigen-faces
h = figure;
for n = 1 : 10
    eigenface = reshape(eig_vec_pca(:,n), [rows cols]);
    numerator = eigenface - min(eigenface(:));
    denominator = max(eigenface(:)) - min(eigenface(:));
    eigenface = numerator / denominator;
    subplot(2, 5, n);
    title(sprintf('eigen-face %d', n));
    imshow(eigenface);
end
saveas(h, 'q2_eigen_face.png');

% part (c)
% LDA training samples
pca_mean_vec = 0;
for n = [1, 2]
    pca_samples_class{n} = [];
    pca_mean_vec_class = 0;
    n_samples_class(n) = 0;
    for nn = 1 : size(train_img{n}, 2)
        img_vec = train_img{n}(:, nn) - img_mean_vec;
        pca_vec = mat_pca * img_vec;
        pca_samples_class{n}(:, end + 1) = pca_vec;
        pca_mean_vec_class = pca_mean_vec_class + pca_vec;
        n_samples_class(n) = n_samples_class(n) + 1;
    end
    pca_mean_vec = pca_mean_vec + pca_mean_vec_class;
    pca_mean_vec_class = pca_mean_vec_class / n_samples_class(n);
    pca_mean_vecs_class(:, n) = pca_mean_vec_class;
end

% calculate mean faces for pos and neg
mean_face_pos = reshape(mat_pca.' * pca_mean_vecs_class(:, 2), orig_shape);
numerator = mean_face_pos - min(mean_face_pos(:));
denominator = max(mean_face_pos(:)) - min(mean_face_pos(:));
mean_face_pos = numerator / denominator;
mean_face_neg = reshape(mat_pca.' * pca_mean_vecs_class(:, 1), orig_shape);
numerator = mean_face_neg - min(mean_face_neg(:));
denominator = max(mean_face_neg(:)) - min(mean_face_neg(:));
mean_face_neg = numerator / denominator;

% plot
figure;
imshow(mean_face_neg); 
title('Mean Face, Class 1');
imwrite(mean_face_neg, 'q2_mean_face_c1.png');

figure;
imshow(mean_face_pos); 
title('Mean Face, Class 2');
imwrite(mean_face_pos, 'q2_mean_face_c2.png');

% map detector
for n = [1, 2]
    pca_vals{n} = [];
    for nn = 1:size(train_img{n}, 2)
        img_vec = train_img{n}(:, nn) - img_mean_vec;
        pca_vec = mat_pca * img_vec;
        pca_vals{n}(end + 1) = pca_vec(10);
    end 
end

% invert if necessary
if mean(pca_vals{1}) > mean(pca_vals{2})
    pca_vals{1} = -pca_vals{1};
    pca_vals{2} = -pca_vals{2};
end

hist_bin = linspace(-5, 5, 50); % 50 bins as stated in PS
hist_neg = hist(pca_vals{1}, hist_bin);
hist_pos = hist(pca_vals{2}, hist_bin);
thresh_eigen_face = 0.75;

% plot the prob vs coefficients
figure;
plot(hist_bin, hist_neg, 'r-'); hold on; 
plot(hist_bin, hist_pos, 'b-'); hold on;
x_array = thresh_eigen_face * ones(1, 100);
y_array = linspace(0, 30, 100);
plot(x_array, y_array, 'k--'); hold on;
legend('Non-glasses', 'Glasses');
xlabel('Coefficient'); 
ylabel('Frequency'); 
title('Eigenface');
grid on;
content = strcat('T=', num2str(thresh_eigen_face));
text(thresh_eigen_face + 0.1, 25, content, 'FontSize', 10);
saveas(gcf, 'q2_plot.png');

% accuracy
for n = [1, 2]
    pca_vals{n} = [];
    for idx = test_idx{n}
        file_name = sprintf('./hw5_data/%s/%03d.jpg', test_dir{n}, idx);
        img = im2double(imread(file_name));
        img_vec = img(:) - img_mean_vec;
        pca_vec = mat_pca * img_vec;
        pca_vals{n}(end + 1) = pca_vec(10);
    end
end 

% show the statistics
n_correct_1 = length(find(pca_vals{1} < thresh_eigen_face));
n_correct_2 = length(find(pca_vals{2} > thresh_eigen_face));
display(strcat('1 correct: ', num2str(n_correct_1)));
display(strcat('1 total: ', num2str(length(test_idx{1}))));
display(strcat('2 correct: ', num2str(n_correct_2)));
display(strcat('2 total: ', num2str(length(test_idx{2}))));
error_rate = (n_correct_1 + n_correct_2) / (length(test_idx{1}) + length(test_idx{2}));
display(strcat('overall error rate: ', num2str(1 - error_rate)));

% part (d)