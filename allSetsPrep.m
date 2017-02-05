function allSets = allSetsPrep(matPath)
    if exist(strcat(matPath,strcat('\','[allSets].mat')))
        allSets = load(strcat(matPath,strcat('\','[allSets].mat')));
        allSets = allSets.allSets;
    else
        pairsList = 'pairs4folds.txt';
        fileId = fopen(pairsList,'r');
        line = fgetl(fileId);
        allSets = {};
        while ischar(line)
            val = strsplit(line,'\t');
            if length(val)==2
                disp('skip header');
            elseif length(val)==3
                name = char(val{1}); numb_1 = char(val{2}); numb_2 = char(val{3});
                len_numb_1 = 4-length(numb_1);len_numb_2 = 4-length(numb_2);
                numb_1 = zeroPad(numb_1, len_numb_1);numb_1=strcat('_',numb_1); 
                numb_2 = zeroPad(numb_2, len_numb_2);numb_2=strcat('_',numb_2);

                name_a = strcat(name,strcat(numb_1,'.jpg'));
                name_b = strcat(name,strcat(numb_2,'.jpg'));
                set = {name_a,name_b}; allSets=vertcat(allSets, set);
            elseif length(val)==4
                name_1 = char(val{1});numb_1 = char(val{2});
                name_2 = char(val{3});numb_2 = char(val{4});
                len_numb_1 = 4-length(numb_1);len_numb_2 = 4-length(numb_2);
                numb_1 = zeroPad(numb_1, len_numb_1);numb_1=strcat('_',numb_1); 
                numb_2 = zeroPad(numb_2, len_numb_2);numb_2=strcat('_',numb_2);

                name_a = strcat(name_1,strcat(numb_1,'.jpg'));
                name_b = strcat(name_2,strcat(numb_2,'.jpg'));
                set = {name_a,name_b}; allSets=vertcat(allSets, set);
            end
          %update ke line berikutnya
          line=fgetl(fileId);
        end
        save(strcat(matPath,strcat('\','[allSets].mat')),'allSets','-v7.3');
    end
end