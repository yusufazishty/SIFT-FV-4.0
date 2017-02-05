function [target, names] = itertools (curent_list, folds_idx_names, stoping_target)
    %curent_list = TRAIN_FOLDS{i}; 
    %folds_idx_names = folds_idx{i}{2}; 
    stoping_target = stoping_target+4;
    max_curent_list = length(curent_list);
    times = round(stoping_target / max_curent_list);
    target_list = repmat(curent_list,[times, 1]);
    names_list = repmat(folds_idx_names, [times,1]);
    if length(target_list)~=stoping_target
        selisih = stoping_target - length(target_list);
        if selisih>0
            tambahan = curent_list(1:selisih,1:2);
            tambahan_names = names_list(1:selisih,1:2);
            %target=cell(tambahan,2); names=cell(tambahan,2);
            %for i=1:length(tambahan)
                %target{i,1}=target_list{i,1}; target{i,2}=target_list{i,2};
                %names{i,1} = names_list{i,1}; names{i,2} =names_list{i,2};
                %names_list = vertcat(names_list, tambahan_names{i});
            %end
            target_list = vertcat(target_list, tambahan);
            names_list = vertcat(names_list, tambahan_names);
            names = names_list; clear names_list;
            target = target_list; clear target_list;
        else
            last = length(target_list); start = (last+selisih);
            target = cell(start,2); names = cell(start,2);
            for i=1:start
                target{i,1} = target_list{i,1};target{i,2} = target_list{i,2};
                names{i,1} = names_list{i,1};names{i,2} = names_list{i,2};
            end
            clear target_list; clear names_list;
        end
        disp(size(target)); disp(size(names));
    else
        target = target_list; clear target_list;
        names = names_list; clear names_list;
        disp(size(target)); disp(size(names));
    end
end
 %disp(curent_list);
%     target_list = cell(stoping_target,1);
%     iter_curent_list = 1;
%     index_target_list= 1;
    
%     while index_target_list<=stoping_target
%         target_list(index_target_list)=curent_list(iter_curent_list);
%         %disp(curent_list(iter_curent_list));
%         %disp(target_list(index_target_list));
%         if iter_curent_list ~=max_curent_list
%             iter_curent_list=iter_curent_list+1;
%         else
%             iter_curent_list=1;
%         end
%         index_target_list=index_target_list+1;
%     end