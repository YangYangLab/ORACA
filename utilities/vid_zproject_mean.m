function im = vid_zproject_mean(mov)
%VID_ZPROJECT_MEAN Z-Project of a movie using average statistics.
%   IM = VID_ZPROJECT_MEAN(MOV) projects MOV onto the first two dimensions and
%   compress information on the third dimension using matlab mean()
%   function. IM will be the projected image.
%
%   See also VID_ZPROJECT_STDEV, MEAN.

%   Weihao Sheng, 2019-09-01
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

	im = mean(mov, 3);
    
end
