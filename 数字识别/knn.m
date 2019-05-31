function [answer,vote_matrix_1] = knn(A,B,wait_predict,k)
%识别B中的类别
%A为样本矩阵，B为标记，k为
% n=length(B);
% len_band = 0;
% p=1;
% while len_band<n
%     len_band=sum(B==p)+len_band;
%     p=p+1;
% end
%识别出训练样本有多少类
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
    C1 = [C,all_distance'];%把距离列并入到原始数据集中
    [~,col] = size(C1);
    sort_C = sortrows(C1,col);%按待测样本与训练样本的距离排序（从小到大）
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
            disp('已完成100%')
        else
            disp(['已完成',num2str(jindu),'%'])
        end
    end
end
