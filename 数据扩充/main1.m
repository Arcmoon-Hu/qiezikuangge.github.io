%iris���ݵ��������kmean��knn
%{
step1����ԭ���ݼ��ֱ�ѵ��kmeans��knn
repeat��
    step2��ѵ��kmeans�󣬵õ��������ģ��������һ�������㣬���ݾ�������ȷ�����������������Ϊtarget_kmeans
    step3��ʹ��step2�����������knn�õ����target_knn
    step4���Ƚ�target_kmeans��target_knn����������¼�����������ǣ�����������
step5�������������ﵽҪ��������㷨
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
        data_dim = irisInputs(:,1:end-1);%��ȡ����
        data_dim_intargets = irisInputs(:,end);%��ȡ��ǩ
        max_intarget = max(data_dim_intargets);%��ȡ������
        [data_dim_row,data_dim_col] = size(data_dim);%ȡ�������Լ�������
        data_dim_minmax = minmax(data_dim');%��ȡ��������Χ
        data_dim_minmax = data_dim_minmax';
        data_dim_guiyi = (data_dim - ones(data_dim_row,1)*data_dim_minmax(1,:))./...
            (ones(data_dim_row,1)*(data_dim_minmax(2,:)-data_dim_minmax(1,:))); %��һ��
        %����ԭʼ���ݵ���������
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
        %ѵ���ٴ�kmeans,�õ�����Ч����õ�
        lei = lei(find(diff==min(diff)),:);
        kmeans_centre = [lei{1,2},ones(max_intarget,1)];
        for i =1:max_intarget
            %{
               �������Ѷ����ݵľ������ģ�Ҫ���Ѷ����ݰ�������򣩣���kmeans�����Աȣ�
            ����kmeans������������ԭʼ������������ľ��룬ȡ��С�ģ�ȷ��kmeans�����������������kmeans�������ڸ���������ĸ�����ǩ
            ������kmeans�۵�����У���ÿһ�����������������꣩
            %}
            middle_juli = juli(kmeans_centre(i,1:end-1),data_dim_centre(:,1:end-1),2);
            kmeans_centre(i,end) = data_dim_centre(find(middle_juli == min(middle_juli)),end);
        end
        %kmeansѵ�����
        %����ѵ��������Լ���ʼѵ��knn
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
        end%�����������㣬��������λ�ھ������������ڣ�������kmeans�ľ������ľ���ȷ����ǩ
       function admmit = text(zhongzi,zhongzi_target,zhiyu,data,data_target)
           zhongzi_1 = (zhongzi-zhiyu(1,:))./(zhiyu(2,:)-zhiyu(1,:));
            index = randperm(size(data,1));
            X_train = data(index(1:length(index)*0.8),:);
            %X_text  = data_dim_guiyi(index(121:150),:);
            y_train = data_target(index(1:length(index)*0.8),:);
            %y_text = data_target(index(121:150),:);
            answer = knn(X_train,y_train,zhongzi_1,6);
            admmit = (answer == zhongzi_target);
       end%��knn����֤���������Ƿ����
        xinzeng = 1;
        data_new = zeros(20,5);
        kk = 0;
        while xinzeng<21%һ�β���20��
            [zhongzi,zhongzi_target] = product(data_dim_minmax,kmeans_centre); 
            admmit = text(zhongzi,zhongzi_target,data_dim_minmax,data_dim_guiyi,data_dim_intargets);
            if admmit==1
                data_new(xinzeng,:) = [zhongzi,zhongzi_target];
                xinzeng = xinzeng+1;
            end
            kk = kk+1;%�ලѭ������
        end
        total_data = [[data_dim,data_dim_intargets];data_new];
        total_data = sortrows(total_data,data_dim_col+1);
        xlswrite('data_new.xlsx',total_data);
    end

