function val = get_fields(s, fieldnames, default)
%GET_FIELDS get value in a struct or return default value if non-existent
%   VAL = GET_FIELDS(S, 'FIELDNAME') retrieves the values of S.FIELDNAME or returns []
%   if the FIELDNAME does not exist.
%
%   VAL = GET_FIELDS(S, {'FIELDNAMES'}) retrieves the values of all S.(FIELDNAMES) or 
%   returns [] for the FIELDNAMES that do not exist.
%
%   VAL = GET_FIELDS(..., DEFAULT) returns DEFAULT for the FIELDNAMES that do not exist.
%
%   See also GETFIELD, ISFIELD.

%   Weihao Sheng, 2020-03-10
%   Yang Yang's Lab of Neural Basis of Learning and Memory
%   School of Life Sciences and Technology, ShanghaiTech University,
%   Shanghai, China

if nargin < 3
    default = [];
end

if ischar(fieldnames) % GET_FIELDS(S, 'FIELDNAME')
    if isfield(s, fieldnames)
        val = s.(fieldnames); 
    else
        val = default; 
    end
    
elseif iscell(fieldnames) % GET_FIELDS(S, {'FIELDNAMES'})
    val = cell(1, length(fieldnames));
    
    yesno = isfield(s, fieldnames);
    for idx = 1:length(fieldnames)
        if yesno(idx)
            val{idx} = s.(fieldnames{idx});
        else
            val{idx} = [];
        end
    end
else
    error ([mfilename ': invalid FIELDNAMES']);
end
        
end
