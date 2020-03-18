
clc;
sub_dim = 3;
lambda1 = 3;
lambda2 = 0.1;
num_frame = 100;

[mean_rate,var_rate] = cross_test(sub_dim,lambda1,lambda2,num_frame);


