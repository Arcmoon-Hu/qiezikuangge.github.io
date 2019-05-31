function yuce_array = BPsim(data_yuce_input,net)
[data_yuce_input_row,~] = size(data_yuce_input);
w_layer = net{1};
a_layer = net{2};
w_output = net{3};
a_output = net{4};
f1 = net{5};
f2 = net{6};
%[yuce_row,~]=size(data_yuce_input);
%##for i = 1:yuce_row
%##    layer_input = data_yuce_input(i,:)*w_layer-a_layer;
%##    layer_output = f1(layer_input);
%##    yuce_input = layer_output*w_output-a_output;
%##    yuce_output = f2(yuce_input);
%##    yuce_array(i,:) = yuce_output;
%##end
%vectorization
layer_input = data_yuce_input * w_layer - ones(data_yuce_input_row,1)*a_layer;
layer_output = f1(layer_input);
yuce_input = layer_output * w_output - ones(data_yuce_input_row,1)*a_output;
yuce_output = f2(yuce_input);
yuce_array = yuce_output;