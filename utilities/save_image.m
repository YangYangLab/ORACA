function ok = save_image(filePath, data, fileType)
%SAVE_IMAGE save an image
%   OK = SAVE_RAW_MATRIX(FILEPATH, DATA, BPP) saves the DATA to FILEPATH using default
%   datatype of the DATA. 
%       DATA is a non-negative matrix.
%       BPP stands for BYTES PER PIXEL (1/2/4 for uint8/uint16/uint32). BPP value other
%       than 1/2/4 will be considered illegal and 16-bit as default will be used.
%
%   simple wrapper for imwrite.
%
%   See also IMWRITE.

%   Weihao Sheng, 2020-04-20
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China


ok = false;

if nargin<3, fileType = 'bmp'; end

if size(data,3) == 1 %grayscale
    data = data';
    data = mat2gray(data);
else %rgb
    data  = permute(data,[2 1 3]);
end

try
    imwrite(data, filePath, fileType);
    disp([mfilename ': image "' inputname(2) '" saved to ' filePath]);
    ok = true;
catch
    warning([mfilename ': an error occured while saving image.']); 
end

end
