function [ u, meta ] = iterate(start, cost, func, varargin)
%GRADIENT_DESCENT Summary of this function goes here
%   Detailed explanation goes here

%Options
p = inputParser;
p.addRequired('start');
p.addRequired('cost');
p.addRequired('func');
p.addOptional('iterations', 1000);
p.addOptional('error',      3e-6);
p.addOptional('plot',       0);
parse(p, start, cost, func, varargin{:})
opts = p.Results;

% Initialization
tic;

max_error = opts.error * numel(start);
last_error = max_error + 1;

it = 1;
u = start;

if opts.plot
	p = plot([cost(u)]);
	title('Cost');
	xlim([0 opts.iterations]);
	set(gca,'FontSize', 14);
	set(findall(gcf,'type','text'), 'FontSize', 20,'fontWeight','bold');
end

% Main loop
while it < opts.iterations && last_error > max_error
	[u, last_error] = func(u);
	if opts.plot
		set(p, 'YData', [get(p, 'YData'), cost(u)]);
		drawnow;
	end
    it = it + 1;
end

meta = struct('it', it, 'error', last_error / numel(start), 'cost', cost(u), 'startcost', cost(start), 'time', toc);

end
