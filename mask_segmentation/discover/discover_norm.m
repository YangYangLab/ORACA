function data = discover_norm(data)
%DISCOVER_NORM normalise 3d stack 
%   Detailed explanation goes here
data = double(data);
data = (data - mean(data,3)) ./ std(data,[],3);
end

