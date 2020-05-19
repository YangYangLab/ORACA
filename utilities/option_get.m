function val = opt_get(varargin)
%OPT_GET simple wrapper for get_fields
%   
%   See also GET_FIELDS.

%   Simple wrapper program for ISFIELD.

%   Weihao Sheng, 2020-04-09
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

    val = get_fields(varargin{:});
end