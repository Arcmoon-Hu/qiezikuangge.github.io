%{
%��˹��Ͼ���
1: ��˹�ֲ������ܶȺ���
    p(x)=1/(2pi)^(m/2)/det(sigma)*exp(-0.5*(x-miu)'*inv(sigma)*(x-miu))
2:�㷨����
   step1:��������ѡ��Ԥ������k���������k������[1]�ĸ�˹�ֲ���miu��sigma��ά��
         ��������������ȷ�����Լ�a_i
   step2:������������n�Լ�������k�������gama[]
          for j = 1:n
              for i = 1:k
                  gama(j,i) = a_i*p(xj|miu_i,sigma_i)/sum(a_i*p(x_j|miu_i,sigma_i))
              end
          end
   step3:���³�ʼ������������miu_i,sigma_i.a_i
         for i = 1:k
             miu_i = sum(gama(:,i)*x_j)/sum(gama(:,i))
             sigma_i = sum(gama(:,i)*x_j*(x_j-miu_i))/sum(gama(:,i))
             a_i = sum(gama(:,i))/n
         end
   step4:��������ֹ������ִ����һ�������򷵻�step2
   step5:for j = 1:n
             label��x_j��=find(gama(j,:)==max(gama(j,:)))
         end
   ���
%}