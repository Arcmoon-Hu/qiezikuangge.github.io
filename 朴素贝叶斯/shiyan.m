load iris_dataset.mat
input = irisInputs';
target = irisTargets';
%��Ҫ�۲����ݼ�����ǰ�����ݼ����顣
input_all = cell(1,3);
input_all{1} = input(target(:,1)==1,:);
input_all{2} = input(target(:,2)==1,:);
input_all{3} = input(target(:,3)==1,:);
%{
�������ȼ����������
num=input('�����:')
input_all =  cell(1,k);
for  i = 1:num
     input_all{i} = input(target(:,i)==1)
end
%}
P_target = [length(input_all{1})/length(input),length(input_all{2})/length(input),length(input_all{3})/length(input)];
%{
����һ�еȼ���
P_target = [1,num]
for j=1:num
    P_target(j) = length(input_all{j})/length(input)
end
%}
k = randi(length(target));
sim_Data = input(k,:);
jieguo = zeros(1,3);
for j =1:3
    jieguo(j) = P_beiyesi(input_all{j},sim_Data,P_target(j));
end
disp(find(jieguo==max(jieguo)))