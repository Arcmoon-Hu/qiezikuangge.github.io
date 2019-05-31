function distance = juli(a,b,p)%计算向量a,b的距离，采用闵科夫斯基距离公式p为幂
if size(a,2)~=size(b,2)
    disp('error:两样本维度不同')
else
    distance=0;
    for i=1:length(a)
        distance = distance + (a(i)-b(i))^p;
    end
 distance = distance^(1/p);
end