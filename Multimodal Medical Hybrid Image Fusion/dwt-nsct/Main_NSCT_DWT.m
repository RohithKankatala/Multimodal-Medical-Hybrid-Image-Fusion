clc;
clear all;
close all;
 
%% Inputs

fp=uigetfile('*.jpg;*.bmp;*.tif;*.gif;*.png;*.jpeg');
I=imread(fp);

  if size(I,3)>1
            I = rgb2gray(I);
  end
figure;
imshow(I);
title('Image1');

fp=uigetfile('*.jpg;*.bmp;*.tif;*.gif;*.png;*.jpeg');
J=imread(fp);

  if size(J,3)>1
            J = rgb2gray(J);
  end
figure;
imshow(J);
title('Image2');
%%

% Parameteters:
nlevels = 0; %[0, 1, 3] ;        % Decomposition level
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter dmaxflat7
% build mex
% build lib
yj = nsctdec( double(J), nlevels, dfilter, pfilter );
yi = nsctdec( double(I), nlevels, dfilter, pfilter );

[A1,H1,V1,D1] = dwt2(yi{1,1},'sym4');
[A2,H2,V2,D2] = dwt2(yj{1,1},'sym4');

A=A1+A2;

[s1, s2]=size(A1);

for i=1:s1
    for j=1:s2
        if(H1(i,j)>=H2(i,j))
            H(i,j)=H1(i,j);
        else
            H(i,j)=H2(i,j);
        end
    end
end

for i=1:s1
    for j=1:s2
        if(V1(i,j)>=V2(i,j))
            V(i,j)=V1(i,j);
        else
            V(i,j)=V2(i,j);
        end
    end
end

for i=1:s1
    for j=1:s2
        if(D1(i,j)>=D2(i,j))
            D(i,j)=D1(i,j);
        else
            D(i,j)=D2(i,j);
        end
    end
end

y{1,1} = idwt2(A,H,V,D,'sym4');
y{1,2}=yj{1,2}+yi{1,2};



Final = nsctrec(y);

Final=mat2gray(Final);
figure;
imshow(Final);
title('Fused Image');

%% Performance measuaring
 ent=entropy(Final);
 fprintf('ENTROPY=%f',ent);
 

 I=double((I));

 psnr1=psnr(I, Final);
 fprintf('\nPSNR1=%f',psnr1);

 J=double((J));
 
 psnr2=psnr(Final, J);
 fprintf('\nPSNR2=%f',psnr2);
 
 Finalg=double(Final);
 SDE=std(Finalg);
 SDE=mean(SDE);
 fprintf('\nStandard Devation=%f',SDE);