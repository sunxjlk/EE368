function vec = img2vec(img, num)
% obtain contour
    gray_img = rgb2gray(img);
    level = graythresh(gray_img);
    BW = imbinarize(gray_img, level);
    figure
    imshow(~BW);
    imwrite(~BW, strcat('q2_bin_', num2str(num), '.png'));
    SE = strel('disk', 1);
    dilated = imdilate(BW, SE);
    contour = dilated - BW;
%     imshow(contour);

    % obtain centroid
    [rows, cols] = size(contour);
    cnt = 0;
    xs = zeros(1, rows * cols);
    ys = zeros(1, rows * cols);
    for r = 1 : rows
        for c = 1 : cols
            if ~BW(r, c) > 0
                cnt = cnt + 1;
                ys(cnt) = r;
                xs(cnt) = c;
            end
        end
    end
    xmid = ceil(median(xs(xs > 0)));
    ymid = ceil(median(ys(ys > 0)));
    bg = zeros(rows, cols);
    bg(ymid - 4 : ymid + 4, xmid) = 1;
    bg(ymid, xmid - 4 : xmid + 4) = 1;
    figure
    himg = imshowpair(contour, bg, 'diff');
    imwrite(himg.CData, strcat('q2_contour_', num2str(num), '.png'));

    % distance distribution & median
    dis = zeros(1, rows * cols);
    cnt = 0;
    for r = 1 : rows
        for c = 1 : cols
            if contour(r, c) > 0
                cnt = cnt + 1;
                dis(cnt) = sqrt((xmid - c) ^ 2 + (ymid - r) ^ 2);
            end
        end
    end
    mid_dis = sum(dis) / cnt;
    norm_dis = dis(1: cnt) ./ mid_dis;
    range_dis = norm_dis(norm_dis < 2);

    % histogram with 20 bins
    figure
    h = histogram(range_dis, 40);
    vec = h.Values ./ sum(h.Values);
    saveas(gcf, strcat('q2_hist_', num2str(num), '.png'));
%     close;
    x_axis = 2 * [0.0125 : 0.025 : 1 - 0.0125];
    plot(x_axis, vec, 'LineWidth', 2);
    grid on;
    saveas(gcf, strcat('q2_perc_', num2str(num), '.png'));
end

