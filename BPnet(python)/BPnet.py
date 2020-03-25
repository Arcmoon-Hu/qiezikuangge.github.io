def DNN(data,label,laten_layers,activate,activate_d,eps=100,ba_size=100,lr=0.005):
    '''
    data:数据，要求是预处理过的，如归一化
    label:要求one-hot向量
    laten_layers:各层神经元数
    activate:各层激活函数，最后一层请使用sigmoid
    activate_d:各层激活函数的导数
    eps:epochs
    ba_size:batch_size
    lr:learning rate
    该程序默认使用RMSProp优化算法,返回参数列表
    '''
    #label_true = np.argmax(label,1)
    if len(laten_layers)<len(activate):
        print('error:the length of laten_layers not equal activate')
        return 0
    parameters = []
    W = []
    b = []
    delta_ = 1e-6
    sigma_g_w = []
    sigma_g_b = []
    ro = 0.9
    #参数初始化
    for i in range(len(laten_layers)):
        if i==0:
            W.append(np.random.randn(data.shape[1],laten_layers[i]))
            b.append(np.random.randn(laten_layers[i]))
            sigma_g_w.append(0.)
            sigma_g_b.append(0.)
        else:
            W.append(np.random.randn(laten_layers[i-1],laten_layers[i]))
            b.append(np.random.randn(laten_layers[i]))
            sigma_g_w.append(0.)
            sigma_g_b.append(0.)
    epochs = eps
    batch_size = ba_size
    learning_rate = lr
    max_step = data.shape[0]//batch_size
    for epoch in range(epochs):
        index = np.random.choice(list(range(data.shape[0])),size=data.shape[0],replace=False)
        loss_all = 0.
        for step in range(max_step):
            batch = data[index[step*batch_size:(step+1)*batch_size],:]
            batch_label = label[index[step*batch_size:(step+1)*batch_size],:]
            out = []#定义out,记录各层输出，后面计算梯度需要用到
            out_d = []#定义求导同上
        #开始前向
            for i in range(len(laten_layers)):
                if i==0:
                    out.append(activate[i](np.matmul(batch,W[i])+b[i]))
                    out_d.append(activate_d[i](np.matmul(batch,W[i])+b[i]))
                else:
                    out.append(activate[i](np.matmul(out[i-1],W[i])+b[i]))
                    out_d.append(activate_d[i](np.matmul(out[i-1],W[i])+b[i]))
        #计算输出误差
            loss = 0.5*np.mean(np.sum(np.square(out[-1]-batch_label),1))
        #开始反向传播
            dw = []
            db = []
            delta = []
            for i in range(1,len(laten_layers)+1):
                j = i
                i = -i
                if i == -1:
                    dw.append(np.matmul(np.transpose(out[i-1]),(np.mean((out[i]-batch_label),0)*out_d[i])))
                    db.append(np.mean(np.mean(out[i]-batch_label,0)*out_d[-1],0))
                    delta.append(np.mean(out[i]-batch_label,0))
                elif j<len(laten_layers):
                    delta.append(np.matmul(out_d[i+1]*delta[-1],np.transpose(W[i+1])))
                    dw.append(np.matmul(np.transpose(out[i-1]),delta[-1]*out_d[i]))
                    db.append(np.mean(delta[-1]*out_d[i],0))
                else:
                    delta.append(np.matmul(out_d[i+1]*delta[-1],np.transpose(W[i+1])))
                    dw.append(np.matmul(np.transpose(batch),delta[-1]*out_d[i]))
                    db.append(np.mean(delta[-1]*out_d[i],0))
            for i in range(len(W)):
                sigma_g_w[i] = ro*sigma_g_w[i] + (1-ro)*dw[-(i+1)]*dw[-(i+1)]
                sigma_g_b[i] = ro*sigma_g_b[i] + (1-ro)*db[-(i+1)]*db[-(i+1)]
                W[i] = W[i]-learning_rate*dw[-(i+1)]/(np.sqrt(sigma_g_w[i])+delta_)
                b[i] = b[i]-learning_rate*db[-(i+1)]/(np.sqrt(sigma_g_b[i])+delta_)
            #for i in range(len(W)):
             #   W[i] = W[i]-learning_rate*dw[-(i+1)]
              #  b[i] = b[i]-learning_rate*db[-(i+1)]
            loss_all = loss_all+loss
            loss = 0.
        if (epoch+1)%10==0:
            learning_rate = learning_rate*0.9
        for i in range(len(W)):
            if i==0:
                answer = activate[i](np.matmul(data,W[i])+b[i])
            else:
                answer = activate[i](np.matmul(answer,W[i])+b[i])
        print('acc:',np.sum(np.argmax(answer,1)==np.argmax(label,1)),loss_all/max_step)
        parameters.append([W])
    return parameters+[b]+activate
def relu(x):
    return np.maximum(x,0)
def sigmoid(x):
    return 1/(1+np.exp(-x))
def relu_d(x):
    y = np.maximum(x,0)
    y[y>0] = 1
    return y
def sigmoid_d(x):
    return sigmoid(x)*(1-sigmoid(x))
def tanh(x):
    return (np.exp(x)-np.exp(-x))/(np.exp(x)+np.exp(-x))
def tanh_d(x):
    return 1-tanh(x)*tanh(x)
def forward(parameters,test_data,test_label):
    W = parameters[0]
    b = parameters[1]
    activate = parameters[2]
    for i in range(len(W)):
        if i==0:
            answer = activate[i](np.matmul(test_data,W[i])+b[i])
        else:
            answer = activate[i](np.matmul(answer,W[i])+b[i])
    return np.sum(np.argmax(answer,1)==test_label)/len(test_label)
if  __name__ == '__main__':
       parameters = DNN(train_data,train_label,laten_layers,activate,activate_d)
       print(forward(parameters,test_data,test_label))
    