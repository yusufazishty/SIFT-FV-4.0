function TEST_FOLDS = reshape_cell(TEST_FOLDS, target_size)
    [a,b] = size(TEST_FOLDS); c=target_size(1); d=target_size(2);
    target = cell(c,d);
    if a*b==c*d
        k=1;
        while k<=a
            disp(k);
            for i=1:c
                for j=1:d
                    target{i,j}=TEST_FOLDS{k};
                    k=k+1;
                end
            end
        end      
    else
        disp('size not same!');
    end
    TEST_FOLDS = target; clear target;
end