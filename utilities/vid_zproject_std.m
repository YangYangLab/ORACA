function im = vid_zproject_std(mov)
%VID_ZPROJECT_STD Z-Project of a movie using standard deviation.
%   IM = VID_ZPROJECT_STD(MOV) projects MOV onto the first two dimensions and
%   compress information on the third dimension using matlab std()
%   function. IM will be the projected image.
%
%   See also VID_ZPROJECT_MEAN, STD.

%   Weihao Sheng, 2019-09-01
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

	im = std(single(mov), 0, 3);
    
end
