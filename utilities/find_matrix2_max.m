function [pos, val] = find_matrix_max(m)
%FIND_MATRIX_MAX Finds the maximum value and its position in a matrix
%   POS = FIND_MATRIX_MAX(M) finds maximum value and returns the position of it in the
%   matrix.
%   [POS, VAL] = FIND_MATRIX_MAX(M) lets VAL to be the maximum value.
%   
%   See also ZPROJECT_STDEV, MEAN.

%   Weihao Sheng, 2020-04-21
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

    [val, ind] = max(m(:));
    pos = ind2sub(size(m), ind(1));

end
