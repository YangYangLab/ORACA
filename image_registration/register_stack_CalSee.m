function [rt, stackOut] = register_stack_CalSee(moving, template, params)
%REGISTER_STACK_CALSEE fast image registration
%   RT = REGISTER_STACK_CALSEE(MOVING, PARAMS) analyses movements in the video 
%   and outputs a table comprising offsets in X-Y direction. 
%   [..., STACKOUT] = REGISTER_STACK_CALSEE() also outputs registered stack if needed.
% Inputs:
%   MOVING      a 3-D matrix [height * width * nFrames], the video that needs registration
%   PARAMS      a struct consisting of:
%               maxsft - maximum shift (in pixels). Offset pairs shall not exceed this
%                   limit. By default this is 1/5 of height or width
%               mcontsft - maximum continuous shift (in pixels). Maximum shifts
%                   between one frame and one frame before. Say, Frame #4 shifts 7px in
%                   some direction, and mcontsft=10, so Frame #5 shifts no more than 17px.
%                   [NOT IMPLEMENTED YET]
%               verbose - 0/1 indicating whether to display a lot of useless info
%               
% Output:
%   RT          a 2-D matrix result table [nFrames*2], each row [yshift, xshift] 
%   STACKOUT    a 3-D matrix [height * width * nFrames], registered video
%
%   See also IM_CONVFFT.

%   Written by Weihao Sheng, 2020-03-23
%   Yang Yang's Lab of Neural Basis of Learning and Memory,
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

% version(date) & changes
%   20200314 modified from GPU ver ---weihao
%   20200323 normalised for better results ---weihao
%   20200422 add mcontsft & verbose ---weihao

%% Input validation

if nargin < 3, params = []; end
% maxsft = get_fields(params, 'maxsft', round(min(height, width)/8.0));
% mcontsft = get_fields(params, 'mcontsft', []);
% subpix = get_fields(params, 'subpix', []);
verbose = get_fields(params, 'verbose', 0);

%% computation

t0 = tic;

    %template = generate_template(moving);

    if nargout == 1 % rt
        rt = fast_register(moving, template, params);
    elseif nargout == 2 % rt, stackOut
        [rt, stackOut] = fast_register(moving, template, params); 
    end

    if verbose
        disp([mfilename ': timing ' num2str(toc(t0))]);
    end

end

function [rt, stackOut] = fast_register(moving, template, params)

[height, width, nFrames] = size(moving);
maxsft = get_fields(params, 'maxsft', round(min(height, width)/8.0));
mcontsft = get_fields(params, 'mcontsft', 0);
%subpix = get_fields(params, 'subpix', []);
%verbose = get_fields(params, 'verbose', 0);

rt = zeros(nFrames, 2); 
template = double(template); 

template2 = template.^2;                                                                    % we need to normalise template here (centralise all data)
template2 = (template2 - mean(template2(:))) / std(template2(:)) / sqrt(2);
equP1 = im_convfft( template2, ones(round(height-maxsft*2), round(width-maxsft*2)), ...     % the sum[(template)^2] part, pre-calculated, downsampled
                    'valid');                                                               % if GPU is used then this calc can be accelerated greatly

template = (template - mean(template(:))) / std(template(:)) / sqrt(2);

if nargout == 1 % rt
    
    for frm = 1:nFrames
        
        movfrmrt = double(moving( (height-maxsft):-1:(maxsft+1), (width-maxsft):-1:(maxsft+1),frm));
        movfrmrt = (movfrmrt - mean(movfrmrt(:))) / std(movfrmrt(:)) / sqrt(2);
        equP2 = im_convfft(template, movfrmrt, 'valid');
        diffequ = equP1 - equP2*2;
        
        [yshift, xshift] = find_matrix_min(diffequ);
        
        rt(frm, :) = [yshift-maxsft-1, xshift-maxsft-1];
    end
    

elseif nargout == 2 % rt stackOut

    stackOut = zeros(size(moving), class(moving));
    lastsft = [maxsft, maxsft];
    for frm = 1:nFrames
        
        movfrmrt = double(moving( (height-maxsft):-1:(maxsft+1), (width-maxsft):-1:(maxsft+1),frm));
        movfrmrt = (movfrmrt - mean(movfrmrt(:))) / std(movfrmrt(:)) / sqrt(2);             % we need to normalise frame here (centralise all data)
        equP2 = im_convfft(template, movfrmrt, 'valid');
        
        diffequ = equP1 - equP2*2;
        
        if (mcontsft > 0) 
            [yshift, xshift] = find_matrix_min(diffequ, lastsft, mcontsft);
        else
            [yshift, xshift] = find_matrix_min(diffequ);
        end
        
        rt(frm, :) = [yshift-maxsft-1, xshift-maxsft-1];
        lastsft = [yshift, xshift];
        stackOut(    max(1,1+rt(frm,2)) : min(height,height+rt(frm,2)),  max(1,1+rt(frm,1)) : min(width, width+rt(frm,1)), frm) ...
            = moving(max(1,1-rt(frm,2)) : min(height,height-rt(frm,2)),  max(1,1-rt(frm,1)) : min(width, width-rt(frm,1)), frm);
        
    end

end

end

function [ysft, xsft] = find_matrix_min(mtx, lastsft, mcontsft)
% find the minimum value in a matrix.
if nargin == 1
    rowtop = 1; coltop = 1;
    rows = 1:size(mtx,1); 
    cols = 1:size(mtx,2);
else
    rowtop = max(1, lastsft(1)-mcontsft);
    coltop = max(1, lastsft(2)-mcontsft);
    rows = rowtop : min(size(mtx,1), lastsft(1)+mcontsft);
    cols = coltop : min(size(mtx,2), lastsft(2)+mcontsft);
end
mtx = mtx(rows, cols);
[~, ind] = min(mtx(:));
[ysft, xsft] = ind2sub(size(mtx), ind);

ysft = ysft + rowtop - 1;
xsft = xsft + coltop - 1;
end

function [tpl,partialreg] = generate_template(moving)
% generate a clearer template [UNUSED]
% find maximum brightness frame, generate a subset of frames and partially align to it

maxbright = 0; maxfrm = 0;
for frm = 1:nFrames/2
    brightness = sum(reshape(moving(:,:,frm), [1 height*width]));
    if brightness > maxbright, maxbright = brightness; maxfrm = frm; end
end

tpl = moving(:,:,maxfrm);
frm = unique(randi(nFrames/2, [round(nFrames/20) 1]));

[~, partialreg] = fast_register(moving(:,:,frm), tpl, params);
tpl = uint16(vid_zproject_mean(partialreg));
end