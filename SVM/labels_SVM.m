%¶à·ÖÀàÖ§³ÖÏòÁ¿»ú
function answer = labels_SVM(data,new_data)
    maxlabel = max(data(:,end));
    minlabel = min(data(:,end));
    [data,min_data,max_data] = normalization(data);
    new_data = (new_data-min_data)./(max_data-min_data);
    zhunquelv = 0;
    for  label = minlabel:maxlabel
        data_new = data;
        data_new(data_new(:,end)~=label,end) = -1;
        data_new(data_new(:,end)==label,end) = 1;
        [data_x_train,data_y_train,data_x_test,data_y_test] = crossdata(data_new,0.8);
        answer = SVM_theory(data_x_train,data_y_train,data_x_test,data_y_test,new_data);
        acc = max(acc,answer{1});
        
    end
end
