%iris数据的扩充基于kmean与knn
%{
step1：依原数据集分别训练kmeans与knn
repeat：
    step2：训练kmeans后，得到聚类中心，随机生成一组样本点，根据聚类中心确定种类归属，不妨记为target_kmeans
    step3：使用step2的样本点代入knn得到结果target_knn
    step4：比较target_kmeans与target_knn，若相等则记录该样本及其标记，否则抛弃。
step5：若样本数量达到要求，则结束算法
%}
function main1
    all_time = 0;
    while all_time<4
        main
        all_time = all_time+1;
    end
end
    function  main
    %     load iris_dataset.mat;
        irisInputs = xlsread('data_new.xlsx');
        data_dim = irisInputs(:,1:end-1);%读取特征
        data_dim_intargets = irisInputs(:,end);%读取标签
        max_intarget = max(data_dim_intargets);%获取最大类别
        [data_dim_row,data_dim_col] = size(data_dim);%取特征数以及样本数
        data_dim_minmax = minmax(data_dim');%获取各特征范围
        data_dim_minmax = data_dim_minmax';
        data_dim_guiyi = (data_dim - ones(data_dim_row,1)*data_dim_minmax(1,:))./...
            (ones(data_dim_row,1)*(data_dim_minmax(2,:)-data_dim_minmax(1,:))); %归一化
        %生成原始数据的中心坐标
        data_dim_centre = zeros(max_intarget,data_dim_col);
        for centre_i = 1:max_intarget
            index_target = find(data_dim_intargets==centre_i);
            data_dim_centre(centre_i,:) = sum(data_dim_guiyi(index_target,:))/length(index_target);
        end
        data_dim_centre = [data_dim_centre,[1:max_intarget]'];
        time = 1;
        lei = cell(100,2);
        diff = zeros(100,1);
        while time <101
            [~,lei{time,2},lei{time,1}] = kmeans(data_dim_guiyi,3);
            p1 = zeros(1,max_intarget);
            for p1_i = 1:max_intarget
                p1(p1_i) = sum(lei{time,1} == p1_i);
            end
            if  p1==[0,0,0]
                diff(time) = 10000;
            else
            diff(time) = max(p1) - min(p1);
            end
            time = time+1;
        end
        %训练百次kmeans,得到分类效果最好的
        lei = lei(find(diff==min(diff)),:);
        kmeans_centre = [lei{1,2},ones(max_intarget,1)];
        for i =1:max_intarget
            %{
               先生成已读数据的聚类中心（要求已读数据按类别排序），跟kmeans的做对比，
            计算kmeans的中心坐标与原始数据中心坐标的距离，取最小的，确定kmeans中心坐标的类名，在kmeans中隶属于该中心坐标的更换标签
            ，（在kmeans聚的类别中，在每一类后添加所属中心坐标）
            %}
            middle_juli = juli(kmeans_centre(i,1:end-1),data_dim_centre(:,1:end-1),2);
            kmeans_centre(i,end) = data_dim_centre(find(middle_juli == min(middle_juli)),end);
        end
        %kmeans训练完成
        %生成训练集与测试集开始训练knn
        function [zuobiao_dim,zuobiao_target] = product(zhiyu,zhongxinzuobiao)
            num_tezheng = size(zhiyu,2);
            zuobiao_dim = zeros(1,num_tezheng);
            for i_1 =1:num_tezheng
                zhiyu_middle = zhiyu(:,i_1);
                zuobiao_dim(i_1) = zhiyu_middle(1)+round((zhiyu_middle(2)-zhiyu_middle(1))*rand(1),1);
            end
            zuobiao_dim_1 = (zuobiao_dim-zhiyu(1,:))./(zhiyu(2,:)-zhiyu(1,:));
            distance = juli(zuobiao_dim_1,zhongxinzuobiao(:,1:end-1),2);
            zuobiao_target = zhongxinzuobiao(find(distance==min(distance)),end);
        end%产生新样本点，新样本点位于旧样本点区间内，并根据kmeans的聚类中心距离确定标签
       function admmit = text(zhongzi,zhongzi_target,zhiyu,data,data_target)
           zhongzi_1 = (zhongzi-zhiyu(1,:))./(zhiyu(2,:)-zhiyu(1,:));
            index = randperm(size(data,1));
            X_train = data(index(1:length(index)*0.8),:);
            %X_text  = data_dim_guiyi(index(121:150),:);
            y_train = data_target(index(1:length(index)*0.8),:);
            %y_text = data_target(index(121:150),:);
            answer = knn(X_train,y_train,zhongzi_1,6);
            admmit = (answer == zhongzi_target);
       end%在knn里验证新样本点是否可信
        xinzeng = 1;
        data_new = zeros(20,5);
        kk = 0;
        while xinzeng<21%一次产生20个
            [zhongzi,zhongzi_target] = product(data_dim_minmax,kmeans_centre); 
            admmit = text(zhongzi,zhongzi_target,data_dim_minmax,data_dim_guiyi,data_dim_intargets);
            if admmit==1
                data_new(xinzeng,:) = [zhongzi,zhongzi_target];
                xinzeng = xinzeng+1;
            end
            kk = kk+1;%监督循环次数
        end
        total_data = [[data_dim,data_dim_intargets];data_new];
        total_data = sortrows(total_data,data_dim_col+1);
        xlswrite('data_new.xlsx',total_data);
    end

