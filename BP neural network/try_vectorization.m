
           i = rand_gradient(j);
           %��i������col��
           layer_input = data_input*w_layer-a_layer;%һ�У�node��1����
           layer_output = f1(layer_input);%һ��,node(1)��
           yuce_input = layer_output*w_output-a_output;%һ�У�node��2����
           yuce_output = f2(yuce_input);%Ԥ����
           shiji_output = data_output;
           eol_array = sum(sum((yuce_output-shiji_output).^2,1));
           %����ÿһ�����������
           eol_array=0.5*eol_array/m%����;
           %BP�㷨��ʼ����
           %������w_output
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
           %����w_input
           eh=f1_Diff(layer_input)*(w_output*g');
      
%          
           for k=1:col_data_input
               w_layer(k,:)=w_layer(k,:)+yita*eh*data_input(i,k);
           end
           a_layer = a_layer - yita*eh;
%
    