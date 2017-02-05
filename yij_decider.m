function keputusan = yij_decider(name_a, name_b)
    %name_a = tetha_i_name; name_b = tetha_i_name;
    name_a = strsplit(name_a, '.'); name_b = strsplit(name_b, '.');
    name_a = name_a{1}; name_b = name_b{1};
    name_a = strsplit(name_a, '_'); name_b = strsplit(name_b, '_');
    last_a = length(name_a); pick_a = last_a-1;
    last_b = length(name_b); pick_b = last_b-1;
    name_a = {name_a{1:pick_a}}; name_b = {name_b{1:pick_b}};
    temp_a = ''; 
    for i=1:length(name_a)
        temp_a = strcat(temp_a, name_a{i});
    end
    temp_b = '';
    for i=1:length(name_b)
        temp_b = strcat(temp_b, name_b{i});
    end
    
    if strcmp(temp_a, temp_b)==1
        keputusan = 1;
    else
        keputusan = -1;
    end
end