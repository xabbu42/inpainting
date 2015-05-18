function [ u, meta ] = gradient_descent(start, cost, grad, varargin)
%GRADIENT_DESCENT Summary of this function goes here
%   Detailed explanation goes here

%Options
p = inputParser;
p.addRequired('start');
p.addRequired('cost');
p.addRequired('grad');
p.addOptional('constantstep',  0);
p.addOptional('alpha',      1e-2);
p.addOptional('beta',       0.5);
p.KeepUnmatched = true;
parse(p, start, cost, grad, varargin{:})
opts = p.Results;

costu = cost(start);

function [u, err] = gradient_descent_step(u)
	% calculate gradient
    gradu  = grad(u);
	gradu_norm_squared = sum(sum(gradu .^ 2));  %TODO should not assume 2 dimensionsal problem

	% constant step factor
	if (opts.constantstep)
		t = opts.constantstep;
        step = t * gradu;
        newu = u - step;
        costnewu = cost(newu);

	% backtrack line search
	else
		t = 1;
		linear = opts.alpha * gradu_norm_squared;
		while 1
			step = t * gradu;
			newu = u - step;
			costnewu = cost(newu);
			if ~isfinite(costnewu)
				error 'inf or nan cost';
			end
			if opts.constantstep || costnewu <= costu - t * linear
				break;
			end
			t = opts.beta*t;
		end
	end

    % Update
    u = newu;
    costu = costnewu;
	err = sqrt(gradu_norm_squared);
end

[u, meta] = iterate(start, cost, @gradient_descent_step, p.Unmatched(:));

if (opts.constantstep)
	meta.constantstep = opts.constantstep;
else
	meta.alpha = opts.alpha;
	meta.beta = opts.beta;
end

end
