function [u] = inpainting_NATHANGASS(g,omega,lambda,varargin)
% input: g: single gray scaled image
%        omega: mask
% lambda: parameter % output: u: inpainted image

%Options
p = inputParser;
p.addRequired('g');
p.addRequired('omega');
p.addRequired('lambda');
p.addOptional('method', 'primaldual');
p.addOptional('theta', 1);
p.addOptional('sigma', 0.01);
p.addOptional('tau', 0.01);
p.KeepUnmatched = true;
parse(p, g, omega, lambda, varargin{:})
opts = p.Results;
rest = p.Unmatched;

if ismember('method', p.UsingDefaults) && (any(strcmp('alpha', varargin)) || any(strcmp('beta', varargin)) || any(strcmp('constantstep', varargin)))
	opts.method = 'gradientdescent';
end

forw_variation = sym('forw_variation');
forw_total_variation = sym('forw_total_variation');
forw_total_variation_grad = sym('forw_total_variation_grad');
import_common('forw_variation', 'forw_total_variation', 'forw_total_variation_grad');

cost = @(u) (lambda/2) * sum(sum(omega .* (u - g) .^ 2)) + forw_total_variation(u);
grad = @(u) lambda * (omega .* (u - g)) + forw_total_variation_grad(u);

p = zeros(size(g));
lastu = g;

function [u, error] = primal_dual_step(u)
	ubar = (u + opts.theta * (u - lastu));
	p = p + opts.sigma * forw_variation(ubar);
	p = p ./ max(1, sqrt(sum(sum(p .^ 2))));

	lastu = u;
	u = (u + opts.tau * forw_variation(p) + opts.tau * opts.lambda * (omega.*g)) ./ (ones(size(u)) + opts.tau * opts.lambda * omega);
	error = numel(g);
end

if strcmp(opts.method, 'gradientdescent')
	[u, meta] = gradient_descent(g, cost, grad, varargin{:});
elseif strcmp(opts.method, 'primaldual')
	[u, meta] = iterate(g, cost, @primal_dual_step, rest(:));
else
	error 'Unknown method ' + opts.method;
end

meta

end
