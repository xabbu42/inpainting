
clear all;
close all;
clc;

scale = 1;
im = imresize(im2single(rgb2gray(imread('grumpycat.jpeg'))), scale);

% mask
omega = ones(size(im));
omega(unique(round((195:209) * scale)), unique(round((31:134) * scale))) = 0;
omega(unique(round((31:65) * scale)), unique(round((166:194) * scale))) = 0;

% create input image
g = im.*omega;

lambda = 200;

uG = inpainting_NATHANGASS(g,omega,lambda, 'plot', 1, 'iterations', 600, 'sigma', 0.5, 'tau', 0.5, 'theta', 0.2);
%uG = inpainting_NATHANGASS(g,omega,lambda, 'alpha', 1/3, 'beta', 0.5, 'plot', 1, 'iterations', 5000);
%uG = inpainting_NATHANGASS(g, omega,lambda, 'constantstep', 3e-3, 'plot', 1, 'iterations', 2000);

di = abs(g - uG);
di = di / max(di(:));

figure;
disp = [uG, di; im, g];
imshow(disp);
