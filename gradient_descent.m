function [ u ] = gradient_descent(start, cost, grad, varargin)
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
it = 1;
max_gradnorm = opts.error * numel(start);
converged = false;
u = start;

while it < opts.iterations && ~converged
    gradu  = grad(u);
    costu  = cost(u);
    linear = opts.alpha * sum(sum(gradu .* u)); %TODO should not assume 2 dimensionsal problem
    
    % backtrack search
    t = 1;
    while cost(u - t * gradu) > costu - t*linear
        t = opts.beta*t;
    end
    
    % Update
    u = u - t * gradu;
   
    % Stopping criterion
    if norm(gradu, 'fro') < max_gradnorm
        converged = true;
    end
    
    it = it + 1;
end

end

