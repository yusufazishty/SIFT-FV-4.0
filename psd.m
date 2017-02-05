function M = psd(n)
A = randn(n);
[U,ignore] = eig((A+A')/2); % (Don't really have to divide by 2)
M = U*diag(abs(randn(n,1)))*U';
%all(diag(eig((M+M')/2))) >= 0
pass = all(eig((M+M')/2)) >= 0;
if pass==1
    disp('psd matrix created');
else
    disp('non psd matrix created');
end
end