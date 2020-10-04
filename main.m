
%Input :
%X - The original data matrix;
%lambda - The control parameter of LRR; 
%dist_Z dist_E -The distance metrics of K-means for clustering Z and E
%, respectively; 
%maxIterNum - The max number of iteration.

% Output :
% I_z - The clustering results, among which the labels of
% unlabeled samples are predicted. 


clear all;
close all;
load GCM.mat;


X=transpose(fea);

lambda=0.5;
%Step 1: Perform LRR on original data matrix X

[Z,E] = lrr(X,lambda);

[d,n]=size(X);
p=144;%for GCM dataset p is number of labelled samples out of n
C=14; % no of cancer types in GCM dataset


[r_gnd,c_gnd]=size(gnd);
GND=zeros(r_gnd,2);
for i=1:r_gnd
GND(i,1)=gnd(i,1);
if(i<=p)
    GND(i,2)=1;
else
    GND(i,2)=0;
end
end

[rz,cz]=size(Z);
Zm=zeros(rz+1,cz);

    for j=1:cz
        Zm(1:rz,j)=Z(:,j);
        Zm(rz+1,j)=GND(j,1);
    end
[re,ce]=size(E);
Em=zeros(re+1,ce);

    for j=1:ce
        Em(1:re,j)=E(:,j);
        Em(re+1,j)=GND(j,1);
    end



maxIterNum=200;
currentIterNum =0;
while(1)


%Step 2: Perform K-means algorithm on Z and E , respectively.    
 eps_Z=8;
 I_Z=K_Means(Zm,eps_Z,C,GND);
 
 eps_E=1;
 I_E=K_Means(Em,eps_E,C,GND);
 currentIterNum =currentIterNum +1;
%Step 3: Select unlabeled samples as labeled ones for next round clustering. 
 S=find((I_Z-I_E)==0);
 [rS,cS]=size(S);
 
 for i=1:rS
 %modify class no of GND and Em , Zm
 %modify labeled unlabled info 0 / 1 in GND
 GND(S(i),1)=Zm(rz+1,S(i));
 Zm(rz+1,S(i))=GND(S(i),1);
 Em(re+1,S(i))=GND(S(i),1);
 GND(S(i),2)=1;
end
%  if(rS==0 ||  )
%  end
%  
if (currentIterNum > maxIterNum || (rS-144)==0)
break;
end

end

KK=find(I_Z(145:198,1)-GND(145:198,1)==0);
[rKK,cKK]=size(KK);
test_accuracy=rKK/54*100


g1 = GND(145:198,1);		% Known groups
g2 = I_Z(145:198,1);	% Predicted groups

[C,order] = confusionmat(g1,g2);

test_accuracy_from_confusion_matrix=trace(C)/54.0*100

xlswrite('ConfMat.xls',C);
