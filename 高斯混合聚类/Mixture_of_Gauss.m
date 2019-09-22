%{
%高斯混合聚类
1: 高斯分布概率密度函数
    p(x)=1/(2pi)^(m/2)/det(sigma)*exp(-0.5*(x-miu)'*inv(sigma)*(x-miu))
2:算法步骤
   step1:根据样本选定预分类数k，随机生成k个形如[1]的高斯分布，miu和sigma的维度
         根据样本特征数确定，以及a_i
   step2:根据样本个数n以及特征数k定义矩阵gama[]
          for j = 1:n
              for i = 1:k
                  gama(j,i) = a_i*p(xj|miu_i,sigma_i)/sum(a_i*p(x_j|miu_i,sigma_i))
              end
          end
   step3:更新初始化的三个参数miu_i,sigma_i.a_i
         for i = 1:k
             miu_i = sum(gama(:,i)*x_j)/sum(gama(:,i))
             sigma_i = sum(gama(:,i)*x_j*(x_j-miu_i))/sum(gama(:,i))
             a_i = sum(gama(:,i))/n
         end
   step4:若满足终止条件，执行下一步，否则返回step2
   step5:for j = 1:n
             label（x_j）=find(gama(j,:)==max(gama(j,:)))
         end
   完成
%}
%step1   初始化各种参数
%请先归一化
function [data_new,LLD] = Mixture_of_Gauss(data,k)
[data_row,data_col] = size(data);
%k = input('聚类个数');
Sigma = cell(1,k);
mu = cell(1,k);
alpha = zeros(1,k);
rand_index = randperm(data_row);
for i = 1:k
    Sigma{1,i} = eye(data_col);
    alpha(i) = 1/k;
    mu{1,i} = data(rand_index(i),:);
end
    function p_x = p(x,mu,Sigma)
        p_x = 1/((2*pi)^(data_col/2))/det(Sigma)^(0.5)*exp(-0.5*(x-mu)/Sigma*(x-mu)');
    end
%label = zeros(data_row,1);
iter = 0;
eol = 1;
LLDold = 0;
LLD = 0;
while iter<1000&&eol>10e-3
    LLDold = LLD;
    LLD_array = zeros(1,data_row);
    label = zeros(data_row,1);
    gama = zeros(data_row,k);
    for j = 1:data_row
        gama_sum_i = 0;
        for i = 1:k
            gama(j,i) = alpha(i)*p(data(j,:),mu{1,i},Sigma{1,i});
            gama_sum_i = gama_sum_i+gama(j,i);%alpha(i)*p(data(j,:),mu{1,k},Sigma{1,k});
        end
        gama(j,:) = gama(j,:)/gama_sum_i;
        j1 = find(gama(j,:)==max(gama(j,:)));
        if length(j1)>1
            label(j) = j1(1);
        elseif length(j1) == 1
            label(j) = j1;
        end
        LLD_array(j) = gama_sum_i;
    end
    for m = 1:k
        gama_x = zeros(1,data_col);
        for n = 1:data_row
            gama_x = gama_x+gama(n,m)*data(n,:);
        end
        mu{1,m} = gama_x/(sum(gama(:,m)));
        middle_sigma = zeros(data_col,data_col);
        for n = 1:data_row
            middle_sigma = middle_sigma+gama(n,m)*((data(n,:)-mu{1,m})'*(data(n,:)-mu{1,m}));
        end
        Sigma{1,m} = middle_sigma/(sum(gama(:,m)));
        alpha(1,m) = sum(gama(:,m))/data_row;
    end
    LLD = sum(log(LLD_array));
    eol = abs(LLD-LLDold);
    iter = iter+1;
end
data_new = [data,label];
end
