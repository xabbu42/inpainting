function msg = import_common()
% defines some helper functions
assignin('caller', 'sum2',  @(m) sum(sum(m)));
assignin('caller', 'msum',  @(m) sum(m(:)));
assignin('caller', 'qnorm2', @(m) sum(sum(m .^ 2)));

assignin('caller', 'conv2boundary', @conv2boundary);
assignin('caller', 'forwx', @forwx);
assignin('caller', 'forwy', @forwy);
assignin('caller', 'backx', @(m, b) conv2boundary(m, [0 1 -1], b));
assignin('caller', 'backy', @(m, b) conv2boundary(m, [0 1 -1]', b));
assignin('caller', 'centralx', @(m, b) conv2boundary(m, [1 0 -1], b));
assignin('caller', 'centraly', @(m, b) conv2boundary(m, [1 0 -1]', b));

assignin('caller', 'forw_variation', @forw_variation);
assignin('caller', 'forw_total_variation', @forw_total_variation);
assignin('caller', 'forw_total_variation_grad', @forw_total_variation_grad);

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

function [r] = forw_variation(u, b)
	if (nargin < 2)
		b = 0;
	end
	r = sqrt(forwx(u, b) .^ 2 + forwy(u, b) .^ 2 + 1e-10);
end

function [r] = forw_total_variation(u, b)
	if (nargin < 2)
		b = 0;
	end
	r = sum(sum(forw_variation(u, b)));
end

function [r] = forw_total_variation_grad(u, b)
	if (nargin < 2)
		b = 0;
	end
	inverse_var = 1 ./ forw_total_variation(u, b);
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

