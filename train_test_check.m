function [TRAIN_TEST_CHECK, gmmparam_exist] = train_test_check(matPath)
    gmmparam_exist = exist(strcat(matPath,'/[gmm_param_folds].mat'));
    if gmmparam_exist==0
        %check [mean_cov_priors_1...10]
        meancovprior_names ={};
        for i=1:10
            name = strcat('[mean_cov_priors_',strcat(num2str(i),'].mat'));
            name = strcat(matPath, strcat('\',name));
            %name = strcat(matPath, strcat('/',name));
            meancovprior_names = vertcat(meancovprior_names, name);
        end
        meancovprior_exist=zeros(10,1);
        for i=1:10
            existance = exist(meancovprior_names{i});
            meancovprior_exist(i) = existance;
        end
        jumlah_meancov = sum(meancovprior_exist)/2;
    else
        jumlah_meancov = 10;
    end
     %check [w1...10]
     w_names ={};
     for i=1:10
         name = strcat('[w',strcat(num2str(i),'].mat'));
         name = strcat(matPath, strcat('\',name));
         %name = strcat(matPath, strcat('/',name));
         w_names = vertcat(w_names, name);
     end
     w_exist=zeros(10,1);
     for i=1:10
         existance = exist(w_names{i});
         w_exist(i) = existance;
     end
     jumlah_w = sum(w_exist)/2;
     TRAIN_TEST_CHECK = min(jumlah_meancov, jumlah_w);
end