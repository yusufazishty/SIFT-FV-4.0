function folds_idx = dataPrep(allSets)
  %buat bound nya dulu untuk membagi 400 nama ke 4 slot
  bound = zeros(1,4);
  iter_bound=1;
  for i=100:100:400
      bound(iter_bound)=i; iter_bound=iter_bound+1;
  end
  bounds=cell(1,4);
  for i=1:length(bound)
      if i==1
          val=[1:bound(i)];
      elseif i==length(bound)
          val=[bound(length(bound)-1)+1:bound(length(bound))];
      else
          val=[bound(i-1)+1:bound(i)];
      end
      bounds{i}=val;    
  end
  
  %pair name 4 slot
  pair_name=cell(4,1);
  for i=1:length(bounds)
      %pair_folds{i,1:600,1}
      a={allSets{bounds{i},1}}';
      b={allSets{bounds{i},2}}';
      pair_name{i}=horzcat(a,b);
  end
  
  %4 folds berisi nama testing dan training
  pair_folds=cell(4,1);
  for i=1:length(pair_folds)
      for j=1:length(pair_name)
          if j==1
              test_name = pair_name{j};
              train_idx = [j+1:length(pair_name)];
              train_name={};
              train_name = vertcat(train_name,pair_name{train_idx});
          elseif j==length(pair_name)
              test_name = pair_name{j};
              train_idx = [1:length(pair_name)-1];
              train_name={};
              train_name = vertcat(train_name, pair_name{train_idx});
          else
              test_name = pair_name{j};
              train_idx = [1:j-1,j+1:length(pair_name)];
              train_name={};
              train_name = vertcat(train_name, pair_name{train_idx});
          end
      end
      pair_folds{i}={test_name, train_name};
  end
  folds_idx = pair_folds;
  clear pair_folds;
end

  
   %doesnt need this one here yet, we only take the names 
%   folds={};
%   for i=1:10
%       test_pair = pair_folds{i}{1};
%       train_pair = pair_folds{i}{2};
%       kp_test_a={}; des_test_a={}; kp_test_b={}; des_test_b={};
%       for j=1:length(test_pair)
%           kpdes_a=allFeatures(test_pair{j,1}); kpdes_b=allFeatures(test_pair{j,2});
%           kp_test_a=vertcat(kp_test_a,kpdes_a{1}); des_test_a=vertcat(des_test_a,kpdes_a{2});
%           kp_test_b=vertcat(kp_test_b,kpdes_b{1}); des_test_b=vertcat(des_test_b,kpdes_b{2});
%       end
%       kp_train_a={}; des_train_a={}; kp_train_b={}; des_train_b={};
%       for j=1:length(train_pair)
%           kpdes_a=allFeatures(train_pair{j,1}); kpdes_b=allFeatures(train_pair{j,2});
%           kp_train_a=vertcat(kp_train_a,kpdes_a{1}); des_train_a=vertcat(des_train_a,kpdes_a{2});
%           kp_train_b=vertcat(kp_train_b,kpdes_b{1}); des_train_b=vertcat(des_train_b,kpdes_b{2});
%       end
%       test = {kp_test_a, des_test_a, kp_test_b, des_test_b};
%       train = {kp_train_a,des_train_a, kp_train_b, des_train_b};
%       folds=vertcat(folds,{test,train});
%   end
  
  %lookup cari fitur, buka tutup pada pair name yang dibutuhkan %this is
  %wasting time, not eficient
%   files = dir(path); files = {files.name}; 
%   files(ismember(files,{'.','..'}))=[];
%   for i=1:length(files)
%       name = files{i}; 
%       name = strcat(path,strcat('\',name));
%       files{i}=name;
%   end
   
%   pair_name_features={}
%   for i=1:length(pair_name)
%       for k=1:length(files)
%           features = load(files{k});
%           existance_feature = 0;
%           for j=1:length(pair_name{j})
%               search_a = pair_name{i}{j,1};
%               search_b = pair_name{i}{j,2};
%               exist_a = features.(search_a);
%               exist_b = features.(search_b);
%           end
%       end
%   end