% function [u] = inpainting_NATHANGASS(g,omega,lambda)
% input: g: single gray scaled image
%        omega: mask
% lambda: parameter % output: u: inpainted image

msum = @(m) sum(sum(m));
forx = @(u) conv2(u, [1 -1], 'same');
fory = @(u) conv2(u, [1 -1]', 'same');
adj  = @(u) conv2(u, [0 1 0; 1 0 1; 0 1 0], 'same');
tau  = @(u) sqrt(forx(u) .^ 2 + fory(u) .^ 2);
cost = @(u) (lambda/2) * msum(omega .* (u - g) .^ 2) + msum(tau(u));
grad = @(u) lambda * (omega .* (u - g)) + (1 ./ tau(u)) .* (4 * u - adj(u));

u = gradient_descent(g, cost, grad);

return;

%end
