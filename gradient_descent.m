function [ u, meta ] = gradient_descent(start, cost, grad, varargin)
%GRADIENT_DESCENT Summary of this function goes here
%   Detailed explanation goes here

%Options
p = inputParser;
p.addRequired('start');
p.addRequired('cost');
p.addRequired('grad');
p.addOptional('iterations', 5000);
p.addOptional('alpha',      0.05);
p.addOptional('beta',       0.05);
p.addOptional('error',      3e-6);
parse(p, start, cost, grad, varargin{:})
opts = p.Results;

%% Gradient descent
tic;
it = 1;
max_error = opts.error * numel(start);
last_error = max_error + 1;
u = start;
costu = cost(u);
while it < opts.iterations && last_error > max_error
    gradu  = grad(u);
    linear = opts.alpha * sum(sum(gradu .^ 2)); %TODO should not assume 2 dimensionsal problem
    
    % backtrack search
    t = 1;
    while 1
        newu = u - t * gradu;
        costnewu = cost(newu);
        if costnewu <= costu - t * linear
            break;
        end
        t = opts.beta*t;
    end
    
    % Update
    step = t * gradu;
    u = newu;
    costu = costnewu;
	last_error = norm(gradu, 'fro');
    it = it + 1;
end

meta = struct('it', it, 'error', last_error / numel(start), 'cost', cost(u), 'time', toc);

end

