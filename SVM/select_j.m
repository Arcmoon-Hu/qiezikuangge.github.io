function j = select_j(data_x,data_y,alpha,b,i)
    ei = (data_x*data_x(i,:)')'*(alpha.*data_y)+b-data_y(i);
    size = length(data_y);
    ek = zeros(1,size);
    for k=1:length(size)
        ek(k) = (data_x*data_x(k,:)')'*(alpha.*data_y)+b-data_y(k);
    end
    eol = abs(ei-ek);
    eol(i) = 0; 
    j = find(eol==max(eol));
    j = j(1);
end