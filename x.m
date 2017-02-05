%    test={};
%    for j=1:length(test_des_name)
%         name_a = test_des_name{j}';
%         name_b = test_des_name{j}';
%         test=vertcat(test,des_a); test=vertcat(test,des_b);
%    end 
%    test=cell2mat(test); test=single(test);
%    test = test';
%    % encoding fisher vector 
%    test_fisher = vl_fisher(test, means, covariances, priors);





%only run once to get all features for all files, butyou won't need that
%again, only focus to the pairs.txt, and extract their feature
%open the dataset folder (big file)
%path = uigetdir('F:\Dropbox\[PENTING TIDAK URGENT]\[ARSIP KULIAH]\Semester 9\#TUGAS_AKHIR\Apps\[GIT]\4.0');
%check wether dataset.m is exist or not
%exist1=exist(strcat(path,'\[allFeatures1].mat')); exist2=exist(strcat(path,'\[allFeatures2].mat'));
%exist3=exist(strcat(path,'\[allFeatures3].mat')); exist4=exist(strcat(path,'\[allFeatures4].mat'));
%exist5=exist(strcat(path,'\[allFeatures5].mat')); exist6=exist(strcat(path,'\[allFeatures6].mat'));
%exist7=exist(strcat(path,'\[allFeatures7].mat'));
%existance = [exist1,exist2,exist3,exist4,exist5,exist6,exist7];
%if sum(existance)==14 
    %allFeatures = load('dataset.mat');
    %allFeatures = allFeatures.allFeatures;
%    datasetStatus = 1; %0, jika g lengkap. look up, buka tutup satu2
%else
%    jenis=1;%0 kalau tanpa info lokasi;
%    featureExtract(jenis, existance, path);
%end

%don't need to visualize learned gmm
       %visualize learned gmm
       %figure;
       %hold on;
       %for j=1:size(data,1)
       %    plot(data(j,:),'r.');
       %end
       %for j=1:K
       %    vl_plotframe([means(:,i)' covariances()])
       %end