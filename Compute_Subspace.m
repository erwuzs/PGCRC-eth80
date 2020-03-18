function sub = Compute_Subspace(data,sub_dim)
% �����ӿռ�
%
% Input:
%     data: һ�����ݾ���
%     sub_dim: �̶����ӿռ��ά��
% Output:
%     sub: �ӿռ�

Y1=data;
y1_mu = mean(Y1,2);
    
Y1 = Y1-repmat(y1_mu,1,size(Y1,2));
Y1 = Y1*Y1'/(size(Y1,2)-1);
lamda = 0.001*trace(Y1);
Y1 = Y1+lamda*eye(size(Y1,1));
    
[U, S, V] = svd(Y1);    
sub= U(:,1:sub_dim);
       
