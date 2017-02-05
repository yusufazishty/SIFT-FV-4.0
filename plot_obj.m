function plot_obj(objectivefunc_history, M_iter)
    objectivefunc_history = cell2mat(objectivefunc_history);
    n = length(objectivefunc_history);
    x = [1:n];
    y = zeros(n,1);
    for i=1:n
        summation = sum(objectivefunc_history(1:i));
        y(i) = summation/n;
    end
    figure(M_iter);
    hold on;
    %plot(x,y,[0,0.7,0.9]);
    plot(x,y);
    title('Objective Function Plot');
    xlabel('iteration');
    ylabel('Objective Function Value');
    if M_iter==1
        drawnow;
    else
        delete(figure(M_iter-1));
        drawnow
    end
end