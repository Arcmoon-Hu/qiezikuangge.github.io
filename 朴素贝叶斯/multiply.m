function num = multiply(vector)
         if sum(vector==0)==1
             disp('warning:0 in vector')
             num = 0;
         else
             num = 1;
             for i = 1:length(vector)
                 num = num*vector(i);
             end
         end
end