
clear all;
close all;
clc;

import_common;

im = im2single(rgb2gray(imread('grumpycat.jpeg')));
imwrite(im, 'original.png');

% mask
omega = ones(size(im));
omega(195:209,31:134) = 0;
omega(31:65,166:194) = 0;

% create input image
g = im.*omega;
imwrite(g, 'input.png');

args = {'method', 'gradientdescent', 'alpha', 1/3, 'beta', 0.5, 'iterations', 5000};
%args = {'method', 'primaldual', 'sigma', 0.5, 'tau', 0.5, 'theta', 0.2, 'iterations', 600};

name = args{2};

% different stages
early = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 10);
mid   = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 1000);
late  = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 2500);
final = inpainting_NATHANGASS(g, omega,   100, args{:}, 'iterations', 5000);
imwrite(early, strcat(name, '-early.png'));
imwrite(mid,   strcat(name, '-mid.png'));
imwrite(late,  strcat(name, '-late.png'));
imwrite(final, strcat(name, '-final.png'));

% different lambdas
vlow = inpainting_NATHANGASS(g, omega,  10, args{:});
low  = inpainting_NATHANGASS(g, omega,  50, args{:});
good = inpainting_NATHANGASS(g, omega, 100, args{:});
high = inpainting_NATHANGASS(g, omega, 500, args{:});

imwrite(vlow, strcat(name, '-vlow_lambda.png'));
imwrite(low,  strcat(name, '-low_lambda.png'));
imwrite(good, strcat(name, '-good_lambda.png'));
imwrite(high, strcat(name, '-high_lambda.png'));

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

save(strcat(name, '-plotdata.mat'), 'lambda', 'ssd', 'besti');

lambda(besti)
ssd(besti)

imwrite(best, strcat(name, '-best.png'));

plot(lambda, ssd);
xlabel('lambda');
ylabel('SSD');
set(gca,'FontSize', 10);
set(findall(gcf,'type','text'), 'FontSize', 12, 'fontWeight','bold');
print(strcat(name, '-plot'), '-dpng');
