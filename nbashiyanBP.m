clear
clc
tic
data = xlsread('C:\Users\guyue\Desktop\��ҵ���\����\nbadata.xlsx');
data = data(:,[2,5:end]);
%���ݹ�һ��
data_input = data(:,2:end);
[data_input_row,data_input_col] = size(data_input);
for  j = 1:data_input_col
    data_input(:,j) = (data_input(:,j)-min(data_input(:,j)))/(max(data_input(:,j))-min(data_input(:,j)));
end
data_output = data(:,1);
train_data_input = data_input(73:end,:);
train_data_output = data_output(73:end,:);
text_data_input = data_input(1:72,:);
text_data_output = data_output(1:72,:);
jieguo = BPnet(train_data_input,train_data_output,[8,1]);
yuce_data_output = BPsim(text_data_input,jieguo);
toc