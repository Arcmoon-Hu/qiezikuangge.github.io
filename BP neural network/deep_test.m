    clear
    clc
    data = xlsread('c:\users\guyue\desktop\dataformachinelearning\digit.xlsx');
    data = tezhengshaixuan(data,100);
    choose = sum(data,1);
    index = find(choose~=0);
    data = data(:,index);
    [data_m,data_n] = size(data);
    for j = 1:data_n-1
        data(:,j) = (data(:,j)-min(data(:,j)))/(max(data(:,j))-min(data(:,j)));
    end
    [data_x_train,data_y_train,data_x_test,data_y_test] = crossdata(data,0.6);
     deep(data_x_train,data_y_train,data_x_test,data_y_test)
   jieguo = BPnet(data_x_train,data_y_train,[30,10]);
    w_layer = jieguo{1};
    a_layer = jieguo{2};
    w_output = jieguo{3};
    a_output =  jieguo{4};
    f1 = jieguo{5};
    f2 = jieguo{6};
    yuce = zeros(2000,1);
   for i = 1:2000
       layer_input = data_x_test(i,:)*w_layer-a_layer;%һ�У�node��1����
       layer_output = f1(layer_input);%һ��,node(1)��
       yuce_input = layer_output*w_output-a_output;%һ�У�node��2����
       yuce_output = f2(yuce_input);%Ԥ����
       yuce(i,1) = find(yuce_output == max(yuce_output));
   end
   sum(yuce==data_y_test)/2000