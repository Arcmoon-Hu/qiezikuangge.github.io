function sigma = area(A)
   [~,A_col] = size(A);
   sigma = zeros(2,A_col);
   for j = 1:A_col
       sigma(1,j) = mean(A(:,j));
       sigma(2,j) = std(A(:,j));
   end
end