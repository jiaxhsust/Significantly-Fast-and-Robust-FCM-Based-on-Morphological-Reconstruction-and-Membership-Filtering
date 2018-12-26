function g=PCA_color(f)
f1=f(:,:,1);f2=f(:,:,2);f3=f(:,:,3);
data=double([f1(:)';f2(:)';f3(:)']);
[~,c]=size(data);
m=mean(data')';
d=data-repmat(m,1,c);
% Compute the covariance matrix (co) 
co=d*d';
% Compute the eigen values and eigen vectors of the covariance matrix 
[eigvector,eigvl]=eig(co);
% Sort the eigen vectors according to the eigen values 
eigvalue = diag(eigvl);
[~, index] = sort(-eigvalue);
eigvalue = eigvalue(index);
eigvector = eigvector(:, index);
% Compute the number of eigen values that greater than zero (you can select any threshold)
count1=0;
for i=1:size(eigvalue,1)
    if(eigvalue(i)>0)
        count1=count1+1;
    end
end
% We can use all the eigen vectors but this method will increase the
% computation time and complixity
%vec=eigvector(:,:);

% And also we can use the eigen vectors that the corresponding eigen values is greater than zero(Threshold) and this method will decrease the
% computation time and complixity
vec=eigvector(:,1:count1);
% Compute the feature matrix (the space that will use it to project the testing image on it)
x=vec'*d; 
x2=x+repmat(m,1,c); 
x2=uint8(x2);
x2_1=x2(1,:);x2_2=x2(2,:);x2_3=x2(3,:);
s1=size(f1,1);s2=size(f1,2);
f_1=zeros(s1, s2);f_2=f_1;f_3=f_1;
for j=1:s2
    f_1(:,j)=x2_1((j-1)*s1+1:j*s1);
    f_2(:,j)=x2_2((j-1)*s1+1:j*s1);
    f_3(:,j)=x2_3((j-1)*s1+1:j*s1);
end
g=cat(3,uint8(f_1),uint8(f_2),uint8(f_3));
