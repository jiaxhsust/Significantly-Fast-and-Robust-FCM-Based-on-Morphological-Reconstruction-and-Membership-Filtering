% Please cite the paper "Tao Lei, Xiaohong Jia, Yanning Zhang, Lifeng He, Hongying Meng and Asoke K. Nandi, Significantly Fast and Robust
% Fuzzy C-Means Clustering Algorithm Based on Morphological Reconstruction and Membership Filtering, IEEE Transactions on Fuzzy Systems,
% DOI: 10.1109/TFUZZ.2018.2796074, 2018.2018"

% The paper is OpenAccess and you can download the paper freely from "http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8265186."
% The code was written by Tao Lei in 2017.
% If you have any problems, please contact me. 
% Email address: leitao@sust.edu.cn

clc
close all     
clear all   
%% test a gray image 
f_ori=imread('brain.bmp');
fn=imnoise(f_ori,'gaussian',0.03);
%% parameters
cluster=3; % the number of clustering centers
se=3; % the parameter of structuing element used for morphological reconstruction
w_size=3; % the size of fitlering window
%% segment an image corrupted by noise
tic 
[center1,U1,~,t1]=FRFCM(double(fn),cluster,se,w_size);
Time1=toc;
disp(strcat('running time is: ',num2str(Time1)))
f_seg=fcm_image(f_ori,U1,center1);
imshow(fn),title('Original image');
figure,imshow(f_seg);title('segmentated result');
