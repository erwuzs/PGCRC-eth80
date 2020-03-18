function accuracy = PCGSC(sub_dim,num_experiment,lambda1,lambda2,num_frame)

% sub_dim=3;
% num_experiment=1;
% lambda1=3;
% lambda2=0.1;
 %% ETH80
[X_Train, X_Test, Train_label, Test_label, num_class] = train_test_eth80(num_experiment);

%% HONDA/UCSD
% [X_Train, X_Test, Train_label, Test_label, num_class] = train_test_honda(num_experiment,num_frame);

%% MOBO/CMU
% [X_Train, X_Test, Train_label, Test_label, num_class] = train_test_mobo(num_experiment);

%% YTC
% [X_Train, X_Test, Train_label, Test_label, num_class] = train_test_YTC(num_experiment);

%% YaleB
% [X_Train, X_Test, Train_label, Test_label, num_class] = train_test_YaleB(num_experiment);

%% 对每一簇学习一个子空间，并映射入对称空间
for i_test=1:size(X_Train,2)
%     X_Train{1,i_test} = test(X_Train{1,i_test},sub_dim);
    X_Train{1,i_test} = Compute_Subspace(X_Train{1,i_test},sub_dim);
end
for i_test=1:size(X_Test,2)
    X_Test{1,i_test} = Compute_Subspace(X_Test{1,i_test},sub_dim);
end

%% 计算K_D
K_D = zeros(size(X_Train,2),size(X_Train,2));
for i_test = 1 : size(X_Train,2)
    train_i = X_Train{1,i_test};
    for j = 1 : size(X_Train,2)
        train_j = X_Train{1,j};
        K_D(i_test,j) = norm(train_j'*train_i,'fro')^2;
    end
end
clear train_i train_j;

%% 计算K_XD
K_XD = zeros(size(X_Train,2),size(X_Test,2));
for i_test = 1 : size(X_Train,2)
    train_i = X_Train{1,i_test};
    for j = 1 : size(X_Test,2)
        test_j = X_Test{1,j};
        K_XD(i_test,j) = norm(train_i'*test_j,'fro')^2;
    end
end

%% 计算K_Z
K_Z = cell(1,num_class);
for i_test = 1 : num_class
    Z = X_Train;
    ind_i = find(Train_label==i_test);
    for ii = 1 : length(ind_i)
        ind_temp = ind_i(ii);
        Z{1,ind_temp} = zeros(size(X_Train{1,ind_temp},1),size(X_Train{1,ind_temp},2));
    end
    Temp = zeros(size(X_Train,2),size(X_Train,2));
    for j = 1 : size(Z,2)
        z_j = Z{1,j};
        for k = 1 : size(Z,2)
            z_k = Z{1,k};
            Temp(j,k) = norm(z_k'*z_j,'fro')^2;
        end
    end
    K_Z{1,i_test} = Temp;
    clear Z Temp;
end

%% 计算A
[KD_U,KD_D,~] = svd(K_D);
A = diag(sqrt(diag(KD_D)))*KD_U';
%% 计算y*
D_Inv = KD_U*diag(1./sqrt(diag(KD_D)));
qX = D_Inv'*K_XD;

%% 求解beta
KZ_SUM = zeros(size(X_Train,2),size(X_Train,2));
for i_test = 1 : size(K_Z,2)
    KZ_SUM = KZ_SUM + K_Z{1,i_test};
end
I = eye(size(X_Train,2));
H = A'*A + lambda1*I + lambda2*KZ_SUM;
beta = inv(H)*A'*qX;

a1 = norm(qX-A*beta,'fro')^2;
a2 = lambda1*norm(beta,2)^2;
a3 = lambda2*trace(beta'*KZ_SUM*beta);

%% 分类
% y_hat = Classify_pro(K_Z,beta,Train_label);
y_hat = Classify_CRC(A,Train_label,beta,qX);
% y_hat = Classify_CRCpro(K_Z,beta,Train_label,A,qX);
accuracy = sum(double(y_hat == Test_label))/length(Test_label);

%% 输出
fprintf('Correct recognition accuracy with a labeled dictionary : %.1f%%.\n',100*accuracy);



