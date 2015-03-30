
clear all;
close all;
clc;

scale = 0.5;
im = imresize(im2single(rgb2gray(imread('grumpycat.jpeg'))), scale);

% mask
omega = ones(size(im));
omega(unique(round((195:209) * scale)), unique(round((31:134) * scale))) = 0;
omega(unique(round((31:65) * scale)), unique(round((166:194) * scale))) = 0;

% create input image
g = im.*omega;


lambda = 0.1;

uG = inpainting_NATHANGASS(g,omega,lambda);

figure;
disp = [uG, 0*im; ...
        im, g];
imshow(disp);
