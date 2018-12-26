function  [center, U, obj_fcn,iter_n]=FRFCM_c(data,cluster_n,radius,w_size,options)
% Firstly, we use multivariate morphological reconstruction to reconstruct original image to suppress noise;
% Secondly, we implement FCM;
% Thirdly, we use a median filter to smooth the fuzzy membership U;
% Finally, we normalize U;
% Input variants and parameters
  % data is a 3D data, it means that the input is a color image 
  % cluster_n denotes the number of cluster centers
  % radius denotes the parameter of structuring element used in
  % mrophological recosntruction
  % w_size is the scale of the filtering window 
 
if nargin ~= 4 & nargin ~= 5
    error('Too many or too few input arguments!');
end
% Change the following to set default options
default_options = [2;	% exponent for the partition matrix U
		100;	% max. number of iteration
		1e-5;	% min. amount of improvement
		0];	% info display during iteration 

if nargin == 4,
	options = default_options;
else
	% If "options" is not fully specified, pad it with default values.
	if length(options) < 4,
		tmp = default_options;
		tmp(1:length(options)) = options;
		options = tmp;
	end
	% If some entries of "options" are nan's, replace them with defaults.
	nan_index = find(isnan(options)==1);
	options(nan_index) = default_options(nan_index);
	if options(1) <= 1,
		error('The exponent should be greater than 1!');
	end
end
expo = options(1);      % Exponent for U 
max_iter = options(2);      % Max. iteration 
min_impro = options(3);     % Min. improvement 
display = options(4);       % Display info or not 
obj_fcn = zeros(max_iter, 1);   % Array for objective function
%% step 1, morphological reconstruction
data_rgb=w_ColorRecons_CO(data,radius); %radius means maximal radius
data_lab=colorspace('Lab<-RGB',data_rgb); 
%% step 2, FCM on histogram
data_l=data_lab(:,:,1);data_a=data_lab(:,:,2);data_b=data_lab(:,:,3);
data=[data_l(:)';data_a(:)';data_b(:)']';
%iter_n=0; % actual number of iteration
row=size(data_a,1);col=size(data_a,2);
U = initfcm(cluster_n, row*col);			% Initial fuzzy partition
% Main loop 
for i = 1:max_iter
    %% stepfcm [U, center, obj_fcn(i)] = stepfcm(data, U, cluster_n, expo);
    mf = U.^expo;       % MF matrix after exponential modification
    center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % new center
    %% dist = distfcm(center, data);       % fill the distance matrix
     out = zeros(size(center, 1), size(data, 1));
% fill the output matrix
if size(center, 2) > 1,
    for k = 1:size(center, 1),
	out(k, :) = sqrt(sum(((data-ones(size(data, 1), 1)*center(k, :)).^2)'));
    end
else	% 1-D data 
    for k = 1:size(center, 1),
	out(k, :) = abs(center(k)-data)';
    end
end
  dist=out+eps;
    %% distfcm end
    obj_fcn(i) = sum(sum((dist.^2).*mf));  % objective function
    tmp = dist.^(-2/(expo-1));      % calculate new U, suppose expo != 1
    U = tmp./(ones(cluster_n, 1)*sum(tmp)+eps);
    Uc{i}=U;
	if i > 1,
		%if abs(obj_fcn(i) - obj_fcn(i-1))/obj_fcn(i) < min_impro, break; end,
        if max(max(abs(Uc{i}-Uc{i-1})))< min_impro,break; end,
	end
end
iter_n = i;	% Actual number of iterations 
obj_fcn(iter_n+1:max_iter) = []; 
%% median filtering   
   for k3=1: size(center, 1) 
      U1= U (k3,:);      
      U1=reshape(U1,[row,col]); %reshape the vector U to a matrix of size row*col
      UU=medfilt2(U1,[w_size,w_size]); % Notice, we cann't use U1.^expo due to the problem of high computational complexity
      GG(k3,:)=UU(:);
  end
   U=GG./(ones(cluster_n,1)*(sum(GG))+eps);  % the normalization of 
   center_l=center(:,1);center_a=center(:,2);center_b=center(:,3);center_lab=cat(3,center_l,center_a,center_b);
   center=255*colorspace('RGB<-Lab',center_lab);
