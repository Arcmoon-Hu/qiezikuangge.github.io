%shiyan
canshu_matrix=cell(150,4);
for i=1:150
w_layer = rand(col_data_input,nodes(1));
canshu_matrix{i,1} = w_layer;
%������������ָ������Լ�����ڵ�������ʼ������㵽�����Ȩ�ؾ���
a_layer = rand(1,nodes(1));
canshu_matrix{i,2} = a_layer;
%��������ڵ�������ʼ��������ֵ
w_output = rand(nodes(1),nodes(2));
canshu_matrix{i,3} = w_output; 
%��������ڵ�������ڵ��ʼ�����㵽������Ȩ�ؾ���
a_output = rand(1,col_data_output);
canshu_matrix{i,4} = a_output;
end
for  i = 1:row_data_input
           %��i������col��
           w_layer = canshu_matrix{i,1};
           a_layer = canshu_matrix{i,2};
           w_output = canshu_matrix{i,3};
           a_output = canshu_matrix{i,4};
           layer_input = data_input(i,:)*w_layer+a_layer;%һ�У�node��1����
           layer_output = f1(layer_input);%һ��,node(1)��
           yuce_input = layer_output*w_output+a_output;%һ�У�node��2����
           yuce_output = f2(yuce_input);%Ԥ����
           eol_array(i) = 0;
           shiji_output = data_output(i,:);
           for j = 1:nodes(2)
               eol_array(i) = eol_array(i)+(yuce_output(j)-shiji_output(j))^2;
           end
           %����ÿһ�����������
           eol_array(i)=0.5*eol_array(i);
           %BP�㷨��ʼ����
           %������w_output
           g=-(yuce_output-shiji_output).*f2_Diff(yuce_input);
           for h=1:nodes(1)
               w_output(h,:)=w_output(h,:)+yita*g*layer_output(h);
           end
           %����a_output
           a_output = a_output-yita*g;
           %����w_input
           for h=1:nodes
               eh(h)=f1_Diff(layer_input(h))*w_output(h,:)*g';
           end
           for k=1:col_data_input
               w_layer(k,:)=yita*eh*data_input(i,k);
           end
           %����a_layer
           a_layer = -yita*eh;
           canshu_matrix{i,1} = w_layer;
           canshu_matrix{i,2} = a_layer;
           canshu_matrix{i,3} = w_output;
           canshu_matrix{i,4} = a_output;
end