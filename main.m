%extract features depend on pairs15.txt only, much smaller
%exist_allFeatures = exist(strcat(matPath,strcat('\','[allFeatures].mat')));
%exist_allSets = exist(strcat(matPath,strcat('\','[allSets].mat')));
exist_allFeatures = exist(strcat(matPath,strcat('/','[allFeatures].mat')));
exist_allSets = exist(strcat(matPath,strcat('/','[allSets].mat')));
if sum([exist_allFeatures,exist_allSets])==4
    %allFeatures = load(strcat(matPath,strcat('\','[allFeatures].mat')));
    allFeatures = load(strcat(matPath,strcat('/','[allFeatures].mat')));
    allFeatures= allFeatures.allFeatures;
    %allSets = load(strcat(matPath,strcat('\','[allSets].mat')));
    allSets = load(strcat(matPath,strcat('/','[allSets].mat')));
    allSets = allSets.allSets;
    jenis=input('menggunakan informasi lokasi? 1/0 untuk yes/no ');%0 kalau tanpa info lokasi;
else
    jenis=input('menggunakan informasi lokasi? 1/0 untuk yes/no ');%0 kalau tanpa info lokasi;
    [allSets, allFeatures] = featureExtractPairs(jenis, matPath, datasetPath);
    %save(strcat(matPath,strcat('\','[allSets].mat')),'allSets','-v7.3');
    %save(strcat(matPath,strcat('\','[allFeatures].mat')),'allFeatures','-v7.3');
    save(strcat(matPath,strcat('/','[allSets].mat')),'allSets','-v7.3');
    save(strcat(matPath,strcat('/','[allFeatures].mat')),'allFeatures','-v7.3');
    %clear allFeatures;
end

% prepare 4 folds idx of dataset depend on the lfw dataset
%if exist(strcat(matPath,strcat('\','[folds_idx].mat')))
if exist(strcat(matPath,strcat('/','[folds_idx].mat')))
    %folds_idx = load(strcat(matPath,strcat('\','[folds_idx].mat')));
    folds_idx = load(strcat(matPath,strcat('/','[folds_idx].mat')));
    folds_idx = folds_idx.folds_idx;
else
    folds_idx = dataPrep(allSets);
    %save(strcat(matPath,strcat('\','[folds_idx].mat')),'folds_idx','-v7.3');
    save(strcat(matPath,strcat('/','[folds_idx].mat')),'folds_idx','-v7.3');
end

%learn gmm for all possible folds, limited to only first folds
%if exist(strcat(matPath,strcat('\','[gmm_param_folds].mat')))
if exist(strcat(matPath,strcat('/','[gmm_param_folds].mat')))
   %mean_cov_priors = load(strcat(matPath,strcat('\','[gmm_param_folds].mat')));
   mean_cov_priors = load(strcat(matPath,strcat('/','[gmm_param_folds].mat')));
   mean_cov_priors = mean_cov_priors.mean_cov_priors;
   K=input('cluster for gmm? (512/256/128) ');%the cluster that will be learned in GMM from kp and des 
else
   meancovar_names={};
   K=input('cluster for gmm? (512/256/128) ');%the cluster that will be learned in GMM from kp and des 
   for i=1:length(folds_idx) %just first fold used
       disp(strcat('folds ke ',num2str(i)));
       train_des_name = folds_idx{i}{2};
       %test_des_name = folds_idx{i}{1};
       train_des=retrieve_feature(train_des_name, matPath);
       train_des=cell2mat(train_des);
       train_des = train_des';
       %learning gmm
       disp('learning gmm...');
       [means, covariances, priors]=vl_gmm(train_des,K, 'verbose'); %probably needs 1,45 hrs per fold
       mean_covar_priors={means, covariances, priors};
       filename = strcat('[mean_cov_priors_',strcat(num2str(i),'].mat'));
       %mean_cov_priors=vertcat(mean_cov_priors,{means, covariances, priors});
       disp('temporarily save...');
       meancovar_names=vertcat(meancovar_names,filename);
       %save(strcat(matPath,strcat('\',filename)),'mean_covar_priors','-v7.3');
       save(strcat(matPath,strcat('/',filename)),'mean_covar_priors','-v7.3');
   end
end

meancovar_names={};
for i=1:length(folds_idx)
    filename = strcat('[mean_cov_priors_',strcat(num2str(i),'].mat'));
    meancovar_names=vertcat(meancovar_names,filename);
end
   
   disp('saving all gmm parameters as one and clearing the temporal save...');
   mean_cov_priors={};
   for j=1:length(meancovar_names)
       name = meancovar_names{j};
       meancovar = load(strcat(matPath,strcat('\',name)));
       %meancovar = load(strcat(matPath,strcat('/',name)));
       meancovar = meancovar.mean_covar_priors;
       mean_cov_priors=vertcat(mean_cov_priors, meancovar);
   end
   save(strcat(matPath,strcat('\','[gmm_param_folds].mat')),'mean_cov_priors','-v7.3');
   %save(strcat(matPath,strcat('/','[gmm_param_folds].mat')),'mean_cov_priors','-v7.3');
   %delete(meancovar_names);


%[TRAIN_TEST_CHECK, gmmparam_exist] = train_test_check(matPath);
%folds_idx = {folds_idx{1:TRAIN_TEST_CHECK}};
%fisher encode the test data in each folds_idx, save to FOLDS
TEST_FOLDS={};
meancovar = load(strcat(matPath,'\[gmm_param_folds].mat'));
meancovar = meancovar.mean_cov_priors;
for i=1:length(folds_idx)
    gmmparam = {meancovar{i,:}};
    test_folds_name = folds_idx{i}{1};%take names each folds
    disp('retrieving test folds original feature..'); %retrieve from name
    test_folds = retrieve_feature(test_folds_name, matPath);
    test_folds = fisher_encode(test_folds, gmmparam);%encode with gmm
    TEST_FOLDS = vertcat(TEST_FOLDS,{test_folds});
end
for i=1:length(TEST_FOLDS)
    target_size=[100,2];
    TEST_FOLDS{i} = reshape_cell(TEST_FOLDS{i}, target_size);
end


%fisher encode the train data in each folds_idx, save to FOLDS
TRAIN_FOLDS={};
meancovar = load(strcat(matPath,'\[gmm_param_folds].mat'));
meancovar = meancovar.mean_cov_priors;
for i=1:length(folds_idx)
    gmmparam = {meancovar{i,:}};
    train_folds_name = folds_idx{i}{2};%take names each folds
    disp('retrieving train folds original feature..'); %retrieve from name
    train_folds = retrieve_feature(train_folds_name, matPath);
    train_folds = fisher_encode(train_folds, meancovar);%encode with gmm
    TRAIN_FOLDS = vertcat(TRAIN_FOLDS,{train_folds});
end
for i=1:length(TRAIN_FOLDS)
    target_size=[300,2];
    TRAIN_FOLDS{i} = reshape_cell(TRAIN_FOLDS{i}, target_size);
end

%plan b, make four random initialization, then call it in learning
for i=1:4
    disp(num2str(i));
    if jenis==1
        fvsize=2*K*66;
    else
        fvsize=2*K*64;
    end
    M = psd(fvsize);
    w = pca_whiten(M,K);
    namefile = strcat('[w',strcat(num2str(i),'].mat'));
    save(strcat(matPath,strcat('\',namefile)), 'w', '-v7.3');
    clear M;
end

stoping_target = input('give M maximum iteration of distance learning ');
checkpoints_hold = stoping_target/100;
checkpoints={}; initial_check = checkpoints_hold;
for z=1:100
    checkpoints=vertcat(checkpoints, initial_check);
    initial_check = initial_check+checkpoints_hold;
end

all_train_time={}; %all training time needed in every folds
all_test_time={};%all testing time needed in every folds
all_objectivefunc_history={}; %all objective function history in every folds
all_grad_history = {}; % all maximizer history
all_roc_score={}; %all roc score in every folds 
all_b={}; %all the treshold learned
for i=2:length(TRAIN_FOLDS)
   time_train_start = tic(); 
   % initialising w
   if jenis==1
       fvsize = 2*K*66;
   else
       fvsize = 2*K*64;
   end
   %M = psd(fvsize);
   %w = pca_whiten(M, K); clear M;
   name_w = strcat('[w',strcat(num2str(i),'].mat'));
   w = load(strcat(matPath,strcat('\',name_w))); w = w.w;
   %filename = strcat(matPath,strcat('\',strcat('[w',strcat(num2str(i),'].mat'))));
   %M_iter = 26489; B=? I FORGET THAT FUCK!
   %filename = strcat(matPath,strcat('\',strcat('[wt',strcat(num2str(i),'].mat'))));
   %w = load(filename); w=w.w;%p harusnya sampai 128 aja
   if size(w,1)==128
       disp('w ready');
   else
       disp('trimming...');
       w=w(1:128,:);
       disp('w ready');
   end
   % preparing 1M pairing training image
   [train_list, names] = itertools(TRAIN_FOLDS{i}, folds_idx{i}{2}, stoping_target);
   % learning w
   M_iter=1; %iterasi learning
   b=1.5; % threshold of simmiliarity
   gamma = 0.001; %learning rate
   objectivefunc_history = {}; %save the objective function history
   grad_history={}; %history maximizer
   check_iter=1; %do testing, every checkpoint
   test_time_temp={}; %simpan karena test ditengah2 checkpoint
   perform_result_temp = {}; %simpan karena test ditengah2 checkpoint
   while M_iter<=stoping_target
      disp(['training ' num2str(M_iter) '...']);
      %1a lakukan training
      theta_i_name = names{M_iter,1}; theta_j_name = names{M_iter,2};
      yij = yij_decider(theta_i_name, theta_j_name);
      theta_i = train_list{M_iter,1}; theta_j = train_list{M_iter,2};
      [dw_theta, theta_diff] = dw(theta_i, theta_j, w);
      test_val = yij*(b-dw_theta);
      objectivefunc_history = vertcat(objectivefunc_history, test_val);
      if test_val<=1
          psi = theta_diff*theta_diff';
          [w, b] = bw_updater(w, b, gamma, yij, psi);
          disp('test_val = yij*(b-dw_theta)');
          disp([num2str(test_val) ' = ' num2str(yij) ' * (' num2str(b) ' - ' num2str(dw_theta) ')']);
      else
          disp('test_val = yij*(b-dw_theta)');
          disp([num2str(test_val) ' = ' num2str(yij) ' * (' num2str(b) ' - ' num2str(dw_theta) ')']);
      end
      %plot the objective function
      grad = max(1-test_val,0); grad_history = vertcat(grad_history, grad);
      plot_obj(objectivefunc_history, M_iter);
      %check, if it's check point, do testing, and plot roc graph 
      if M_iter==checkpoints{check_iter}
          time_test_start=tic();
          %test and plot roc
          [performances, result]=dotest(folds_idx{i}{1}, TEST_FOLDS{i}, w, b);
          perform_result_temp = vertcat(perform_result_temp, {performances, result});
          time_test_end = toc(time_test_start)/60; %in term of minutes
          test_time_temp = vertcat(test_time_temp, time_test_end);
          test_val_ke = M_iter;
          %update check_iter
          check_iter = check_iter+1;
      end
      M_iter=M_iter+1;
   end
   %selesai train di fold tsb, save yang kecil2 sementara di ram
   all_b = vertcat(all_b, b); %clear
   all_objectivefunc_history = vertcat(all_objectivefunc_history,{objectivefunc_history}); %clear
   all_grad_history = vertcat(all_grad_history, {grad_history}); %clear
   all_roc_score = vertcat(all_roc_score, {perform_result_temp}); %clear
   test_time_temp = cell2mat(test_time_temp); %clear
   train_time_end = toc(time_train_start)/60; %termasuk testing di checkpoints %clear
   elapsed_train_time = train_time_end - sum(test_time_temp); %clear
   all_train_time = vertcat(all_train_time, elapsed_train_time); %clear
   all_test_temp = vertcat(all_test_time, mean(test_time_temp)); %clear
   %save only w per folds, yang besar langsung ke binary
   disp(strcat('saving w ', num2str(i)));
   name_wt = strcat('[wt_',strcat(num2str(i),'].mat'));
   %save(strcat(matPath,strcat('/',name_wt)),'w','-v7.3');
   save(strcat(matPath,strcat('\',name_wt)),'w','-v7.3');
end
disp('saving all_checkpoints...');
name_checkpoints = strcat('[all_checkpoints_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',all_b)),'checkpoints','-v7.3');
save(strcat(matPath,strcat('\',name_checkpoints)),'checkpoints','-v7.3');

%saving all the information that kept in all folds, save binary
disp('saving all_train_time...');
name_all_train_time = strcat('[all_train_time_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',name_all_train_time)),'all_train_time','-v7.3');
save(strcat(matPath,strcat('\', name_all_train_time)),'all_train_time','-v7.3');

disp('saving all_test_time...');
name_all_test_time = strcat('[all_test_time_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',name_all_test_time)),'all_test_time','-v7.3');
save(strcat(matPath,strcat('\', name_all_test_time)),'all_test_time','-v7.3');

disp('saving all_objectivefunc_history...');
name_all_objectivefunc_history = strcat('[all_objectivefunc_history_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',name_all_objectivefunc_history)),'all_objectivefunc_history','-v7.3');
save(strcat(matPath,strcat('\', name_all_objectivefunc_history)),'all_objectivefunc_history','-v7.3');

disp('saving all_objectivefunc_history...');
name_all_grad_history = strcat('[all_grad_history_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',name_all_grad_history)),'all_grad_history','-v7.3');
save(strcat(matPath,strcat('\', name_all_grad_history)),'all_grad_history','-v7.3');

disp('saving all_roc_score...');
name_all_roc_score = strcat('[all_roc_score_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',name_all_roc_score)),'all_roc_score','-v7.3');
save(strcat(matPath,strcat('\', name_all_roc_score)),'all_roc_score','-v7.3');

disp('saving all_b...');
name_all_b = strcat('[all_b_',strcat(num2str(K),'].mat'));
%save(strcat(matPath,strcat('/',all_b)),'all_b','-v7.3');
save(strcat(matPath,strcat('\',name_all_b)),'all_b','-v7.3');

disp('CONGRATS! YOU''RE DONE!');

% (optional) visualisasi titik penting dan tidak

% analisis
% 1 memory analysis
Ks=[128,192,256,512];
total_gbs=zeros(1,4);
for i=1:length(Ks)
    Ki=Ks(i);
    fvsize=2*Ki*66;
    matrix_size = fvsize*fvsize;
    usage = 4; %origin, check, s,v
    byte = 8;
    total = matrix_size*usage*byte;
    total_gb = total/1000000000;
    total
    total_gb
    total_gbs(i)=total_gb;
end
% plot PSD memory usage
plot(Ks, total_gbs);
title('Memory Usage in PSD Proses');
xlabel('K');
ylabel('gigabyte');
for j=1:length(Ks)
    xt=Ks(j); yt=total_gbs(j);
    mark = '\leftarrow ';
    info_t = strcat(strcat(num2str(xt),'|'),num2str(sprintf('%.2f',yt)));
    txt = strcat(mark,info_t);
    text(xt,yt,txt);
end

pairs=[400,1500,3000,6000];
pairs_gb=zeros(1,4);
for i=1:length(pairs)
    image_used = 2*pairs(i);
    fitur=5394*5*66;
    total_size = fitur*image_used*4;
    total_size = total_size/1000000000;
    pairs_gb(i)=total_size;
end
%plot extraction feature memory usage
plot(pairs, pairs_gb);
title('Memory Usage in extracted feature');
xlabel('pairs');
ylabel('gigabyte');
for j=1:length(pairs)
    xt=pairs(j); yt=pairs_gb(j);
    if j==4
        mark = '\leftarrow ';
        info_t = strcat(strcat(num2str(xt),'|'),num2str(sprintf('%.2f',yt)));
        txt = strcat(info_t,mark);
        text(xt,yt,txt,'HorizontalAlignment','right');
    else
        mark = '\rightarrow ';
        info_t = strcat(strcat(num2str(xt),'|'),num2str(sprintf('%.2f',yt)));
        txt = strcat(mark,info_t);
        text(xt,yt,txt,'HorizontalAlignment','left');
    end 
end

%plot error objective function
file = '\[all_objectivefunc_history_128].mat';
namefile = strcat(matPath,file); 
all_objfunc = load(namefile);
all_objfunc = all_objfunc.all_objectivefunc_history;
obj_func = all_objfunc{1};
plot_obj(obj_func,1);

%result of 128
all_roc_score_filename = strcat(matPath,'\[all_roc_score_192].mat');
all_test_time_128_filename = strcat(matPath,'\[all_test_time_192].mat');
all_train_time_128_filename = strcat(matPath,'\[all_train_time_192].mat');
all_b_filename = strcat(matPath,'\[all_b_192].mat');
all_roc_score = load(all_roc_score_filename); all_roc_score=all_roc_score.all_roc_score;
all_test_time = load(all_test_time_128_filename); all_test_time=all_test_time.all_test_time;
all_train_time = load(all_train_time_128_filename); all_train_time=all_train_time.all_train_time;
all_b = load(all_b_filename); all_b=all_b.all_b;
all_tp={}; all_tn={}; all_acc={};
for i=1:length(all_roc_score)%all folds
    disp(num2str(i));
    results={all_roc_score{i,1}{:,2}}; %100 checkpoints
    tps={}; tns={}; accs={};
    for j=1:length(results)%every check point simulate result
        disp(num2str(j));
        result = results{1,j};
        labels_plus = result(1:50,1); outputs_plus = result(1:50,2);
        stat_plus = labels_plus==outputs_plus; tp = sum(stat_plus); tp_rate = (tp/50)*100;
        
        labels_min = result(51:100,1); outputs_min = result(51:100,2);
        stat_min = labels_min==outputs_min; tn = sum(stat_min); tn_rate = (tn/50)*100;
        
        acc = ((tp+tn)/100)*100;%kebetulan jumlah data 100
        tps=vertcat(tps,tp); 
        tns=vertcat(tns,tn);
        accs=vertcat(accs,acc);
    end
    all_tp=vertcat(all_tp,{tps}); all_tn=vertcat(all_tn,{tns}); all_acc=vertcat(all_acc,{accs});
end

%visual tp,tn,akurasi 128
for i=1:length(all_tp)
    x=[1:100]*100;%checkpoint iterations
    figure(i);
    y1=cell2mat(all_tp{i});
    y2=cell2mat(all_tn{i});
    y3=cell2mat(all_acc{i});
    hold on;
    plot(x,y1,'color','r'); 
    plot(x,y2,'color','b');
    plot(x,y3,'color','g');
    title('TP/TN/ACC Plot');
    xlabel('iteration');
    ylabel('Percentage');
    legend('tp','tn','acc','Location','southwest');
end

%only testing
%meancovar_filename = strcat(matPath,'\[gmm_param_folds].mat');
%meancovar_folds = load(meancovar_filename); 
%meancovar_folds = meancovar_folds.mean_cov_priors;
%[mean, cov, prior] = meancovar_folds{1,:}; 
w_filename = strcat(matPath,'\[wt_1].mat');w = load(w_filename); w=w.w;
b_filename = strcat(matPath,'\[all_b_192].mat');b = load(b_filename); b=b.all_b; b=b{1};
[performances, result]=dotest(folds_idx{1}{1}, TEST_FOLDS{1}, w, b);
