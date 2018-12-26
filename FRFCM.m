function  [center, U, obj_U, iter_n]=FRFCM(data,cluster_n,diameter,w_size)
% Firstly, we use morphological reconstruction to reconstruct original image to suppress noise;
% Secondly, we use histogram to reduce the computational complexity of FCM;
% Thirdly, we use a median filter to smooth the fuzzy membership U;
% Finally, we normalize U;
% Input variants and parameters
  % data is a 2D matrix of size row*col, it means that the input is a gray image 
  % cluster_n denotes the number of cluster centers
  % diameter denotes the parameter of structuring element used in
  % mrophological recosntruction
  % w_size is the scale of the filtering window 

if nargin ~= 4
    error('Too many or too few input arguments!');
end
% Change the following to set default options
options = [2;   % exponent for the partition matrix 
        100;    % max. number of iteration
        1e-5;   % min. amount of improvement 
        1]; % info display during iteration 
expo = options(1);      % Exponent for U  
max_iter = options(2);      % Max. iteration 
obj_U = zeros(max_iter, 1);   % Array for objective function
%% step 1, morphological reconstruction
data=w_recons_CO(data,strel('square',diameter));
%% step 2, FCM on histogram
row=size(data, 1);col=size(data,2);
data_n = row*col;  % the number of pixels
data=data(:);
data_u=unique(data(:));% computing the histogram
n_r=size(data_u,1); % n_r denotes the number of pixels with different gray value
U=initfcm(cluster_n,n_r);   % Initial fuzzy partition
sum_U{1}=double(U>0.5);sum_U{2}=sum_U{1};
% computing histogram 
N_p=zeros(length(data_u),1);
   for i=1:length(data_u)
       N_p(i)=sum(data==data_u(i)); 
   end
 Num=ones(cluster_n,1)*N_p';
 %% main loop
dist=zeros(cluster_n,n_r);dist2=zeros(cluster_n,data_n);
for w= 1:max_iter
    mf = Num.*(U.^expo); 
    center = mf*data_u./((ones(size(data, 2), 1)*sum(mf'))');
   for k=1: size(center, 1) 
     dist(k, :)=abs(center(k)-data_u)';
   end
   tmp=dist.^2;
   h1=(tmp+eps).^(-1/(expo-1));
   U=(h1)./(ones(cluster_n,1)*(sum(h1))+eps); 
if w>2
    sum_U{w}=double(U>0.5);
    obj_U(w)=sum(sum(abs(sum_U{w}-sum_U{w-1})));
    if obj_U(w)==0,break; end,
end
end
iter_n = w; % Actual number of iterations 
%% compute membership matrix U according to cluster centers
   for k2=1: size(center, 1) 
     dist2(k2, :)=abs(center(k2)-data)';
   end
   tmp =dist2+eps;
   h1=(tmp).^(-1/(expo-1));
   U=(h1)./(ones(cluster_n,1)*(sum(h1))+eps);  
%% median filtering   
   for k3=1: size(center, 1) 
      U1= U (k3,:);      
      U1=reshape(U1,[row,col]); %reshape the vector U to a matrix of size row*col
      UU=medfilt2(U1,[w_size,w_size]); % Notice that we cann't use U1.^expo due to the high computational complexity
      GG(k3,:)=UU(:);
  end
   U=GG./(ones(cluster_n,1)*(sum(GG))+eps);  % the normalization
