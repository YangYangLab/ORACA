function imout = im_downsample(im, ds)
%IM_DOWNSAMPLE Resize video to smaller frames
%   IMOUT = IM_DOWNSAMPLE(IM, DS) shrinks the image to a smaller size by a factor of DS.
%   Height & width of the new image will be 1/DS of the original one.
%
%   See also VID_DOWNSAMPLE.

%   Weihao Sheng, 2020-04-23
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

if ds == 2

    hnew = fix(size(im,1)/2); wnew = fix(size(im,2)/2);
    im = [im; im(end,:)]; im = [im, im(:,end)];
    
    imout = zeros(hnew, wnew, class(im));
    for h = 1:hnew
        for w = 1:wnew
            imout(h,w) = mean([ im(2*h, 2*w);    im(2*h+1, 2*w); ...
                                im(2*h, 2*w+1);  im(2*h+1, 2*w+1)]);
            
        end
    end
    
else
    
	hnew = 1/ds*size(im,1); wnew = 1/ds*size(im,2);

    imout(:,:) = cast(imresize(im(:,:,f), [hnew wnew], 'bilinear'), class(im));

    
end
end
