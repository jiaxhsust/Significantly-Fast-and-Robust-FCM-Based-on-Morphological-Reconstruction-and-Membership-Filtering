% Please cite the paper "Tao Lei, Xiaohong Jia, Yanning Zhang, Lifeng He, Hongying Meng and Asoke K. Nandi, Significantly Fast and Robust
% Fuzzy C-Means Clustering Algorithm Based on Morphological Reconstruction and Membership Filtering, IEEE Transactions on Fuzzy Systems,
% DOI: 10.1109/TFUZZ.2018.2796074, 2018.2018"
%and
%Tao. Lei, Yanning Zhang, Yi Wang, Shigang Liu, and Zhe Guo, "A Conditionally Invariant Mathematical Morphological Framework for Color Images," 
%Information Sciences, Vol. 387, no. 5, pp. 34-52, May. 2017. 

% The first paper is OpenAccess and you can download the paper freely from "http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8265186."
% The code was written by Tao Lei in 2017.
% If you have any problems, please contact me. 
% Email address: leitao@sust.edu.cn

clc
close all    
clear all   
%% parameters
cluster=3; % the number of clustering centers
se=3; % the parameter of structuing element used for morphological reconstruction
w_size=3; % the size of fitlering window
%% test a color image
fileID='12003';
f_ori=imread('12003.jpg');
GT=load('12003.mat'); % Ground Truth, download from 'https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html'
f_ori=double(f_ori);
%% implement the proposed algorithm
tic 
[~,U1,~,~]=FRFCM_c(double(f_ori),cluster,se,w_size);
Time1=toc;
disp(strcat('running time is: ',num2str(Time1)))
f_ori;
f_seg=fcm_image_color(f_ori,U1);
imshow(f_seg);
