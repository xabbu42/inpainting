
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


lambda = 100;

uG = inpainting_NATHANGASS(g,omega,lambda, 'alpha', 1e-2, 'beta', 0.5, 'plot', 1, 'iterations', 5000);
di = abs(g - uG);
di = di / max(di(:));

figure;
disp = [uG, di; im, g];
imshow(disp);
