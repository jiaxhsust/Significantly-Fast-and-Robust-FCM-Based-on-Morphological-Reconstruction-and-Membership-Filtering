function output_f=w_ColorRecons_CO(f,radius)
se=strel('disk',radius);
if length(size(f))<3
    disp('Please input a color image!');
else
%%
f=double(f);f_r=f(:,:,1);f_g=f(:,:,2);f_b=f(:,:,3);
f_pca=double(PCA_color(f));f1=f_pca(:,:,1);f2=f_pca(:,:,2);
%% step2 data transformation
data1=f1*10^3+f2+f_r*10^-3+f_g*10^-6+f_b*10^-9;Max1=max(max(data1));
data2=f1*10^3+f2+f_g*10^-3+f_r*10^-6+f_b*10^-9;Max2=max(max(data2));
data3=f1*10^3+f2+f_b*10^-3+f_r*10^-6+f_g*10^-9;Max3=max(max(data3));
%% step 3 data processing
imput_data1=imerode(data1,se);
imput_data2=imerode(data2,se);
imput_data3=imerode(data3,se);
f_rec1=imreconstruct(imput_data1,data1);
f_rec2=imreconstruct(imput_data2,data2);
f_rec3=imreconstruct(imput_data3,data3);
imput2_data1=imerode(Max1-f_rec1,se);
imput2_data2=imerode(Max2-f_rec2,se);
imput2_data3=imerode(Max3-f_rec3,se);
f_g1=Max1-imreconstruct(imput2_data1,Max1-f_rec1);
f_g2=Max2-imreconstruct(imput2_data2,Max2-f_rec2);
f_g3=Max3-imreconstruct(imput2_data3,Max3-f_rec3);
end
%% return to RGB format
tt1=f_g1-floor(f_g1);
tt2=f_g2-floor(f_g2);
tt3=f_g3-floor(f_g3);
g1_r=floor(tt1*10^3);
g1_g=floor(tt2*10^3);
g1_b=floor(tt3*10^3);
output_f=cat(3,uint8(g1_r),uint8(g1_g),uint8(g1_b));
