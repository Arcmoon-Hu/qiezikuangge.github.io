function jieguo = P_beiyesi(train_Data,sim_Data,P_target)
         sigma =  area(train_Data);
         [~,sigma_col] = size(sigma);
         P_matrix = zeros(1,sigma_col);
         for j = 1:sigma_col
             P_matrix(j) = 1/((2/pi)^0.5)*exp(-(sim_Data(j)-sigma(1,j))^2/2/(sigma(2,j)^2));
         end
         jieguo = P_target*multiply(P_matrix); 
end
