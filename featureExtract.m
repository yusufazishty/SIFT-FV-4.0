function allFeatures = featureExtract(jenis, existance, path)
    datasetPath = strcat(pwd,'\lfw');
    curdir = dir(datasetPath);
    allNames = {curdir(:).name};
    allNames(ismember(allNames,{'.','..'}))=[]; %avoid . dan ..
    allFiles = {};
    if exist(strcat(matPath,strcat('\','[allFiles].mat')))
        disp('allFiles already exist, loading..')
        allFiles = load(strcat(matPath,strcat('\','[allFiles].mat')));
        allFiles = allFiles.allFiles;
    else
        %get all files
        disp('getting allFiles..')
        for i=1:length(allNames)
            %for each sub dir get subfiles
            subDir = strcat(datasetPath,strcat('\',allNames{i}));
            subFiles = dir(subDir);
            subFiles = {subFiles(:).name};
            subFiles(ismember(subFiles,{'.','..'}))=[]; %avoid . dan ..
            for j=1:length(subFiles)
                %for each subfiles, insert to the allFiles
                imageName = strcat(subDir,strcat('\',subFiles{j}));
                if length(allFiles)==0
                    allFiles = {imageName};
                else
                    allFiles = vertcat(allFiles,{imageName});
                end
            end
        end
        disp('saving allFiles');
        save(strcat(matPath,strcat('\','[allFiles].mat')), 'allFiles', '-v7.3');
    end
    
    %each files preprocess>> grayscale, viola-jones, crop to face, resize
    %to [160,125],than get dsift, and stack it up
    %splitting index
    splitting=[2000:2000:length(allFiles)]; splitting=[splitting, length(allFiles)];
    splitting_idx={};
    for i=1:length(splitting)
        if i==1
            idx = [1:splitting(i)];
        elseif i==length(splitting)
            idx = [splitting(i-1)+1:splitting(length(splitting))];
        else
            idx=[splitting(i-1)+1:splitting(i)];
        end    
        splitting_idx = vertcat(splitting_idx, idx);
    end
    %extract for each split, than save separately
    for k=1:length(splitting_idx)
        %disp(strcat(char(k),strcat('/',char(length(splitting_idx)))));
        %disp(strcat(k,'...'));
        if existance(k)==2%already extracted
            continue
        else
            disp('extracting...');
            keys =cell(1,length(splitting_idx{k}));
            values=cell(1,length(splitting_idx{k}));
            for j=1:length(splitting_idx{k})
                name = strsplit(allFiles{splitting_idx{k}(j)},'\');
                name = char(name(length(name)));
                disp(name);
                keys{j}=name;
                image = imread(allFiles{j});
                image = preprocess(image);
                des = getDsift(image, jenis);
                values{j} = {des};
            end
            allFeatures = containers.Map(keys,values);
            namefile = strcat('[allFeatures',strcat(num2str(k),'].mat'));
            disp(strcat('saving',num2str(k)));
            save(strcat(path,strcat('\',namefile)),'allFeatures','-v7.3');
            %clear allFeatures, keys, values;
        end
    end
end
