function k_xi_xj = Gausskernel(x1,x2)
    sigma = 0.5;
    [size_x1,~] = size(x1);
    k_xi_xj = ones(1,size_x1);
    if size_x1 == 1
        k_xi_xj = exp(-sum((x1-x2).^2)/(2*sigma^2));
    else
        for i = 1:size_x1
            k_xi_xj(i) = exp(-sum((x1(i,:)-x2).^2)/(2*sigma^2));
        end
    end
end