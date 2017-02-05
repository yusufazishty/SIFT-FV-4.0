function encoded = fisher_encode(test_folds, meancovar)
   mean = meancovar{1,1};
   covariance = meancovar{1,2};
   prior = meancovar{1,3};
   disp('encoding...');
   encoded={};
   for i=1:length(test_folds)
       %disp(num2str(i));
       dataToEncode = test_folds{i};
       dataToEncode = cell2mat(dataToEncode);
       dataToEncode = dataToEncode';
       fv_vector = vl_fisher(dataToEncode, mean, covariance, prior);
       encoded = vertcat(encoded, fv_vector);
   end
end