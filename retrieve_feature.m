function train_des = retrieve_feature(train_des_name, matPath)
    allFeatures = load(strcat(matPath,strcat('\','[allFeatures].mat')));
    %allFeatures = load(strcat(matPath,strcat('/','[allFeatures].mat')));
    allFeatures = allFeatures.allFeatures;
    %allFeatures = tall(datastore(strcat(matPath,strcat('\','[allFeatures].mat')), 'Type', 'keyvalue'));
    train_des={};
    for i=1:length(train_des_name)
        disp(i);
        name_a=train_des_name{i,1}; name_b=train_des_name{i,2};
        des_a = {allFeatures(name_a)}; des_b = {allFeatures(name_b)};
        train_des = vertcat(train_des, des_a); train_des = vertcat(train_des, des_b);
    end
    %clear allFeatures;
end