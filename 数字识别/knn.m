function [answer,vote_matrix_1] = knn(A,B,wait_predict,k)
%ʶ��B�е����
%AΪ��������BΪ��ǣ�kΪ
% n=length(B);
% len_band = 0;
% p=1;
% while len_band<n
%     len_band=sum(B==p)+len_band;
%     p=p+1;
% end
%ʶ���ѵ�������ж�����
vote_matrix_1 = cell(1000,2);
p = max(B); 
C=[A,B];
[A_m,~] = size(A);
[wait_predict_r,~] = size(wait_predict);
answer = zeros(wait_predict_r,1);
jindu = 0;
for j = 1:wait_predict_r
    all_distance=zeros(1,A_m);
    for i = 1:A_m
        all_distance(i) = juli(A(i,:),wait_predict(j,:),2);
    end
    vote_matrix_1{j,2} = all_distance;
    C1 = [C,all_distance'];%�Ѿ����в��뵽ԭʼ���ݼ���
    [~,col] = size(C1);
    sort_C = sortrows(C1,col);%������������ѵ�������ľ������򣨴�С����
    vote_matrix = sort_C(1:k,col-1);
    vote_array = zeros(1,p);
    for i = 1:p
        vote_array(i) = sum(vote_matrix==i);
    end
    vote_index = find(vote_array==max(vote_array));
    vote_matrix_1{j,1} = vote_matrix;
    if length(vote_index) >1
        answer(j) = vote_index(1);
    else
        answer(j) = vote_index;
    end
    if rem(j,wait_predict_r/100)==0
        jindu = jindu+1;
        if j == wait_predict_r
            disp('�����100%')
        else
            disp(['�����',num2str(jindu),'%'])
        end
    end
end
