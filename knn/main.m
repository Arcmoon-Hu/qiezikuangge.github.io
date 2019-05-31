%main
clear
load fisheriris
specie = zeros(150,1);
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
o=randi(150,120,1);
zhibiao = meas(o,:);
lei = specie(o,:);
meas(o,:)='';
specie(o,:)='';
zhunquelv = 0;
for k=1:30
   daice_lei = specie(k); 
   [jieguo,vote_matrix] = knn(zhibiao,lei,meas(k,:),60);
   if length(jieguo)<2
       if jieguo-daice_lei~=0
           zhunquelv=zhunquelv+1;
       end
   else
       r=randi(2,1);
       if jieguo(r)-daice_lei~=0
           zhunquelv=zhunquelv+1;
       end
   end
end