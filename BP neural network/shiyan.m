%shiyan
canshu_matrix=cell(150,4);
for i=1:150
w_layer = rand(col_data_input,nodes(1));
canshu_matrix{i,1} = w_layer;
%根据输入样本指标个数以及隐层节点数，初始化输入层到隐层的权重矩阵
a_layer = rand(1,nodes(1));
canshu_matrix{i,2} = a_layer;
%根据隐层节点数，初始化隐层阈值
w_output = rand(nodes(1),nodes(2));
canshu_matrix{i,3} = w_output; 
%根据隐层节点和输出层节点初始化隐层到输出层的权重矩阵
a_output = rand(1,col_data_output);
canshu_matrix{i,4} = a_output;
end
for  i = 1:row_data_input
           %第i个样本col列
           w_layer = canshu_matrix{i,1};
           a_layer = canshu_matrix{i,2};
           w_output = canshu_matrix{i,3};
           a_output = canshu_matrix{i,4};
           layer_input = data_input(i,:)*w_layer+a_layer;%一行，node（1）列
           layer_output = f1(layer_input);%一行,node(1)列
           yuce_input = layer_output*w_output+a_output;%一行，node（2）列
           yuce_output = f2(yuce_input);%预测结果
           eol_array(i) = 0;
           shiji_output = data_output(i,:);
           for j = 1:nodes(2)
               eol_array(i) = eol_array(i)+(yuce_output(j)-shiji_output(j))^2;
           end
           %计算每一个样本的误差
           eol_array(i)=0.5*eol_array(i);
           %BP算法开始修正
           %先修正w_output
           g=-(yuce_output-shiji_output).*f2_Diff(yuce_input);
           for h=1:nodes(1)
               w_output(h,:)=w_output(h,:)+yita*g*layer_output(h);
           end
           %修正a_output
           a_output = a_output-yita*g;
           %修正w_input
           for h=1:nodes
               eh(h)=f1_Diff(layer_input(h))*w_output(h,:)*g';
           end
           for k=1:col_data_input
               w_layer(k,:)=yita*eh*data_input(i,k);
           end
           %修正a_layer
           a_layer = -yita*eh;
           canshu_matrix{i,1} = w_layer;
           canshu_matrix{i,2} = a_layer;
           canshu_matrix{i,3} = w_output;
           canshu_matrix{i,4} = a_output;
end