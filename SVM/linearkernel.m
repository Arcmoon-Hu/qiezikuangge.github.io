function k_xi_xj = linearkernel(x1,x2)
    [size_x1,~] = size(x1);
    k_xi_xj = ones(1,size_x1);
    if size_x1 == 1
        k_xi_xj = x1*x2';
    else
        k_xi_xj = (x1*x2')';
    end
end
