function W = LDA(sample,d)
    %{
        1.�������������ǩ�����мල
        2.��ǩ����Ϊ��ֵ��1ά��������1��ʼ�����������Ԥ����
        3.��󷵻�ͶӰ��������
        4.dΪ�������������
        5.WΪͶӰ���������б���
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