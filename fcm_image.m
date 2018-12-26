% This function is only suitabe for gray image
function gx=fcm_image(f,U,center)
[m,n]=size(f);
[~,idx_f]=max(U);
imput_f=reshape(idx_f,[m n]); 
imput_ff=zeros(m,n); %input_ff denotes the classification result based on the cluster center
for k=1:length(center(:,1))
    t=(imput_f==k).*center(k);
    imput_ff=imput_ff+t; 
end
gx=uint8(imput_ff);

