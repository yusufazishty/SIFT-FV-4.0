function [allSets, allFeatures] = featureExtractPairs(jenis, matPath, datasetPath)
    allSets = allSetsPrep(matPath);
    datasetPath = strcat(datasetPath,'\lfw\'); %windows section
    %datasetPath = strcat(datasetPath,'/lfw/'); %linux section
    %allFeatures = {}; %allFeatures=tall({});
    keys={};
    values={};
    for i=1:length(allSets)
        file_a=allSets{i,1};
        file_b=allSets{i,2};
        dir_a = strsplit(file_a,'.'); dir_a = dir_a{1};
        dir_b = strsplit(file_b,'.'); dir_b = dir_b{1};
        dir_a = strsplit(dir_a,'_'); dir_a = {dir_a{1:length(dir_a)-1}};
        disp(i);
        for l=1:length(dir_a)
            if l==1
                name_a = dir_a{l};
            else
               name_a = strcat(name_a, '_');
               name_a = strcat(name_a, dir_a{l});
            end
        end
        dir_b = strsplit(dir_b,'_'); dir_b = {dir_b{1:length(dir_b)-1}};
        for l=1:length(dir_b)
            if l==1
                name_b = dir_b{l};
            else
               name_b = strcat(name_b, '_');
               name_b = strcat(name_b, dir_b{l});
            end
        end
        %get_a = strcat(datasetPath,strcat(name_a,strcat('\',file_a)));
        %get_b = strcat(datasetPath,strcat(name_b,strcat('\',file_b)));
        get_a = strcat(datasetPath,strcat(name_a,strcat('/',file_a)));
        get_b = strcat(datasetPath,strcat(name_b,strcat('/',file_b)));
        image_a = imread(get_a); image_a = preprocess(image_a); des_a = getDsift(image_a, jenis);
        image_b = imread(get_b); image_b = preprocess(image_b); des_b = getDsift(image_b, jenis);
        keys=vertcat(keys, file_a); values=vertcat(values, {des_a});
        keys=vertcat(keys, file_b); values=vertcat(values, {des_b});
    end
    allFeatures = containers.Map(keys,values);
    disp('saving allFeatures...');
    %save(strcat(matPath,'\[allFeatures].mat'),'allFeatures','-v7.3');
    save(strcat(matPath,'/[allFeatures].mat'),'allFeatures','-v7.3');
    %clear allFeatures, keys, values;
end
