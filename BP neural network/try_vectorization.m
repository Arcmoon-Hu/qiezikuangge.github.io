
           i = rand_gradient(j);
           %第i个样本col列
           layer_input = data_input*w_layer-a_layer;%一行，node（1）列
           layer_output = f1(layer_input);%一行,node(1)列
           yuce_input = layer_output*w_output-a_output;%一行，node（2）列
           yuce_output = f2(yuce_input);%预测结果
           shiji_output = data_output;
           eol_array = sum(sum((yuce_output-shiji_output).^2,1));
           %计算每一个样本的误差
           eol_array=0.5*eol_array/m%行数;
           %BP算法开始修正
           %先修正w_output
           g=-(yuce_output-shiji_output).*f2_Diff(yuce_input);
           dota_w_output = zeros(nodes(1),nodes(2))
           dota_a_output = zeros(1,nodes(2))
           for i=1:row_data_input
               G = ones(nodes(1),nodes(2)).*g(i,:)
               dota_w_output = dota_w_output + yita*G*.*layer_output(i,:)
               dota_a_output = dota_a_output + yita*g(i,:);
           end
           w_output = w_output + dota_w_output/row_data_input;
           a_output = a_output + dota_a_output/row_data_input;
           %修正w_input
           eh=f1_Diff(layer_input)*(w_output*g');
      
%          
           for k=1:col_data_input
               w_layer(k,:)=w_layer(k,:)+yita*eh*data_input(i,k);
           end
           a_layer = a_layer - yita*eh;
%
    