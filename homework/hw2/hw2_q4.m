close all;
clear all;
% part(a) and part(b)
for n = 1 : 5
    train_img{n} = double(imread(strcat(...
        '/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_cone_training_', num2str(n), '.jpg')));
    label_img{n} = imread(strcat(...
        '/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_cone_training_map_', num2str(n), '.png'));
end

for n = 1 : 5
    [nRows, nCols] = size(label_img{n});
    neg_set{n} = zeros(nRows * nCols, 3);
    pos_set{n} = zeros(nRows * nCols, 3);
end

bins = zeros(16, 16, 16);
for n = 1 : 5
    curr_train = train_img{n};
    curr_label = label_img{n};
    [nRows, nCols] = size(label_img{n});
    for r = 1 : nRows
        for c = 1 : nCols
            pixel = reshape(curr_train(r, c, :), [1, 3]);
            loc = floor(pixel ./ 16) + 1;
            if curr_label(r, c)
                if mod(r, 10) + mod(c, 10) == 0
                    pos_set{n}((r - 1) * nCols + c, :) = pixel;
                end
                bins(loc(1), loc(2), loc(3)) = bins(loc(1), loc(2), loc(3)) + 1;
            else
                if mod(r, 10) + mod(c, 10) == 0
                    neg_set{n}((r - 1) * nCols + c, :) = pixel;
                end
                bins(loc(1), loc(2), loc(3)) = bins(loc(1), loc(2), loc(3)) - 1;
            end
        end
    end
end
figure
for n = 1 : 5
    scatter3(neg_set{n}(:, 1), neg_set{n}(:, 2), neg_set{n}(:, 3), 3, 'b'); hold on;
    scatter3(pos_set{n}(:, 1), pos_set{n}(:, 2), pos_set{n}(:, 3), 3, 'r');
end
axis([0 255 0 255 0 255]);
axis square
xlabel('R');
ylabel('G');
zlabel('B');

classifier = (bins > 0);
ratio = sum(sum(sum(classifier))) / (16 * 16 * 16);

% part(c)
orig = imread('/Users/zhangrao/Documents/NOW/EE368/hw/hw2/hw2_data/hw2_cone_testing_2.jpg');
test = double(orig);
figure
imshow(orig);

[nRows, nCols, nChs] = size(test);
imgBin = zeros(nRows, nCols);
for r = 1 : nRows
    for c = 1 : nCols
            pixel = reshape(test(r, c, :), [1, 3]);
            loc = floor(pixel ./ 16) + 1;
            if classifier(loc(1), loc(2), loc(3))
                imgBin(r, c) = 1;
            end
    end
end
figure
imshowpair(orig, imgBin, 'montage');

% remove small regions
revImgBin = ~ imgBin;
cc = bwconncomp(revImgBin);

for o = 1 : cc.NumObjects
    [nPix, ~] =  size(cc.PixelIdxList{o});
    if nPix < 100
        revImgBin(cc.PixelIdxList{o}) = 0;
    end
end

figure
imshowpair(orig, ~revImgBin, 'montage');