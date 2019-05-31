function [jieguo,zhongxin_zuobiao,lei] = kmeans(a,k)
%a was a dataset that you want to cluster and k was a number that you want to cluster

%u=a;
[a_row,a_col] = size(a);
zhongxin = randi(a_row,k,1);% zhongxin was the central of your clusters 
zhongxin_zuobiao = a(zhongxin,:);
lei = zeros(a_row,1);
zhongxin_bijiao = zeros(k,a_col);
t = 0;
while zhongxin_bijiao~=zhongxin_zuobiao%zhongxin_bijiao是上次的坐标，zhongxin_zuobiao是此次最新更新的坐标
    zhongxin_bijiao = zhongxin_zuobiao;
for i = 1:a_row
    distance_middle = zeros(1,k);
    for j = 1:k
        distance_middle(j) = juli(a(i,:),zhongxin_zuobiao(j,:),4);
    end
    biaoji = find(distance_middle==min(distance_middle));
    lei(i) = biaoji(randi(length(biaoji),1));
end
for j = 1:k
    weizhi = find(lei==j);
    zhongxin_zuobiao(j,:) = sum(a(weizhi,:))/length(weizhi);%更新中心坐标
end
t = t+1;
end
%disp(t)%迭代次数
jieguo = [a,lei];
%此函数的输出结果为分类结果以及每一个类别中，对应原始数据集的行标
end