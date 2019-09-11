clear
clc
data = xlsread('C:\users\guyue\desktop\dataformachinelearning\Irisdata.xlsx');
new_data = data(101,1:end-1);
new_label = data(101,end);
data(101,:) = '';
answer = labels_SVM(data,new_data);


