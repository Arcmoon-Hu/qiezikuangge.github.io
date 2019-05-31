clear
load fisheriris
o=randperm(150);
o=o';
specie=zeros(150,1);
meas_jianyan=meas;
for i = 1:150
    switch species{i}
        case 'setosa'
            specie(i)=1;
        case 'versicolor'
            specie(i)=2;
        case 'virginica'
            specie(i)=3;
    end
end
meas=meas(o,:);
[jieguo,u,lei] = kmeans(meas,3);
specie_1=zeros(150,1);
for i=1:150
    for j=1:150
        if meas_jianyan(i,:)==u(j,:)
            specie_1(i)=lei(j);
        end
    end
    if specie_1(i)==0
        disp(i)
    end
end
chushi=[meas_jianyan,specie,specie_1];