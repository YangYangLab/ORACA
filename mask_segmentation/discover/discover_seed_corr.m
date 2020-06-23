function [seedrc, lcmap] = discover_seed_corr(data,params)
%DISCOVER_SEED_CORR calculates local correlation map for seed generation
%   SEEDRC = DISCOVER_SEED_CORR(DATA, PARAMS) computes all pixels in DATA and gives out
%   coordinates of some pixels with highest neighbouring correlation. Each pixel is tested
%   against its 8 neighbouring pixels (MARGINAL PIXELS NOT CALCULATED), and averaged as
%   its local_correlation value. Then the image is then segmented into patches, and one is
%   selected as top of this patch.
%
% Inputs:
%   DATA        a 3-D matrix [height * width * nFrames], the video to be identified
%   PARAMS      a struct consisting of:
%               Keep - percentage of top-correlated pixels to keep. (default=0.4, top 40% 
%               	of original seeds will be kept)
%               PatchSize - size of divided patches in pixels. (default=5);
%               downsample - whether to use downsample or not (default=1)
%               
% Output:
%   RT          a 2-D matrix result table [nFrames*2], each row [yshift, xshift] 
%   STACKOUT    a 3-D matrix [height * width * nFrames], registered video
%
% This code is highly optimised for GPU acceleration. For an equivalent CPU version that do
% not involve GPU at all, see REGISTER_STACK_RAPID_CPU.
%
% This code uses downsampling to accelerate registration. For a downsample-free (slower and 
% slightly more accurate) registration method, check out REGISTER_STACK_RAPID_NDSGPU.
%
%   See also IM_CONVFFT1, REGISTER_STACK_RAPID_CPU, REGISTER_STACK_RAPID_NDSGPU.
%   

%   Written by Weihao Sheng, 2020-04-17
%   Yang Yang's Lab of Neural Basis of Learning and Memory,
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

% version(date) & changes
%   20200417 first version ---weihao
%   20200508 

[h,w,f] = size(data);

if nargin<2, params = []; end
keeppct = get_option(params, 'keep', 0.4); 
patchsz = get_option(params, 'PatchSize', 0.4); 
useGPU = get_option(params, 'useGPU', 1); 

if useGPU
    % First we centralise all pixels using their own stats
    data = double(data);
    data = (data - mean(data,3)) ./ std(data,[],3);
    lcmap = gpuArray.zeros([h,w], 'single');
    
    % Now we compute correlation row-wise 
    % Computing one row at a time is extremely fast using GPU. Always use GPU if possible.
    for r = 2:h-1
        along = repmat(data(r,2:w-1,:), [9 1 1]);
        blong = [data(r-1:r+1,1:w-2,:); data(r-1:r+1,2:w-1,:); data(r-1:r+1,3:w,:)];
        lcmap(r,2:w-1) = (sum(sum(along.*blong, 3))/f-1)/8;
    end

    seedrc = zeros(floor(h/5)*floor(w/5),2);
    for r = 1:5:h
        for c = 1:5:w
            
        end
    end
else %no GPU
    
end
