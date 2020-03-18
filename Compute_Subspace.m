function sub = Compute_Subspace(data,sub_dim)
% 计算子空间
%
% Input:
%     data: 一个数据矩阵
%     sub_dim: 固定的子空间的维数
% Output:
%     sub: 子空间

Y1=data;
y1_mu = mean(Y1,2);
    
Y1 = Y1-repmat(y1_mu,1,size(Y1,2));
Y1 = Y1*Y1'/(size(Y1,2)-1);
lamda = 0.001*trace(Y1);
Y1 = Y1+lamda*eye(size(Y1,1));
    
[U, S, V] = svd(Y1);    
sub= U(:,1:sub_dim);
       
