function answer = knn(A,B,wait_predict,k)
%ʶ��B�е����
%AΪ��������BΪ��ǣ�kΪ
p=max(B);
% while len_band<n
%     len_band=sum(B==p)+len_band;
%     p=p+1;
% end
% %ʶ���ѵ�������ж�����
% p=p-1;    
C=[A,B];
[A_m,~] = size(A);
all_distance=zeros(1,A_m);
[wait_predict_r,~] = size(wait_predict);
answer = zeros(wait_predict_r,1);
for j = 1:wait_predict_r
    for i = 1:A_m
        all_distance(i) = juli(A(i,:),wait_predict(j,:),2);
    end
    C1 = [C,all_distance'];%�Ѿ����в��뵽ԭʼ���ݼ���
    [~,col] = size(C1);
    sort_C = sortrows(C1,col);%������������ѵ�������ľ������򣨴�С����
    vote_matrix = sort_C(1:k,col-1);
    vote_array = zeros(1,p);
    for i = 1:p
        vote_array(i) = sum(vote_matrix==i);
    end
    index = find(vote_array==max(vote_array));
    answer(j) = index(randi(length(index),1));
end
