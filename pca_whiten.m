function xPCAwhite = pca_whiten(x,k)
%x is a n,m matrix; n is the feature, m is the data points
epsilon = 0.00001;
avg = mean(x, 1);     % Compute the mean pixel intensity value separately for each patch. 
x = x - repmat(avg, size(x, 1), 1); %normalization
sigma = x * x' / size(x, 2); %covariance matrix
[U,S,V] = svd(sigma);
%[U,S,V] = svdsim(sigma)
xRot = U' * x;          % rotated version of the data. %mau balik, x=U*xRot
%xTilde = U(:,1:k)' * x; % reduced dimension representation of the data, 
xPCAwhite = diag(1./sqrt(diag(S) + epsilon)) * xRot; 
xPCAwhite = xPCAwhite(1:k,:);
end
