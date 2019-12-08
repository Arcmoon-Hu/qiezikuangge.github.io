class RBM:
    def __init__(self,data,W,b,b1,max_iteration,lr):
        self.data = tf.convert_to_tensor(data,tf.float32)
        #x_test = tf.reshape(x_test,[2,784])
        self.lr = lr
        self.W = tf.Variable(W)
        self.b = tf.Variable(b)
        self.b1 = tf.Variable(b1)
        self.iteration = 0
        self.max_iteration = max_iteration
        self.loss = 0
        self.restruction = tf.zeros(self.data.shape)
        self.encode_data = tf.constant([0.])
        self.count = 0
    def isactive(self,x):
        ac = x -  tf.random.uniform([x.shape[0],x.shape[1]])
        ac = ac.numpy()
        ac[ac>0]=1
        ac[ac<0]=0
        return tf.convert_to_tensor(ac,tf.float32)
    #def isupdate(self,w,b0,b1):
        '''
        b0\in hidden
        b1\in visible
        '''
     #   _h0 = tf.nn.sigmoid(tf.add(tf.matmul(self.data,w),b0))#i*500
      #  h0  = self.isactive(_h0)#激活状态
       # _v1 = tf.nn.sigmoid(tf.add(tf.matmul(h0,tf.transpose(w)),b1))#重构i*784
        #loss_ = tf.reduce_mean(tf.square(self.data-_v1))
        #if loss_<=self.loss:
        #    return True
        #else:
        #    return False
    def new_loss(self,w,b0,b1):
        u0_ = tf.nn.sigmoid(tf.add(tf.matmul(self.data,w),b0))#i*500
        u0  = isactive(u0_)#激活状态
        _a1 = tf.nn.sigmoid(tf.add(tf.matmul(u0,tf.transpose(w)),b1))#重构i*784
        loss_ = tf.reduce_mean(tf.square(self.data-_a1))
        return loss_
            #return tape.gradient(loss_,self.W)
    def encode_compute(self,data_all):
        self.encode_data = tf.nn.sigmoid(tf.add(tf.matmul(data_all,self.W),self.b))
        return self.encode_data
    def main(self):
        optimizer = tf.optimizers.Adam(1e-2)
        while self.iteration<self.max_iteration:
            loss_ = self.loss
            with tf.GradientTape() as tape:
                tape.watch([self.W,self.b,self.b1])
                _h0 = tf.nn.sigmoid(tf.add(tf.matmul(self.data,self.W),self.b))#i*500
                h0  = self.isactive(_h0)#激活状态
                _v1 = tf.nn.sigmoid(tf.add(tf.matmul(h0,tf.transpose(self.W)),self.b1))#重构i*784
                v1 = self.isactive(_v1)
                _h1 =  tf.nn.sigmoid(tf.add(tf.matmul(v1,self.W),self.b))#i*500
                pro_grad = tf.matmul(tf.transpose(self.data),_h0)#784*500
                neg_grad = tf.matmul(tf.transpose(_v1),_h1)#784*500
                CD = pro_grad-neg_grad
                self.loss = tf.reduce_mean(tf.square(self.data-_v1))
            self.W = self.W+self.lr*CD
            self.b1 = self.b1+self.lr*(tf.reduce_mean(self.data-_v1,0))
            self.b = self.b+self.lr*(tf.reduce_mean(_h0-_h1,0))
            self.iteration = self.iteration+1
        self.restruction = _v1