function index = find_this_matrix(a,b)
%a is a matrix and b is a vector.the function'aim is to find row of a equal
%the function'aim is to find row of a equal b
k = size(a,1);
i=0;
for j = 1:k
    if a(j,:)==b
       i = i+1;
       index(i)=j;
    end
end
index = index';    
end