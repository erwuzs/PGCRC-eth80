function outLabel = Classify_CRCpro(K_Z,beta,Train_label,A,qX)
%CLASSIFY_CRC+PRO 此处显示有关此函数的摘要
%   此处显示详细说明
u1=0.99;
u2=1-u1;
Number_Of_Classes = max(Train_label);
%
res_CRCpro=zeros(size(K_Z,2),size(beta,2));

res_CRC = zeros(Number_Of_Classes,size(beta,2));
for tmpC1 = 1:Number_Of_Classes
    classIndex = (Train_label==tmpC1);
    delta_x = zeros(size(beta));
    delta_x(classIndex,:) = beta(classIndex,:);
    a=sqrt(sum((qX - A*delta_x).^2));
    b=delta_x.^2;
    res_CRC(tmpC1,:) = sqrt(sum((qX - A*delta_x).^2))./sqrt(sum(delta_x.^2));
end
res_pro = zeros(Number_Of_Classes,size(beta,2));
for i=1:size(K_Z,2)
    for j=1:size(beta,2)
        res_pro(i,j)=beta(:,j)'*K_Z{1,i}*beta(:,j);
    end
end
% nor_resCRC=res_CRC;
% nor_respro=res_pro;
nor_resCRC=normalize(res_CRC);
nor_respro=normalize(res_pro);
for i=1:size(K_Z,2)
    for j=1:size(beta,2)
        res_CRCpro(i,j)=u1*nor_resCRC(i,j)+u2*nor_respro(i,j);
    end
end
[~,MinIndex] = min(res_CRCpro);
outLabel = MinIndex;
end

