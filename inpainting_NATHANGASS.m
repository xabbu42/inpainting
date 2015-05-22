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

%parameters for primal dual
p.addOptional('theta', 0.5);
p.addOptional('sigma', 0.5);
p.addOptional('tau', 0.5);

%pass on remaining parameters to gradient_descent/iterate
p.KeepUnmatched = true;

%parse parameters
parse(p, g, omega, lambda, varargin{:})
opts = p.Results;
rest = p.Unmatched;

% Set missing (or explicitly set to 0) parameters for primal dual
L = sqrt(4);
if ismember('sigma', p.UsingDefaults) || opts.sigma == 0
	opts.sigma = 1 / (L * opts.tau);
end
if ismember('tau', p.UsingDefaults) || opts.tau == 0
	opts.tau = 1 / (L * opts.sigma);
end
assert(opts.sigma * opts.tau * L <= 1, 'Too large sigma or tau');

% guess method based on parameters
if ismember('method', p.UsingDefaults) && (any(strcmp('alpha', varargin)) || any(strcmp('beta', varargin)) || any(strcmp('constantstep', varargin)))
	opts.method = 'gradientdescent';
end

%specialized primal dual implementation for inpainting

%necessary so we can use closure for primal dual below
forwx = sym('forwx');
forwy = sym('forwy');
backx = sym('backx');
backy = sym('backy');
forw_variation = sym('forw_variation');
forw_total_variation = sym('forw_total_variation');
forw_total_variation_grad = sym('forw_total_variation_grad');
import_common('forwx', 'forwy', 'backx', 'backy', 'forw_variation', 'forw_total_variation', 'forw_total_variation_grad');

delta = 1e-5;
px = zeros(size(g));
py = zeros(size(g));
lastu = g;
function [u, error] = primal_dual_step(u)
	ubar = (u + opts.theta * (u - lastu));

    px = px + opts.sigma * forwx(ubar);
    py = py + opts.sigma * forwy(ubar);
    l = max(1, sqrt(px .^ 2 + py .^ 2));
    px = px ./ l;
    py = py ./ l;

    Kp = backx(px) + backy(py);
	lastu = u;
	u = (u + opts.tau * Kp + opts.tau * opts.lambda * (omega .* g)) ./ (1 + opts.tau * opts.lambda * omega);
	error = numel(g);
end

% use generic gradient_descent function with custom cost and gradient for
% gradientdescent method
if strcmp(opts.method, 'gradientdescent')
	delta = 1e-5;
	cost = @(u) (lambda/2) * sum(sum(omega .* (u - g) .^ 2)) + forw_total_variation(u, 0, delta);
	grad = @(u) lambda * (omega .* (u - g)) + forw_total_variation_grad(u, 0, delta);
	[u, meta] = gradient_descent(g, cost, grad, varargin{:});

% just iterate above defined primal dual step for primaldual method
elseif strcmp(opts.method, 'primaldual')
	cost = @(u) (lambda/2) * sum(sum(omega .* (u - g) .^ 2)) + forw_total_variation(u, 0, delta);
	[u, meta] = iterate(g, cost, @primal_dual_step, rest(:));
	meta.sigma = opts.sigma;
	meta.tau = opts.tau;
	meta.theta = opts.theta;
else
	error 'Unknown method ' + opts.method;
end

meta

end
