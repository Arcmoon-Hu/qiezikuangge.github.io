function distance = juli(a,b,p)%��������a,b�ľ��룬�����ɿƷ�˹�����빫ʽpΪ��
if size(a,2)~=size(b,2)
    disp('error:������ά�Ȳ�ͬ')
else
    distance=0;
    for i=1:length(a)
        distance = distance + (a(i)-b(i))^p;
    end
 distance = distance^(1/p);
end