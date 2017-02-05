function [performances, result] = dotest(names_test, test_list, w, b)
    %prepare the labels (class yang sebenarnya)
    labels = {};
    outputs = {};
   
    for i=1:length(names_test)
        disp(num2str(i));
        theta_i_name = names_test{i,1}; theta_j_name = names_test{i,2};
        disp(strcat(theta_i_name, theta_j_name));
        yij = yij_decider(theta_i_name, theta_j_name);
        if yij==1
            labels = vertcat(labels, 1); %sama
        else
            labels = vertcat(labels, -1); %beda
        end
        theta_i = test_list{i,1}; theta_j = test_list{i,2};
        distance = dw(theta_i, theta_j, w);
        if distance<b 
            outputs = vertcat(outputs, 1); %sama
        else
            outputs = vertcat(outputs, -1); %beda
        end
        disp(strcat('outputs ', num2str(outputs{i})));
        disp(strcat('labels ', num2str(labels{i})));
    end
    labels_mat = cell2mat(labels);
    outputs_mat = cell2mat(outputs);
    acc=0;
    %bring to 0/1 scale
    for i=1:length(labels_mat)
        if labels_mat(i)==outputs_mat(i)
            acc = acc+1;
        end
        if labels_mat(i)==-1
           labels_mat(i)=0;
        end
        if outputs_mat(i)==-1
           outputs_mat(i)=0;
        end
    end
    acc = (acc/length(labels_mat))*100;
    [c,cm,ind, per] = confusion(labels_mat, outputs_mat);
    %disp(outputs_mat);
    %disp(labels_mat);
    %info
    [tpr, tnr, info] = vl_roc(labels_mat, outputs_mat) ;
    auc = info.auc;
    err = info.eer;
    performances = {tpr, tnr, auc, err, acc, {c,cm,ind,per}}; 
    result = {labels_mat, outputs_mat};
    result = cell2mat(result);
    %plot
    vl_roc(labels_mat, outputs_mat) ;
    %plotconfusion(labels_mat, outputs_mat);
end