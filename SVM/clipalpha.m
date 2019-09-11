function b = clipalpha(a,H,L)
    if a>H
        b = H;
    elseif a<L
        b = L;
    else
        b = a;
    end
end