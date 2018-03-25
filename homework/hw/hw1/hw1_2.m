clear; close all;

% without alignment
% vidobj = VideoReader('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_sky_2.avi');
vidobj = VideoReader('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_sky_1.avi');
numFrames = get(vidobj, 'NumberOfFrames');
prev_ave = im2double(read(vidobj, 1));
for i = 2 : numFrames
    frame = im2double(read(vidobj, i));
    curr_ave = (i - 1) / i * prev_ave + 1 / i * frame;
    % update
    prev_ave = curr_ave;
    % 30th frame
    if i == 30
        break
    end
end
figure
imshow(curr_ave);


% with alignment
% vidobj = VideoReader('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_sky_2.avi');
vidobj = VideoReader('/Users/zhangrao/Documents/NOW/EE368/hw1/hw1_data/hw1_sky_1.avi');
numFrames = get(vidobj, 'NumberOfFrames');
prev_ave = im2double(read(vidobj, 1));
bias_x = 0;
bias_y = 0;
display(size(prev_ave));
for i = 2 : numFrames
    display(i);
    frame = im2double(read(vidobj, i));   
    [shifted, upd_bias_x, upd_bias_y] = Align(frame, prev_ave, bias_x, bias_y);
    curr_ave = (i - 1) / i * prev_ave + 1 / i * shifted;
    % update
    prev_ave = curr_ave;
    bias_x = upd_bias_x;
    bias_y = upd_bias_y;
    % 30th frame
    if i == 30
        break
    end
end
figure
imshow(curr_ave);


% with alignment
% frame = im2double(read(vidobj, 1));
% frame_size = size(frame);   %(533, 800, 3)
% display(frame_size);
% center = [floor(frame_size(1) / 2), floor(frame_size(2) / 2)];
% dim1 = center(1) + 20 : 1 : center(1) + 60;
% dim2 = center(2) + 80 : 1 : center(2) + 120;
% dim3 = 1 : 1 : 3;
% part = frame(dim1, dim2, dim3);
% imshow(part);
