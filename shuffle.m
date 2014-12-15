%%
% Shuffles the rows of matrix A, returning B
function [B] = shuffle(A)
    B = A(randperm(size(A, 1)), :);
end
