function msg = import_common(varargin)
% defines some helper functions
% For variable preallocation:

names = varargin;

if isempty(names) || ismember('sum2', names)
	assignin('caller', 'sum2',  @(m) sum(sum(m)));
end

if isempty(names) || ismember('msum', names)
	assignin('caller', 'msum',  @(m) sum(m(:))); % slower but does not assume 2-dimensional
end
if isempty(names) || ismember('qnorm2', names)
	assignin('caller', 'qnorm2', @(m) sum(sum(m .^ 2)));
end

if isempty(names) || ismember('conv2boundary', names)
	assignin('caller', 'conv2boundary', @conv2boundary);
end
if isempty(names) || ismember('forwx', names)
	assignin('caller', 'forwx', @forwx);
end
if isempty(names) || ismember('forwy', names)
	assignin('caller', 'forwy', @forwy);
end
if isempty(names) || ismember('backx', names)
	assignin('caller', 'backx', @backx);
end
if isempty(names) || ismember('backy', names)
	assignin('caller', 'backy', @backy);
end

if isempty(names) || ismember('forw_variation', names)
	assignin('caller', 'forw_variation', @forw_variation);
end
if isempty(names) || ismember('forw_total_variation', names)
	assignin('caller', 'forw_total_variation', @forw_total_variation);
end
if isempty(names) || ismember('forw_total_variation_grad', names)
	assignin('caller', 'forw_total_variation_grad', @forw_total_variation_grad);
end

msg = 'imported common functions';
end


function [r] = forwx(m, b)
	if (nargin < 2)
		b = 0;
	end
	r = conv2boundary(m, [1 -1], b);
end

function [r] = forwy(m, b)
	if (nargin < 2)
		b = 0;
	end
	r = conv2boundary(m, [1 -1]', b);
end

function [r] = backx(m, b)
	if (nargin < 2)
		b = 0;
	end
	r = conv2boundary(m, [0 1 -1], b);
end

function [r] = backy(m, b)
	if (nargin < 2)
		b = 0;
	end
	r = conv2boundary(m, [0 1 -1]', b);
end

function [r] = forw_variation(u, b, d)
	if (nargin < 2)
		b = 0;
	end
	if (nargin < 3)
		d = 1e-5;
	end
	r = sqrt(forwx(u, b) .^ 2 + forwy(u, b) .^ 2 + d);
end

function [r] = forw_total_variation(u, b, d)
	if (nargin < 2)
		b = 0;
	end
	if (nargin < 3)
		d = 1e-5;
	end
	r = sum(sum(forw_variation(u, b, d)));
end

function [r] = forw_total_variation_grad(u, b, d)
	if (nargin < 2)
		b = 0;
	end
	if (nargin < 3)
		d = 1e-5;
	end
	inverse_var = 1 ./ forw_variation(u, b, d);
	r = conv2(inverse_var .* forwx(u, b), [0 -1 +1], 'same') + conv2(inverse_var .* forwy(u, b), [0 -1 +1]', 'same');
end

function [r] = conv2boundary(a, b, boundary)
	if nargin < 3 || (length(boundary) == 1 && boundary == 0)
	    r = conv2(a, b, 'same');
	else
		a = padarray(a, ceil( (size(b) - 1) ./ 2), boundary, 'post');
		a = padarray(a, floor((size(b) - 1) ./ 2), boundary, 'pre');
		r = conv2(a, b, 'valid');
	end
end

