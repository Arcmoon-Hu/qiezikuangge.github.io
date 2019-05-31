function shiyan
    function [zuobiao_dim,zuobiao_target] = product(zhiyu,zhongxinzuobiao)
            num_tezheng = size(zhiyu,2);
            zuobiao_dim = zeros(1,num_tezheng);
            for i_1 =1:num_tezheng
                zhiyu_middle = zhiyu(i_1,1);
                zuobiao_dim(i_1) = zhiyu_middle(1)+(zhiyu_middle(2)-zhi_middle(1))*rand(1);
            end
            distance = juli(zuobiao_dim,zhongxinzuobiao,2);
            zuobiao_target = find(distance==min(distance));
        end   
       function admmit = text(zhongzi,zhongzi_target,data,data_target) 
            index = randperm(size(data,1));
            X_train = data(index(1:length(index)*0.8),:);
            %X_text  = data_dim_guiyi(index(121:150),:);
            y_train = data_target(index(1:length(index)*0.8),:);
            %y_text = data_target(index(121:150),:);
            answer = knn(X_train,y_train,zhongzi,6);
            admmit = (answer == zhongzi_target);
        end
        [zhongzi,zhongzi_target] = product(data_dim_minmax,lei{2}); 
        admmit = text(zhongzi,zhongzi_target,data_dim_guiyi,data_target);
end