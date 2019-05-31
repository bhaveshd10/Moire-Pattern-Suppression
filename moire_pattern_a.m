%% Radiograph of Skull
clear all;clc;close all;
% Read Image
image=imread('Radiograph_1.jpg');
% Define sigma and find the phase and magnitude of image
sigma=20;
fft1=fft2(image);
phase=angle(fft1);
mag1=abs(fft1);
% Shifted log magnitude plot for better localization of moire patterns 
fft1=fftshift(fft1);
mag2=log(1+abs(fft1));
figure,imshow(mag2,[]),title('shifted magnitude plot')

% Find Intensity peaks due to moire patterns in magnitude plot
U1=[261 122];
U2=[267 82];
U3=[245 218];
U4=[239 258];
[l,n]=size(image);

% Create the notch Filters
for i=1:l
    for j=1:n        
        H1(i,j)=1-exp(-((i-U1(2)).^2+(j-U1(1)).^2)./(sigma)^2);
    end
end

for a=1:l
    for b=1:n        
        H2(a,b)=1-exp(-((a-U2(2)).^2+(b-U2(1)).^2)./(sigma)^2);
    end
end

for c=1:l
    for d=1:n  
        H3(c,d)=1-exp(-((c-U3(2)).^2+(d-U3(1)).^2)./(sigma)^2);
    end
end

for e=1:l
    for f=1:n
        H4(e,f)=1-exp(-((e-U4(2)).^2+(f-U4(1)).^2)./(sigma)^2);
    end
end
 
H=H1.*H2.*H3.*H4;
figure,imshow(H),title('notch filter')
h=fftshift(H);

transform_magplot=mag2.*H;
figure,imshow(transform_magplot,[]),title('notch filter on magnitude plot')

% Final output of magnitude
output=mag1.*h;
% Reconstruct image using phase and newly found magnitude
recon_image=output.*exp(1i*phase);
% Inverse fft
final=ifft2(recon_image);
% Display Image
figure,subplot(1,2,1),imshow(image),title('original image')
subplot(1,2,2),imshow(final,[]),title('filtered image sigma 20')
   


