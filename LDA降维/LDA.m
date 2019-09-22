function W = LDA(sample)
    %{
        1.输入的样本带标签，即有监督
        2.标签向量为数值（1维且连续从1开始），否则进行预处理
        3.最后返回投影向量矩阵
        4.d为欲保存的特征数
        5.W为投影向量矩阵，列保存
        6.最后的降维-使用原数据集（去label）*W
     %}
     sample = normalization(sample);
     [sample_row,sample_col] = size(sample);
     max_label = max(sample(:,end));
     mu_matrix = zeros(max_label,sample_col-1);
     SW = zeros(sample_col-1,sample_col-1);
     label_num = zeros(1,max_label);
     for i = 1:max_label
        middle_matrix = sample(find(sample(:,end)==i),1:end-1);
        mu_matrix(i,:) = sum(middle_matrix)/length(sample(:,end)==i);
        label_num(i) = length(find(sample(:,end)==i));
        [middle_matrix_row,~] = size(middle_matrix);
        middle_SW = zeros(sample_col-1,sample_col-1);
        for j = 1:middle_matrix_row
            middle_SW = middle_SW + (middle_matrix(j,:)-mu_matrix(i,:))'*(middle_matrix(j,:)-mu_matrix(i,:));
        end
        SW = SW + middle_SW;
     end%类内散度矩阵
     all_mul = sum(sample(:,1:end-1))/sample_row;
     SB = zeros(sample_col-1,sample_col-1);
     for j = 1:max_label
         SB = SB + label_num(j)*(mu_matrix(j,:)-all_mul)'*(mu_matrix(j,:)-all_mul);
     end
     [w,lambda] = eig(SW\SB);%特征值分解
     lambda = sum(lambda);
     [lambda,index] = sort(lambda,'descend');
     disp(lambda)
     contribution_prop = compute(lambda);
     plot(1:length(lambda),contribution_prop,'r-')
     %d = input('Please input the number of fetures that you want to save');
     w = w(:,index);
     W = w;   
end
function array = compute(lambda)
    array = lambda/(sum(lambda));
end