function dy = leftout(w,b,x,s)
    switch s   
        case 'sigmoid'
            dy = (1./(1+exp(-(x*w-b)))).*(1-1./(1+exp(-(x*w-b))));
        case 'relu'
            dy = (x*w-b)>0;
    end
end