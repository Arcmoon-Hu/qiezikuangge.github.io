 function y = rightout(w,b,x,s)
 switch s
     case 'sigmoid'
        y = 1./(1+exp(-(x*w-b)));
     case 'relu'
        y = max(0,x*w-b);
 end
 end