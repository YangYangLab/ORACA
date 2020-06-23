function weightmap = discover_seed_auc(act,params)
%DELIGHT_GENERATE_SEED generates seeds for segmentation
%   

%   Weihao Sheng, 2020-05-25
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

[height,width,nFrames] = size(act);

% smooth params
SmoothSize = get_option(params, 'smooth', 5);

    b = (1/SmoothSize)*ones(1,SmoothSize);
    a = 1;
    act = filter(b,a,block,[],3);
    
    act = (act - mean(act(:))) / std(act(:));  
    cumul = sum(act,3); 
    cumul(cumul<0) = 0;
    
    m = mean(cumul(:)); s = std(cumul(:));
    cumul = (cumul-m-3*s); 
    cumul(cumul<0) = 0;

    weightmap = mat2gray(cumul);
end