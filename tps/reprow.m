%% Given a matrix A, this function will return a matrix B where each
% row has been replicated n times in B
function [B] = reprow(A, n)
    % Adapted from http://www.mathworks.com/matlabcentral/newsreader/view_thread/318377
    % Subject: duplicate rows of a matrix
    % From: Roger Stafford
    % Date: 26 Mar, 2012 22:09:11
    B = A(ceil((1:n * size(A,1)) / n), :);
end
