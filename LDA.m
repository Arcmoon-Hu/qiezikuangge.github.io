function W = LDA(sample,d)
    %{
        1.输入的样本带标签，即有监督
        2.标签向量为数值（1维且连续从1开始），否则进行预处理
        3.最后返回投影向量矩阵
        4.d为欲保存的特征数
        5.W为投影向量矩阵，列保存
     %}
     [sample_row,sample_col] = size(sample);
     max_label = max(sample(:,end));
     mu_matrix = zeros(max_label,sample_col);
     SW = zeros(sample_col,sample_col);
     for i = 1:max_label
        middle_matrix = sample(find(sample(:,end)==i),end-1);
        mu_matrix(i,:) = sum(middle_matrix)/length(sample(:,end==i));
        middle_matrix_row = size(middle_matrix);
        middle_SW = zeros(sample_col,sample_col);
        for j = 1:middle_matrix_row
            middle_SW = middle_SW + (middle_matrix(j,:)-mu_matrix(i,:))'*(middle_matrix(j,:)-mu_matrix(i,:));
        end
        SW = SW + middle_SW;
     end
     all_mul = sum(sample(:,end-1))/sample_row;
     ST = zeros(sample_col,sample_col);
     for i = 1:sample_row
        ST = ST + (sample(i,end-1)-all_mul)'*(sample(i,end-1)-all_mul);
     end
     SB = ST-SW;
     [w,lambda] = eig(inv(SW)*SB);
     lambda = sum(lambda);
     [index,lambda] = newsort(lambda);
     w = w(:,index);
     w = w(:,1:d);
     W = w;   
end