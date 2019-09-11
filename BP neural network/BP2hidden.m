%{
netinput1 = X(i,1:784)*[784,30]+[1,30];
netoutput1 = f(netinput1)
netinput2 = netoutput1*[30,24]+[1,24];
netoutput2 = f(netoutput2)
%}
function [] = deep(data_x_train_,data_y_train_,data_x_test_,data_y_test_)
    [sizex_m,sizex_n] = size(data_x_train_);
    [~,sizey_n] = size(data_y_train_);
    layer_1nodes = 20;%第一隐层20个神经元
    layer_2nodes = 10;%第二隐层20个神经元
    layer_endnodes = sizey_n;%第三隐层10个和输出目标维数相同
    b1 = randn(1,layer_1nodes);
    b2 = randn(1,layer_2nodes);
    b_end = randn(1,layer_endnodes);
    w1 = randn(sizex_n,layer_1nodes);
    w2 = randn(layer_1nodes,layer_2nodes);
    w_end = randn(layer_2nodes,layer_endnodes);
    yita = -0.01;
%     f =@(x1) (exp(x1)-exp(-x1))./(exp(x1)+exp(-x1));%隐层激活函数
%     syms x1
%     diff_f = diff(f1(x1));
%     diff_f = matlabFunction(diff_f);
    iter = 0;
    Loss = zeros(1,2000);
    while iter<2000
       k1 = randperm(sizex_m,100);
       data_x_train = data_x_train_(k1,:);
       data_y_train = data_y_train_(k1,:);
       for i = 1:length(k1)
            dw_end = zeros(layer_2nodes,layer_endnodes);
            dw2 = zeros(layer_1nodes,layer_2nodes);
            dw1 = zeros(sizex_n,layer_1nodes);
            y1 = rightout(w1,b1,data_x_train(i,:),'relu');%(1,36)*(36,20)
            y2 = rightout(w2,b2,y1,'sigmoid');%(1,20)*(20,10)
            y_end = rightout(w_end,b_end,y2,'sigmoid');%(1,10)*(10,7)
            loss(i) = 0.5*sum((y_end-data_y_train(i,:)).^2);%损失函数
            %正向完成，开始反向
            dy3 = (y_end - data_y_train(i,:));%（1,3）
            for j = 1:layer_2nodes
                dw_end(j,:) = dy3.*leftout(w_end,b_end,y2,'sigmoid')*y2(j);
            end
            db_end =  dy3.*leftout(w_end,b_end,y2,'sigmoid');
            for j = 1:layer_2nodes
                dy2(j) = sum(dy3.*w_end(j,:).*leftout(w_end,b_end,y2,'sigmoid'));%（1,20）
            end
            for j = 1:layer_1nodes
                dw2(j,:) = dy2.*leftout(w2,b2,y1,'sigmoid')*y1(j);
            end
            db_2 = dy2.*leftout(w2,b2,y1,'sigmoid');
            for j = 1:layer_1nodes
                dy1(j) = sum(dy2.*w2(j,:).*leftout(w2,b2,y1,'sigmoid'));%（1,30）
            end
            for j = 1:sizex_n
                dw1(j,:) = dy1.*leftout(w1,b1,data_x_train(i,:),'relu')*data_x_train(i,j);
            end
            db_1 = dy1.*leftout(w1,b1,data_x_train(i,:),'relu');
            w_end = w_end + yita*dw_end;b_end = b_end + yita*db_end;
            w2 = w2 + yita*dw2;b2 = b2+yita*db_2;
            w1 = w1 + yita*dw1;b1 = b1+yita*db_1;
       end
       iter = iter+1;
       if   rem(iter,2000/100)==0
            disp([num2str(iter/(2000/100)),'%已进行'])
       end
       Loss(iter) = sum(loss)/length(k1);
       yuce1 = zeros(length(data_y_test_),1);
       for j = 1:length(data_y_test_)
           z1 = rightout(w1,b1,data_x_test_(j,:),'relu');
           z2 = rightout(w2,b2,z1,'sigmoid');
           z3 = rightout(w_end,b_end,z2,'sigmoid');
           k = find(z3==max(z3));
           yuce1(j,1) = k(1);
       end
        test(iter) = sum(yuce1 == data_y_test_)/length(data_y_test_);
    end
    plot([1:iter],test,'b-')
    hold on
    plot([1:iter],Loss,'r-')
    disp(max(test))
    disp(min(test))
end
