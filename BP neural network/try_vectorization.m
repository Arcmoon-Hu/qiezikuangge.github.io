function try_vectorization(data,y,lr,epochs,batch_size)
    W1 = randn(1000,400);
    b1 = randn(1,400);
    W2 = randn(400,100);
    b2 = randn(1,100);
    W3 = randn(100,2);
    b3 = randn(1,2);
    max_batch_size = fix(size(data,1)/batch_size);
    d_all_w1 = zeros(size(W1));
    d_all_w2 = zeros(size(W2));
    d_all_w3 = zeros(size(W3));
    d_all_b1 = zeros(size(b1));
    d_all_b2 = zeros(size(b2));
    d_all_b3 = zeros(size(b3));
    ro = 0.9;
    for epoch=1:epochs
        index = randperm(size(data,1));
        loss_all = 0;
        for j =1:max_batch_size
              %forward
              index_ = index((j-1)*batch_size+1:j*batch_size);
              x = data(index_,:);
              x1 = sigmoid(x,W1,b1);
              x2 = sigmoid(x1,W2,b2);
              x3 = sigmoid(x2,W3,b3);
              loss = 0.5*sum(sum((x3-y(index_,:)).^2))/batch_size;
              %backward
              dl3 = (x3-y(index_,:))/batch_size;
              dl2 = dl3.*sigmoid(x2,W3,b3)*W3';
              dl1 = dl2.*sigmoid(x1,W2,b2)*W2';
              dw3 = x2'*(dl3.*bsigmoid(x2,W3,b3));
              db3 = mean(dl3.*bsigmoid(x2,W3,b3),1);
              dw2 = x1'*(dl2.*bsigmoid(x1,W2,b2));
              db2 = mean(dl2.*bsigmoid(x1,W2,b2),1);
              dw1 = x'*(dl1.*bsigmoid(x,W1,b1));
              db1 = mean(dl1.*bsigmoid(x,W1,b1),1);
              d_all_w1 = ro*d_all_w1+(1-ro)*dw1.*dw1;
              d_all_w2 = ro*d_all_w2+(1-ro)*dw2.*dw2;
              d_all_w3 = ro*d_all_w3+(1-ro)*dw3.*dw3;
              d_all_b1 = ro*d_all_b1+(1-ro)*db1.*db1;
              d_all_b2 = ro*d_all_b2+(1-ro)*db2.*db2;
              d_all_b3 = ro*d_all_b3+(1-ro)*db3.*db3;
              W3 = W3-lr*dw3./(10e-7+sqrt(d_all_w3));b3 = b3-lr*db3./(10e-7+sqrt(d_all_b3));
              W2 = W2-lr*dw2./(10e-7+sqrt(d_all_w2));b2 = b2-lr*db2./(10e-7+sqrt(d_all_b2));
              W1 = W1-lr*dw1./(10e-7+sqrt(d_all_w1));b1 = b1-lr*db1./(10e-7+sqrt(d_all_b1));
              loss_all = loss_all+loss;
        end
        if rem(epoch,10)==0
            lr = lr*0.9;
        end
        loss_all = loss_all/max_batch_size;
        w{1,1} = W1;w{1,2} = W2;w{1,3} = W3;
        b{1,1} = b1;b{1,2} = b2;b{1,3} =  b3;
        disp(['loss = ',num2str(loss_all)])
        disp(['acc = ',num2str(forward(data,w,b,y))]);
    end
end
function acc = forward(data,w,b,label)
        x1 = sigmoid(data,w{1,1},b{1,1});
        x2 = sigmoid(x1,w{1,2},b{1,2});
        pre = sigmoid(x2,w{1,3},b{1,3});
        acc = 0;
        for i =1:size(label,1)
            if find(pre(i,:)==max(pre(i,:)))==(find(label(i,:)==max(label(i,:))))
                acc = acc+1;
            end
        end
        acc = acc/size(data,1);
end
function y = relu(x,w,b)
        dim = size(x,1);
        y = max(1e-6,x*w+ones(dim,1)*b);
end
function y = brelu(x,w,b)
        dim = size(x,1);
        y = ones(size(x*w+ones(dim,1)*b));
        y((x*w+ones(dim,1)*b)<=1e-6) = 0;
end
function y = sigmoid(x,w,b)
      dim = size(x,1);
      y = 1./(1+exp(-(x*w+ones(dim,1)*b)));
end
function y = bsigmoid(x,w,b)
      dim = size(x,1);
      y = exp(-(x*w+ones(dim,1)*b))./((1+exp(-(x*w+ones(dim,1)*b))).^2);
end