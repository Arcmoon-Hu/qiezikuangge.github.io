data = xlsread('digit.xlsx');
[data_r,data_c] = size(data);
data_matrix = tezhengshaixuan(data,140);
u = randperm(data_r);
X = data_matrix(u,:);
y = data(u,data_c);%´òÂÒÊı¾İ
y_max = max(y);
y_new = zeros(length(y),y_max);
for i = 1:length(y)
    for j=1:y_max
        if y(i)==j
            y_new(i,j)=1;
        end
    end
end
u_rand = randperm(5000);
u_1 = u_rand(1:4000);
u_2 = u_rand(4001:5000);
X_train = X(u_1,:);
X_text = X(u_2,:);
y_train = y_new(u_1,:);
y_text = y_new(u_2,:);
net = newff(minmax(X_train'),[20,20,10],{'poslin','tansig','tansig'},'trainlm');
net.trainParam.epochs = 10000;
net.trainParam.lr = 0.05;
net.trainParam.goal = 0.001;
net = train(net,X_train',y_train');
y_sim = sim(net,X_text');
n = size(y_sim,1);
 for  j =1:n
      l(j) = find(y_sim(j,:)==max(y_sim(j,:)));
 end
 confusion = [l',y(u_2)];
 zhunquelv = sum(l'==y(u_1))/length(l);