data = xlsread('data_new.xlsx');
data_dim = data(:,1:4);
data_target = data(:,5);
for i = 1:size(data_dim,2)
    data_dim(:,i) = (data_dim(:,i)-min(data_dim(:,i)))/(max(data_dim(:,i))-min(data_dim(:,i)));
end
for i=1:10
    l = randperm(size(data_dim,1));
    X_train = data_dim(l(1:length(l)*0.8),:);
    X_test = data_dim(l(length(l)*0.8+1:length(l)),:);
    y_train = data_target(l(1:length(l)*0.8));
    y_test = data_target(l(length(l)*0.8+1:length(l)));
    answer = knn(X_train,y_train,X_test,6);
    ans1 = answer-y_test;
    ans1(ans1~=0) = 1;
    zhunquelv(i) = 1-sum(ans1)/length(ans1);
end
plot(1:i,zhunquelv)