function im = vid_zproject_mean_within_std(mov, fold)
%VID_ZPROJECT_MEAN_WITHIN_STD Z-Project of a movie using average.
%   IM = VID_ZPROJECT_MEAN_WITHIN_STD(MOV, FOLD) reserves mean image
%
%   See also VID_ZPROJECT_STDEV, MEAN.

%   Weihao Sheng, 2019-09-01
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

if nargin < 2, fold = 3; end
    
	im = mean(mov, 3);
    imstd = std( single(mov),0,3 );
    
    minimg = im - imstd.*fold; maximg = im + imstd.*fold;
    
    im ( im<minimg ) = minimg( im<minimg );
    im ( im>maximg ) = maximg( im>maximg );
   
    im = cast(im, class(mov));
end
