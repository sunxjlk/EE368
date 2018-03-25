close all; clear all;

board = im2double(imread('./hw5_data/hw5_puzzle_reference.jpg'));
pieces = im2double(imread('./hw5_data/hw5_puzzle_pieces.jpg'));
pieces_gray = rgb2gray(pieces);

% Step 1: binarize the pieces image
pieces_bw = double(pieces_gray < 0.99);
figure; 
imshow(pieces_bw);
imwrite(pieces_bw, 'q1_piece_bw.png');

% Step 2: extract an edge map from the binary image
pieces_edge = edge(pieces_bw, 'canny');
figure;
imshow(pieces_edge);
imwrite(pieces_edge, 'q1_piece_edge.png');
pieces_edge_dilate = imdilate(pieces_edge, ones(3, 3)); % dilate for further use

% Step 3: resize the reference image
pieces_sum = sum(pieces_bw(:));
board_sum = size(board,1) * size(board,2);
board = imresize(board, sqrt(pieces_sum / board_sum), 'bicubic');
[rows, cols, chs] = size(board);

% Step 4: label pieces
[labels, n_labels] = bwlabel(pieces_bw);
h10 = figure(10);
imshow(pieces);
hold on;

h11 = figure(11);
imshow(board);
hold on;

% Perform region labeling
for n = 1 : n_labels    % loop all labels 
    display(num2str(n));
    [y, x] = find(labels == n);
    
    % find the middle of each piece
    min_x = min(x); 
    min_y = min(y);
    max_x = max(x);
    max_y = max(y);
    
    piece_width = max_x - min_x + 1;
    piece_height = max_y - min_y + 1;
    
    mid_x = (min_x + max_x) / 2.0;
    mid_y = (min_y + max_y) / 2.0;

    % locate the piece with a rectangle
    piece = pieces(min_y : max_y, min_x : max_x, :);
    piece_bw = pieces_bw(min_y : max_y, min_x : max_x);
    piece_edge = pieces_edge_dilate(min_y : max_y, min_x : max_x);
    
    % find its location in the board
    min_err = 1e9;
    loc_x = 1;
    loc_y = 1;
    for left = 1 : cols - piece_width + 1
        for top = 1 : rows - piece_height + 1
            board_piece = board(top : top + piece_height - 1, left : left + piece_width - 1, :);
            err = sum(abs(piece - board_piece), 3);
            err = sum(sum(piece_bw .* err)); % not the rectangle, but the piece
            if err <= min_err
                loc_x = left;
                loc_y = top;
                min_err = err;
            end
        end
    end
    
    % label image piece
    offset = 10;
    figure(10);
    text(mid_x - offset, mid_y, num2str(n), 'FontSize', 15, 'Color', 'g', 'FontWeight', 'bold');

    % label the board
    figure(11);
    [edge_y, edge_x] = find(piece_edge == 1);
    plot(edge_x + loc_x, edge_y + loc_y, 'yo', 'MarkerSize', 1, 'MarkerFaceColor', 'y');
    text(loc_x + piece_width / 2 - offset, loc_y + piece_height / 2, num2str(n), 'FontSize', 15, 'Color', 'g', 'FontWeight', 'bold');
end
saveas(h10, 'q1_labeled_piece.png');
saveas(h11, 'q1_labeled_board.png');
