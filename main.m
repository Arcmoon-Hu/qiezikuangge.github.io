tic
clear
load fisheriris 
specie = zeros(150,3);
for i = 1:150
    switch species{i}
        case 'setosa'
            specie(i,:)=[1,0,0];
        case 'versicolor'
            specie(i,:)=[0,1,0];
        case 'virginica'
             specie(i,:)=[0,0,1];
    end
end
data_input = zeros(150,4);
for  j=1:4
    data_input(:,j) = (meas(:,j)-min(meas(:,j)))/(max(meas(:,j))-min(meas(:,j)));
end
u=randperm(150,120);
xunlianji=data_input(u',:);
ceshiji = data_input;
ceshiji(u',:)='';
jieguo = BPnet(xunlianji,specie(u',:),[5,3]);
yuce_array = BPsim(ceshiji,jieguo);
ceshijishuchu = specie;
ceshijishuchu(u,:) = '';
bijiao = [yuce_array,ceshijishuchu];
toc
