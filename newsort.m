function [answer,B]=newsort(A)
len=length(A);
B=sort(A,'descend');
answer=zeros(len,1);
for i=1:len
    for j=1:len
        if A(i)==B(j)
            answer(i)=j;
        end
    end
end