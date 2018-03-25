function [shifted, upd_bias_x, upd_bias_y] = Align(frame, prev_ave, bias_x, bias_y)
    frame_size = size(frame);   
    center = [floor(frame_size(1) / 2), floor(frame_size(2) / 2)];
    dim1 = center(1) + 20 : 1 : center(1) + 60;
    dim2 = center(2) + 80 : 1 : center(2) + 120;
    dim3 = 1 : 1 : 3;
    prev_part = prev_ave(dim1, dim2, dim3);

    shifted = frame;
    upd_bias_x = 0;
    upd_bias_y = 0;
    min_se = mean(mean(mean(prev_part .^ 2)));
    
    for dx = bias_x - 3 : 1 : bias_x + 3
        for dy = bias_y - 3 : 1 : bias_y + 3
            A = [1 0 dx; 0 1 dy; 0 0 1];
            tform = maketform('affine', A.');
            [height, width, channels] = size(frame);
            frameTform = imtransform(frame, tform, 'bilinear', 'XData', [1 width], 'YData', [1 height], 'FillValues', zeros(channels, 1));
            se = mean(mean(mean((frameTform(dim1, dim2, dim3) - prev_part) .^ 2)));
            if se < min_se
                min_se = se;
                shifted = frameTform;
                upd_bias_x = dx;
                upd_bias_y = dy;
            end
        end
    end
end