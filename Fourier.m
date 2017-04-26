
%#just change the file path to load the image.


v1 = imread('characters/Vs/V2.GIF'); s1 = imread('characters/Ss/S2.GIF'); t1 = imread('characters/Ts/T1.GIF'); %reading in the images 

ftv1 = fftshift( fft2(double(v1)) ); fts1 = fftshift( fft2(double(s1)) ); ftt1 = fftshift( fft2(double(t1)) ); %applying fourier transform and fourier shift

%%plotting the phase%%

%%Magnitude%%
V1_Mag = abs(ftv1);
S1_Mag = abs(fts1);
T1_Mag = abs(ftt1);


%Extrac a box region.
box = Extract_Box_Original_Size(ftt1, 100, 300, 200, 500);
box_power = Sum_Power(abs(box));
inverse_box = ifft2(ifftshift(box));
%figure('Name', 'box'); imshow(real(inverse_box));  axis off; 

%extract a ring region
ring = Extract_Ring(ftt1, 127, 62);
ring_power = Sum_Power(abs(ring));
inverse_ring = ifft2(ifftshift(ring));
%figure('Name', 'ring'); imagesc(log(abs(ring)+1));  axis off;



% convolution gradiant 
fx = [-1 0 1; -2 0 2; -1 0 1];
fy = [1 2 1; 0 0 0; -1 -2 -1];
gx = conv2(double(v1),double(fx))/8;
gy = conv2(double(v1),double(fy))/8;
mag = sqrt((gx).^2+(gy).^2);
ang = atan(gy./gx);
%figure('Name','Magnitude'); imagesc(mag); axis off; colormap gray
%figure('Name','Angle'); imagesc(ang); axis off; colormap gray


[S, V, T] = extractSpectralFeature();

%%%Figures for each letter, uncomment to show%%%
%figure('Name','Fourier space of V not reduced');
%imagesc(log(V1_Mag+1));
%figure('Name','Fourier space of S not reduced');
%imagesc(log(S1_Mag+1));
%figure('Name','Fourier space of T not reduced');
%imagesc(log(T1_Mag+1))

