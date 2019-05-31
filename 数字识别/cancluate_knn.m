%基于knn学习
data = xlsread('digit.xlsx');
[data_r,data_c] = size(data);
data_matrix = tezhengshaixuan(data,100);
y = data(:,data_c);
u_rand = randperm(5000);
u_1 = u_rand(1:4000);
u_2 = u_rand(4001:5000);
X_train = data_matrix(u_1,:);
X_text = data_matrix(u_2,:);
y_train = y(u_1);
y_text = y(u_2);%划分训练集与测试集
zhunquelv_array = zeros(1,10);
for vote_number = 10:10:100
    [answer,vote_matrix] = knn(X_train,y_train,X_text,vote_number);
    confusion = answer - y_text;
    confusion(confusion~=0) = 1;
    zhunquelv = 1-sum(confusion)/length(confusion);
    zhunquelv_array(vote_number) = zhunquelv;
end
disp(zhunquelv_array)
plot([10:10:100],zhunquelv_array);