
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
late  = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 2500);
final = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 5000);
imwrite(early, 'early.png');
imwrite(mid,   'mid.png');
imwrite(late,  'late.png');
imwrite(final, 'final.png');

% different lambdas
vlow = inpainting_NATHANGASS(g, omega,  10, args{:});
low  = inpainting_NATHANGASS(g, omega,  50, args{:});
good = inpainting_NATHANGASS(g, omega, 100, args{:});
high = inpainting_NATHANGASS(g, omega, 500, args{:});

imwrite(vlow, 'vlow_lambda.png');
imwrite(low,  'low_lambda.png');
imwrite(good, 'good_lambda.png');
imwrite(high, 'high_lambda.png');

% plot lambda vs ssd to original
lambda = linspace(1, 500, 50);
ssd = zeros(10, 1);
besti = 1;
i = 1;
for i = 1:length(lambda)
    lambda(i)
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
set(gca,'FontSize', 10);
print('plot', '-dpng');


