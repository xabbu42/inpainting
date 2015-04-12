function [ u, meta ] = gradient_descent(start, cost, grad, varargin)
%GRADIENT_DESCENT Summary of this function goes here
%   Detailed explanation goes here

%Options
p = inputParser;
p.addRequired('start');
p.addRequired('cost');
p.addRequired('grad');
p.addOptional('iterations', 1000);
p.addOptional('alpha',      1e-2);
p.addOptional('beta',       0.5);
p.addOptional('error',      3e-6);
p.addOptional('plot',       0);
parse(p, start, cost, grad, varargin{:})
opts = p.Results;

%% Gradient descent
tic;

max_error = opts.error * numel(start);
last_error = max_error + 1;

it = 1;
u = start;
costu = cost(u);

if opts.plot
	p = plot([costu]);
	title('Cost');
	xlim([0 opts.iterations]);
	set(gca,'FontSize', 14);
	set(findall(gcf,'type','text'), 'FontSize', 20,'fontWeight','bold');
end

while it < opts.iterations && last_error > max_error

    gradu  = grad(u);
	gradu_norm_squared = sum(sum(gradu .^ 2));  %TODO should not assume 2 dimensionsal problem
    linear = opts.alpha * gradu_norm_squared;

    % backtrack line search
    t = 1;
    while 1
        step = t * gradu;
        newu = u - step;
        costnewu = cost(newu);
        if ~isfinite(costnewu)
            error 'inf or nan cost';
        end
        if costnewu <= costu - t * linear
            break;
        end
        t = opts.beta*t;
    end

    % Update
    u = newu;
    costu = costnewu;

	if opts.plot
		set(p, 'YData', [get(p, 'YData'), costu]);
		drawnow;
	end
    last_error = sqrt(gradu_norm_squared);
    it = it + 1;
end

meta = struct('it', it, 'error', last_error / numel(start), 'cost', cost(u), 'time', toc);

end

