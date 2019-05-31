function distance = juli(a,b,p)%��������a,b�ľ��룬�����ɿƷ�˹�����빫ʽpΪ��
%disp('just give the distance of the vector a with the matrix b or vector b ')
    if nargin == 2
        p=2;
        distance=juli(a,b,p);
    end
    if size(a,2)~=size(b,2)
        disp('error:������ά�Ȳ�ͬ')
    else
        distance=zeros(1,size(b,1));
        for j = 1:size(b,1)
            distance(j) = (sum((a-b(j,:)).^2))^(1/p);
        end
    end
end