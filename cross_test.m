function [mean_rate,var_rate]=cross_test(sub_dim,lambda1,lambda2,num_frame)
% 对eth80进行交叉测试

for num_experiment = 1 : 10
    accuracy(num_experiment) = PCGSC(sub_dim,num_experiment,lambda1,lambda2,num_frame);
%     accuracy(num_experiment) = PCGSC(sub_dim,num_experiment,lambda1,lambda2);
end

mean_rate=mean(accuracy);
var_rate=var(accuracy);
