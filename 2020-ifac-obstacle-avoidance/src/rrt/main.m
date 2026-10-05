clear all
close all
I = rgb2gray(imread('mapa.bmp'));
start = [50 50];
finish = [700 700];
[tree,path,indexV] = rrt(I,start,finish);

