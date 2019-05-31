function data_matrix = tezhengshaixuan(data,tau)
    [data_row,data_col] = size(data); 
    for i = 1:data_col-1
        if max(data(:,i))~=0
            data(:,i) = (data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
        end
    end
    all_distance = cell(3,data_row);
    for j = 1:data_row
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
        all_distance{2,j} = middle_same(u,:);
        middle_same = data(find(data(:,data_col)~=data(j,data_col)),1:data_col-1);
        distance = juli(data(j,1:data_col-1),middle_same);
        min_distance = find(distance==min(distance));
        if length(min_distance)<1
            u = min_distance(1);
        else
            u = min_distance;
        end
        all_distance{3,j} = middle_same(u,:);
        if rem(j,data_row/100)==0
            disp(['ÒÑ½øĞĞ',num2str(j/(data_row/100)),'%'])
        end
    end
    dota_matrix = zeros(data_row,data_col-1);
    for o =1:data_row
        dota_matrix(o,:) = -(all_distance{1,o}-all_distance{2,o}).^2+(all_distance{1,o}-all_distance{3,o}).^2;
    end
    dota = sum(dota_matrix,1);
    effect = find(dota>=tau);
    data_matrix = data(:,effect);
end