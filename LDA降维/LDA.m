function W = LDA(sample)
    %{
        1.�������������ǩ�����мල
        2.��ǩ����Ϊ��ֵ��1ά��������1��ʼ�����������Ԥ����
        3.��󷵻�ͶӰ��������
        4.dΪ�������������
        5.WΪͶӰ���������б���
        6.���Ľ�ά-ʹ��ԭ���ݼ���ȥlabel��*W
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
     end%����ɢ�Ⱦ���
     all_mul = sum(sample(:,1:end-1))/sample_row;
     SB = zeros(sample_col-1,sample_col-1);
     for j = 1:max_label
         SB = SB + label_num(j)*(mu_matrix(j,:)-all_mul)'*(mu_matrix(j,:)-all_mul);
     end
     [w,lambda] = eig(SW\SB);%����ֵ�ֽ�
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