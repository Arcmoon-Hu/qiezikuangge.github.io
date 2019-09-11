%{
任给a1,a2,进行求解
a1y1 + a2y2 = c
a2_new_unc = a2_old + y2(E1-E2)/(k11+k22-2k12)
    E1 = |f(x1)-y1|、E2 = |f(x2)-y2|
    k11 = x1'x1,k22 = x2'x2,k12 = x1'x2
if y1 ~= y2
    L = max(0,a2-a1)
    H = min(C,C+a2_old-a1_old)
    a2_new = H,if a2_new_unc>H || a2_new_unc if L<a2_new_unc<H 
            || L,if L<a2_new_unc    
    a1_new = a1_old + y1y2(a2_old - a2_new)
%}
function answer = SVM_theory(data_x_train,data_y_train,data_x_test,data_y_test,new_data)
[size_m,~] = size(data_x_train);
C = 0.6;
toler = 0.0001;
maxIter = 100;
b = 0;
alpha = zeros(size_m,1);
iter = 0;
%使用高斯核函数的支持向量机实现
while iter<maxIter
    for i = 1:size_m
        fxi = Gausskernel(data_x_train,data_x_train(i,:))*(alpha.*data_y_train)+b;
        ei = fxi - data_y_train(i);
        alphaPairsChanged = 0 ;
        if (data_y_train(i)*ei<-toler && alpha(i)<C)|| (data_y_train(i)*ei>toler && alpha(i)>0)
             j = select_j(data_x_train,data_y_train,alpha,b,i);
             fxj = Gausskernel(data_x_train,data_x_train(j,:))*(alpha.*data_y_train)+b;
             alpha1old = alpha(i);
             alpha2old = alpha(j);
             ej = fxj-data_y_train(j);
             if data_y_train(i)~=data_y_train(j)
                L = max(0,alpha(j)-alpha(i));
                H = min(C,C+alpha(j)-alpha(i));
             else
                L = max(0,alpha(j)+alpha(i)-C);
                H = min(C,alpha(j)+alpha(i));
             end
             if L==H
                continue
             end
             eta =  Gausskernel(data_x_train(i,:),data_x_train(i,:))+ Gausskernel(data_x_train(j,:),data_x_train(j,:))...
                 -2* Gausskernel(data_x_train(i,:),data_x_train(j,:));
             alpha(j) = alpha(j)+data_y_train(j)*(ei-ej)/eta;
             alpha(j) = clipalpha(alpha(j),H,L);
             if abs(alpha(j)-alpha2old)<toler
                 continue
             end
             alpha(i) = alpha(i)+data_y_train(i)*data_y_train(j)*(alpha2old-alpha(j));
%{    
  注释部分为周志华教授《机器学习》上b的计算方法，目前代码采用《统计学习方法》的公式
data_vector = data_x_train(alpha~=0,:);
%              data_vector_label = data_y_train(alpha~=0);
%              [num_data_vector,~] = size(data_vector);
%              t = 0;
%              for s = 1:num_data_vector
%                  t =t+ 1/data_vector_label(s)-((data_vector*data_vector(s,:)')'*(alpha(alpha~=0).*data_vector_label)+b);
%              end
%              b = t/num_data_vector;
%}
             b1 = b-ei-data_y_train(i)* Gausskernel(data_x_train(i,:),data_x_train(i,:))*(alpha(i)-alpha1old)...
                 -data_y_train(j)* Gausskernel(data_x_train(i,:),data_x_train(j,:))*(alpha(j)-alpha2old);
             b2 = b-ej-data_y_train(i)*Gausskernel(data_x_train(i,:),data_x_train(j,:))*(alpha(i)-alpha1old)...
                 -data_y_train(j)*Gausskernel(data_x_train(j,:),data_x_train(j,:))*(alpha(j)-alpha2old);
             if alpha(i)<C&&data_y_train(i)>0
                 b = b1;
             elseif alpha(j)<C&&data_y_train(j)>0
                 b = b2;
             else
                 b = (b1+b2)/2;
             end
             alphaPairsChanged = alphaPairsChanged+1;
        end
    end
    if alphaPairsChanged == 0
        iter = iter+1;
    else
        iter = 0;
    end
    if rem(iter,maxIter/100) == 0
        disp([num2str(iter/(maxIter/100)),'%已完成'])
    end
end
disp('训练完成')
yuce =  [];
for i = 1:length(data_x_test)
    yuce = [yuce;Gausskernel(data_x_train,data_x_test(i,:))*(alpha.*data_y_train)+b];
end
yuce(yuce>0) = 1;
yuce(yuce<0) = -1;

answer{1,1} = sum(yuce==data_y_test)/length(data_y_test);
if Gausskernel(data_x_train,new_data)*(alpha.*data_y_train)+b>0
    answer{1,2} = 1;
elseif Gausskernel(data_x_train,new_data)*(alpha.*data_y_train)+b<0
    answer{1,2}= -1;
end
%     zhunquelv =[zhunquelv,sum((yuce-data_y_test)==0)/length(yuce)];
%     jindu = jindu+1;
%     disp([num2str(jindu/21*100),'%已完成']
% plot([4:0.05:5],zhunquelv,'r-')
end