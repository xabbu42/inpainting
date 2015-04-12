
clear all;
close all;
clc;

import_common;

im = im2single(rgb2gray(imread('grumpycat.jpeg')));
imwrite(im, 'original.png');

% gradient descent args
args = {'alpha', 1e-2, 'beta', 0.5, 'iterations', 2500};

% mask
omega = ones(size(im));
omega(195:209,31:134) = 0;
omega(31:65,166:194) = 0;

% create input image
g = im.*omega;
imwrite(g, 'input.png');

% different stages
early = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 10);
mid   = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 1000);
final = inpainting_NATHANGASS(g, omega,   100, args{:});
imwrite(early, 'early.png');
imwrite(mid,   'mid.png');
imwrite(final, 'final.png');

% different lambdas
low  = inpainting_NATHANGASS(g, omega,  50, args{:});
high = inpainting_NATHANGASS(g, omega, 500, args{:});

imwrite(low, 'low_lambda.png');
imwrite(high, 'high_lambda.png');

% plot lambda vs ssd to original

lambda = linspace(1, 600, 50);
ssd = zeros(10, 1);
besti = i = 1;
for i = 1:length(lambda)
	res = inpainting_NATHANGASS(g, omega, lambda(i), args{:});
	ssd(i) = qnorm2(res - im);
	if (ssd(i) < ssd(besti))
		best = res;
		besti = i;
	end
end

lambda(besti)
ssd(besti)

imwrite(best, 'best.png');

plot(lambda, ssd);
xlabel('lambda');
ylabel('SSD');
set(gca,'FontSize', 14);
set(findall(gcf,'type','text'), 'FontSize', 20,'fontWeight','bold');
print('plot', '-dpng');


