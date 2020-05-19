function val = check_st(opt, fieldnames)
%OPT_CHK check if fieldnames exist in opt or not
%   VAL = OPT_CHK(S, 'FIELDNAME') returns 1 or 0 indicating existence of FIELDNAME.
%
%   VAL = OPT_CHK(S, {'FIELDNAMES'}) returns 1/0 indicating existence of all FIELDNAMES. 
%
%   See also ISFIELD.

%   Simple wrapper program for ISFIELD.

%   Weihao Sheng, 2020-04-09
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

    val = isfield(opt, fieldnames);
end