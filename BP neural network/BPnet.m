function jieguo=BPnet(data_input,data_output,nodes)
yita=0.05;
%���Խ׶Σ��������ü������Ϊsigmod
[row_data_input,col_data_input] = size(data_input);
[row_data_output,col_data_output] = size(data_output);
if row_data_input~=row_data_output||nodes(2)~=col_data_output
    disp('error:please test data')
end
w_layer = randn(col_data_input,nodes(1));
%������������ָ������Լ�����ڵ�������ʼ������㵽�����Ȩ�ؾ���
a_layer = zeros(1,nodes(1));
%��������ڵ�������ʼ��������ֵ
w_output = randn(nodes(1),nodes(2));
%��������ڵ�������ڵ��ʼ�����㵽������Ȩ�ؾ���
a_output = zeros(1,col_data_output);
f1 =@(x) (exp(x)-exp(-x))./(exp(x)+exp(-x));%���㼤���
syms x
f1_Diff = diff(f1(x));
f1_Diff = matlabFunction(f1_Diff);
f2 =@(t) (exp(t)-exp(-t))./(exp(t)+exp(-t));%����㼤���
syms t
f2_Diff = diff(f2(t));
f2_Diff = matlabFunction(f2_Diff);
%ǰ�򴫲���ʼ��׼BP�㷨��ÿ��ȡһ�����͸���һ�Σ�
n = 0;
eol = 1;
while n < 2000
    rand_gradient = randperm(row_data_input,round(row_data_input*0.5));
    len = length(rand_gradient);
     eol_array = zeros(len,1);
%      P_w_output = zeros(nodes(1),nodes(2));
%      P_a_output = zeros(1,col_data_output);
%      P_w_layer = zeros(col_data_input,nodes(1));
%      P_a_layer = zeros(1,nodes(1));
    for  j = 1:len
           i = rand_gradient(j);%��������ݶ��½�
           %��i������col��
           layer_input = data_input(i,:)*w_layer-a_layer;%һ�У�node��1����
           layer_output = f1(layer_input);%һ��,node(1)��
           yuce_input = layer_output*w_output-a_output;%һ�У�node��2����
           yuce_output = f2(yuce_input);%Ԥ����
           shiji_output = data_output(i,:);
           eol_array(j) = sum((yuce_output-shiji_output).^2);
           %����ÿһ�����������
           eol_array(j)=0.5*eol_array(j);
           %BP�㷨��ʼ����
           %������w_output
           g=-(yuce_output-shiji_output).*f2_Diff(yuce_input);
%            p_w_output = zeros(nodes(1),nodes(2));
%            for h=1:nodes(1)
%                p_w_output(h,:)=p_w_output(h,:)+yita*g*layer_output(h);
%            end
           for h=1:nodes(1)
               w_output(h,:)=w_output(h,:)+yita*g*layer_output(h);
           end
%            P_w_output = P_w_output + p_w_output;
%            %����a_output
%            p_a_output = zeros(1,col_data_output);
%            p_a_output = -yita*g;
%            P_a_output = P_a_output + p_a_output;
             a_output = a_output -yita*g;
           %����w_input
           for h=1:nodes(1)
               eh(h)=f1_Diff(layer_input(h))*(w_output(h,:)*g');
           end
%            p_w_layer = zeros(col_data_input,nodes(1));
%            for k=1:col_data_input
%                p_w_layer(k,:)=p_w_layer(k,:)+yita*eh*data_input(i,k);
%            end
           for k=1:col_data_input
               w_layer(k,:)=w_layer(k,:)+yita*eh*data_input(i,k);
           end
           a_layer = a_layer - yita*eh;
%            P_w_layer = P_w_layer + p_w_layer;
%            %����a_layer
%            p_a_layer = zeros(1,nodes(1));
%            p_a_layer = -yita*eh;
%            P_a_layer = P_a_layer + p_a_layer;
    end
    eol = sum(eol_array)/length(eol_array);
    if eol >10^(-3)
%     w_output = w_output+P_w_output;
%     a_output = a_output+P_a_output;
%     w_layer = w_layer+P_w_layer;
%     a_layer = a_layer+P_a_layer;
    n=n+1;%���������
    eol_array1(n) = eol;
    else
        break;
    end
    if rem(n,100)==0
        disp(n)
    end
end
disp(eol)
disp(n)
jieguo{1}=w_layer;
jieguo{2}=a_layer;
jieguo{3}=w_output;
jieguo{4}=a_output;
jieguo{5}=f1;
jieguo{6}=f2;
jieguo{7}=eol_array1;
plot(1:length(jieguo{7}),jieguo{7})

