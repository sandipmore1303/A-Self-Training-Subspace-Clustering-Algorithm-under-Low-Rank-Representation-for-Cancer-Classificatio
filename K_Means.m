function [I] = K_Means(Z,eps,noofclasses,GND)
Z_tl=find(GND(:,2)==1);
[r_Ztl,c_Ztl]=size(Z_tl);% 144*1
[r_Z,c_Z]=size(Z);% 11371*198
Z_l=[];

    for j=1:r_Ztl%144
    Z_l=[Z_l Z(:,Z_tl(j,1))];
   
    end

    
Z_tu=find(GND(:,2)==0);
[r_Ztu,c_Ztu]=size(Z_tu);
[r_Z,c_Z]=size(Z);
Z_u=[];

    for j=1:r_Ztu
    Z_u=[Z_u Z(:,Z_tu(j,1))];
    end   


I=GND(:,1);

[r_Zl,c_Zl]=size(Z_l);

[r_Zu,c_Zu]=size(Z_u);

Centroids=zeros(r_Zl-1,noofclasses);

for j=1:noofclasses
    
    ind=find(Z_l(r_Zl,:)==(j-1));
    [r_ind,c_ind]=size(ind);
    sum=zeros(r_Zl-1,1);%sum of current class samples
        for i=1:c_ind
            sum(:,1)=sum(:,1)+Z_l(1:r_Zl-1,ind(i));
        end
        Centroids(:,j)=sum/c_ind;
end
 
%find distances of each unlabelled samples in Zu from all centroids

for i=1:c_Zu
    temp1=transpose(Z_u(1:r_Zu-1,i));
    for j=1:noofclasses
        temp2=transpose(Centroids(:,j));
        distance(j,1)=pdist([temp1;temp2],'minkowski',eps);
    end 
    [rd,cd]=size(distance);
    [ind_C,I_ind]=min(distance);
    I(i+c_Zl,1)=I_ind;
end



