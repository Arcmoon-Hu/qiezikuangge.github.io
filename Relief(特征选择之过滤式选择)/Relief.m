%用以解决多分类降维问题，过滤式选择,要求label从1开始
%just give me your data and the number of features you want yo save,then I
%get it
function data_matrix = Relief(data,feature)
    [data_row,data_col] = size(data);
    data = sortrows(data,data_col);
    label_max = max(data(:,end));
    label_min = min(data(:,end));
    prop = zeros(2,label_max-label_min+1);
    for p = label_min:label_max
        prop(1,p) = sum(data(:,end)==p)/data_row; 
    end
    prop(2,:) = [label_min:label_max];
    if find(0==prop(1,:))
        disp(prop(2,prop(1,:)==0))
        disp('label doesn"t continue')
        disp([label_min,label_max])
        return
    end
    for i = 1:data_col-1
        if max(data(:,i))~=0
            data(:,i) = (data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
        end
    end
    all_distance = cell(2+label_max-1,data_row);
    for j = 1:data_row
        now_label(j) = data(j,end);
        all_distance{1,j} = data(j,1:data_col-1);
        middle_same = data(find(data(:,data_col)==data(j,data_col)),1:data_col-1);
        j_find = find_this_matrix(middle_same,data(j,1:data_col-1));
        middle_same(j_find,:) = [];
        distance = juli(data(j,1:data_col-1),middle_same);
        min_index = find(distance==min(distance));
        if length(min_index)>1
            u = min_index(1);
        else
            u = min_index;
        end
        all_distance{2,j} = middle_same(u,:);%到这里为止，已找到猜对近邻
        t = 3;
        for i = label_min:label_max
            if i~=now_label(j)
                middle_same = data(find(data(:,data_col)==i),1:data_col-1);
                distance = juli(data(j,1:data_col-1),middle_same);
                min_distance = find(distance==min(distance));
                if length(min_distance)>1
                    u = min_distance(1);
                else
                    u = min_distance;
                end
                all_distance{t,j} = middle_same(u,:);
                t = t+1;
            end
        end
        if rem(j,fix(data_row/100))==0
            disp(['已进行',num2str(j/(data_row/100)),'%'])
        end
    end
    dota_matrix = zeros(data_row,data_col-1);
    for o =1:data_row
        prop_1 = prop;
        prop_1(:,find(now_label(o)==prop_1(2,:))) = '';
        middle = 0;
        for k = 3:2+label_max-1
              middle = middle+prop_1(1,k-2)*(all_distance{1,o}-all_distance{k,o}).^2;
        end
        dota_matrix(o,:) = -(all_distance{1,o}-all_distance{2,o}).^2+middle;
    end
    dota = sum(dota_matrix,1);
    [~,index_save] = sort(dota,'descend');
    data_matrix = data(:,[index_save(1:feature),data_col]);
end
