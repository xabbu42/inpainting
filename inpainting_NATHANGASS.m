function [u] = inpainting_NATHANGASS(g,omega,lambda,varargin)
% input: g: single gray scaled image
%        omega: mask
% lambda: parameter % output: u: inpainted image
import_common();
cost = @(u) (lambda/2) * sum2(omega .* (u - g) .^ 2) + forw_total_variation(u);
grad = @(u) lambda * (omega .* (u - g)) + forw_total_variation_grad(u);

[u, meta] = gradient_descent(g, cost, grad, varargin{:});

meta

return;

%end
