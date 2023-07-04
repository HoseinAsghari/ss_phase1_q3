clc;clear all;
%% read our images
marilyn=imread('marilyn.jpg'); 
einstein=imread('einstein.jpg');
[m1,n1,c1]=size(marilyn);%get size of matrix related to image
[m2,n2,c2]=size(einstein);%get size of matrix related to image
% einstein's size is less than marilyn's so bt upsampling with ones we make
% einstein larger
x=ones(1,n2,c2);
einstein=vertcat(einstein,x); 
%% convert them from rgb to gray
I1=im2gray(marilyn); 
I2=rgb2gray(einstein);
%% compute fft2 of the gray images
fft_marilyn=fft2(I1);
fft_einstein=fft2(I2); 
%% zero centered scaling
fft_einstein_shift=fftshift(fft_einstein);
fft_marilyn_shift=fftshift(fft_marilyn);
%% low pass gaussian filter for marilyn
[x,y]=meshgrid(0:n1-1,0:m1-1);
cut_off=7;%our cut_off frequency of sigma in gaussian distribution
lpf=exp(-((x-(m1/2)).^2 + (y-(n1/2)).^2)./((2*cut_off).^2));
% d=zeros(m1,n1);
% lpf=zeros(m1,n1);
%     for i=1:m1
%     for j=1:n1
%          d(i,j)=sqrt(((i-(m1/2))^2)+((j-(n1/2))^2));
%  lpf(i,j)=1-exp(-(d(1,j)^2)/(2*cut_off.^2));
%     end
%     end
   %% low pass gaussian filter for einstein
   hpf=1-lpf;
   %% define a circulat filter
[x,y]=meshgrid(-n1/2:n1/2 -1,-m1/2:m1/2 -1);
k=80e-4;
HPF=k.*sqrt((x.^2 + y.^2));
HPF=fftshift(HPF);
 LPF=1-HPF;
   %% filtering our images
   x_marilyn=ifft2(ifftshift((fft_marilyn_shift.*lpf.*LPF)));
x_einstein=ifft2(ifftshift((fft_einstein_shift.*hpf.*HPF)));
%% plot
figure(1)
subplot(1,3,1)
imshow(marilyn)
title('marilyn')
subplot(1,3,2)
imshow(einstein)
title('einstein')
subplot(1,3,3)
imshow(abs(x_marilyn),[20,290]);
 imshow(abs(x_einstein),[20,290]);
title('hybrid')
