close all; clear;
src_dir = '/Users/zhangrao/Documents/NOW/EE368/hw/hw3/hw3_data/hw3_leaf_';

test = imread(strcat(src_dir, 'testing_1', '.jpg'));
test_vec = img2vec(test, 0);
% train = cell(1, 5);
scores = zeros(1, 5);
for n = 1 : 5
    train = imread(strcat(src_dir, 'training_', num2str(n), '.jpg'));
    train_vec = img2vec(train, n);
    scores(n) = sum(abs(test_vec - train_vec));
end










