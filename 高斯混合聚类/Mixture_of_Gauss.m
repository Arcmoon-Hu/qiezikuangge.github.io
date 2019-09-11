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