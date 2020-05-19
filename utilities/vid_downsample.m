function vout = vid_downsample(vid, ds)
%VID_DOWNSAMPLE Resize video to smaller frames
%   VOUT = VID_DOWNSAMPLE(VID, DS) shrinks the video to a smaller size by a factor of DS.
%   Height & width of the new video will be 1/DS of the original one.
%
%   See also VID_UPSAMPLE.

%   Weihao Sheng, 2020-04-12
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

if ds == 2
    
    vid = [vid; vid(end,:,:)]; vid = [vid, vid(:,end, :)];
        
    hnew = fix(size(vid,1)/2); wnew = fix(size(vid,2)/2);
    nFrames = size(vid, 3);
    
    vout = zeros(hnew, wnew, nFrames, class(vid));
    for h = 1:hnew
        for w = 1:wnew
            vout(h,w,:) = mean([vid(2*h, 2*w, :);   vid(2*h+1, 2*w, :); ...
                                vid(2*h, 2*w+1, :); vid(2*h+1, 2*w+1, :)]);
        end
    end
    
else
    
	hnew = 1/ds*size(vid,1); wnew = 1/ds*size(vid,2);
    nFrames = size(vid, 3);
    vout = zeros(hnew, wnew, nFrames, class(vid));
    
    for f = 1:nFrames
        vout(:,:,f) = imresize(vid(:,:,f), [hnew wnew], 'bilinear');
    end 
    
end
end
