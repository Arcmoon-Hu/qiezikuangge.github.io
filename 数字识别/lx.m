% dota_lx = dota';
% dota_lx = sort(dota_lx,'descend');
 n = size(y_sim,1);
 for  j =1:n
      l(j) = find(y_sim(j,:)==max(y_sim(j,:)));
 end
 confusion = [l',y(u_2)];
 zhunquelv = sum(l'==y(u_1))/length(l);