% function [u] = inpainting_NATHANGASS(g,omega,lambda)
% input: g: single gray scaled image
%        omega: mask
% lambda: parameter % output: u: inpainted image
import_common();
adj  = @(u) conv2(u, [0 1 0; 1 0 1; 0 1 0], 'same');
tau  = @(u) sqrt(forx(u, 0) .^ 2 + fory(u, 0) .^ 2);
cost = @(u) (lambda/2) * sum2(omega .* (u - g) .^ 2) + sum2(tau(u));
grad = @(u) lambda * (omega .* (u - g)) + (1 ./ tau(u)) .* (4 * u - adj(u));

u = gradient_descent(g, cost, grad);

return;

%end
