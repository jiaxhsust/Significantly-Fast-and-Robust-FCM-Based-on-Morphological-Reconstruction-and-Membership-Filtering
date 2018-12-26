% This function is only suitabe for color image
function gx=fcm_image_color(f,U) 
m=size(f,1);n=size(f,2);
U=U';
idx_f=zeros(m*n,1);
for i=1:m*n
x=U(i,:);
idx=find(x==max(x)); % Computing the classification index of matrix weighted 
idx=idx(1);
idx_f(i)=idx; %idx_f denotes the classification image based on index
end
imput_f=reshape(idx_f,[m n]); 
gx=Label_image(f,imput_f);


