function [X_Train, X_Test, Train_label, Test_label, num_class] = train_test_eth80(num_experiment)
load Imgsets_eth80;
load random_index_eth80;
num_class = 8;
num_sets_per_class = 5;

%% 初始化训练集，测试集，及它们的标签
X_Train = cell(1,num_class*num_sets_per_class);
X_Test = cell(1,num_class*num_sets_per_class);
Train_label = zeros(1,num_class*num_sets_per_class);
Test_label = zeros(1,num_class*num_sets_per_class);
for j = 1:num_class
    for k = 1:num_sets_per_class
        temp1 = Img_sets_eth80{j,random_index{num_experiment}(j,k)};
        X_Train{1,(j-1)*num_sets_per_class+k} = temp1;
        temp2 = Img_sets_eth80{j,random_index{num_experiment}(j,k+5)};
        X_Test{1,(j-1)*num_sets_per_class+k} = temp2;
        Train_label(1,(j-1)*num_sets_per_class+k) = j;
        Test_label(1,(j-1)*num_sets_per_class+k) = j;
    end
end

